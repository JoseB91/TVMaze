//
//  PINSetupView.swift
//  TVMaze
//
//  Created by José Briones on 11/5/25.
//

import SwiftUI

struct PINSetupView: View {
    @ObservedObject var pinManager: PINManager
    @State private var pin = ""
    @State private var confirmPin = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var offerBiometrics = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Tvmaze app!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Create a PIN code to secure your application")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            SecureField("Enter 4 digits PIN", text: $pin)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: pin) { newValue in
                    if newValue.count > 4 {
                        pin = String(newValue.prefix(4))
                    }
                }
            
            SecureField("Confirm 4 digits PIN", text: $confirmPin)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: confirmPin) { newValue in
                    if newValue.count > 4 {
                        confirmPin = String(newValue.prefix(4))
                    }
                }
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
                        
            Button(action: {
                if validateAndSavePIN() {
                    if pinManager.biometricType != .none && pinManager.useBiometrics {
                        offerBiometrics = true
                    }
                }
            }) {
                Text("Save PIN")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(pin.isEmpty || confirmPin.isEmpty)
        }
        .padding()
        .alert(isPresented: $offerBiometrics) {
            Alert(
                title: Text(pinManager.biometricType == .faceID ? "Set Up Face ID" : "Set Up Touch ID"),
                message: Text("Would you like to use \(pinManager.biometricType == .faceID ? "Face ID" : "Touch ID") for quicker access to the app?"),
                primaryButton: .default(Text("Set Up")) {
                    pinManager.useBiometrics = true
                },
                secondaryButton: .cancel {
                    pinManager.useBiometrics = false
                }
            )
        }
    }
    
    private func validateAndSavePIN() -> Bool {
        if pin != confirmPin {
            errorMessage = "PINs don't match. Please try again."
            showError = true
            return false
        }
        
        let success = pinManager.setupPIN(pin: pin)
        if !success {
            errorMessage = "PIN must contains 4 digits."
            showError = true
            return false
        }
        
        return true
    }
}
