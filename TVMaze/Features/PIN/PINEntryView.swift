//
//  PINEntryView.swift
//  TVMaze
//
//  Created by José Briones on 11/5/25.
//

import SwiftUI

struct PINEntryView: View {
    @ObservedObject var pinManager: PINManager
    @State private var pin = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("TVmaze")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Enter your PIN to access the application")
                .font(.subheadline)
                .padding(.bottom)
            
            SecureField("Enter PIN", text: $pin)
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
            
            Button(action: {
                if pinManager.validatePIN(pin: pin) {
                    showError = false
                } else {
                    showError = true
                    errorMessage = "Incorrect PIN. Please try again."
                    pin = ""
                }
            }) {
                Text("Submit")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(pin.isEmpty)
        }
        .padding()
        .onAppear {
            if pinManager.useBiometrics {
                authenticateWithBiometrics()
            }
        }
    }
    
    private func authenticateWithBiometrics() {
        pinManager.authenticateWithBiometrics { success in
            if !success {
                showError = true
                errorMessage = "Biometric authentication failed. Please use your PIN."
            }
        }
    }
}
