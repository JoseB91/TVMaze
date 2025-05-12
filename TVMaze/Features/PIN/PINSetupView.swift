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
            Text("Set a PIN")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Create a PIN code to secure your application")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            SecureField("Enter PIN (4-6 digits)", text: $pin)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            SecureField("Confirm PIN", text: $confirmPin)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
            
            // Show Face ID/Touch ID option if available
            if pinManager.biometricType != .none && !offerBiometrics {
                Toggle(
                    pinManager.biometricType == .faceID ? "Use Face ID for future logins" : "Use Touch ID for future logins",
                    isOn: $pinManager.useBiometrics
                )
                .padding(.vertical)
            }
            
            Button(action: {
                if validateAndSavePIN() {
                    // PIN setup successful
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
            
            Spacer()
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
        // Check if PINs match
        if pin != confirmPin {
            errorMessage = "PINs don't match. Please try again."
            showError = true
            return false
        }
        
        // Attempt to save PIN
        let success = pinManager.setupPIN(pin: pin)
        if !success {
            errorMessage = "PIN must be 4-6 digits only."
            showError = true
            return false
        }
        
        return true
    }
}
