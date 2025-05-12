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
    @State private var attempts = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter PIN")
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
                    // PIN is correct, access granted
                    showError = false
                } else {
                    // PIN is incorrect
                    showError = true
                    errorMessage = "Incorrect PIN. Please try again."
                    attempts += 1
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
            
            // Show Face ID button if available and enabled
            if pinManager.biometricType != .none && pinManager.useBiometrics {
                Button(action: {
                    authenticateWithBiometrics()
                }) {
                    HStack {
                        Image(systemName: pinManager.biometricType == .faceID ? "faceid" : "touchid")
                        Text(pinManager.biometricType == .faceID ? "Use Face ID" : "Use Touch ID")
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
                .padding(.top, 8)
            }
            
            Button(action: {
                // Allow PIN reset option (in a real app, this would require additional authentication)
                pinManager.resetPIN()
            }) {
                Text("Forgot PIN?")
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Try biometric authentication automatically if enabled
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

//struct PINEntryView: View {
//    @ObservedObject var pinManager: PINManager
//    @State private var pin = ""
//    @State private var showError = false
//    @State private var attempts = 0
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Enter PIN")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//            
//            Text("Enter your PIN to access the application")
//                .font(.subheadline)
//                .padding(.bottom)
//            
//            SecureField("Enter PIN", text: $pin)
//                .keyboardType(.numberPad)
//                .textContentType(.oneTimeCode)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//            
//            if showError {
//                Text("Incorrect PIN. Please try again.")
//                    .foregroundColor(.red)
//                    .font(.callout)
//            }
//            
//            Button(action: {
//                if pinManager.validatePIN(pin: pin) {
//                    // PIN is correct, access granted
//                    showError = false
//                } else {
//                    // PIN is incorrect
//                    showError = true
//                    attempts += 1
//                    pin = ""
//                }
//            }) {
//                Text("Submit")
//                    .fontWeight(.bold)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .disabled(pin.isEmpty)
//                        
//            Spacer()
//        }
//        .padding()
//    }
//}


struct BiometricPermissionView: View {
    @ObservedObject var pinManager: PINManager
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: pinManager.biometricType == .faceID ? "faceid" : "touchid")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text(pinManager.biometricType == .faceID ? "Enable Face ID" : "Enable Touch ID")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("TVMaze would like to use \(pinManager.biometricType == .faceID ? "Face ID" : "Touch ID") for faster and more secure access to your account.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                pinManager.useBiometrics = true
                isShowing = false
            }) {
                Text("Enable")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                pinManager.useBiometrics = false
                isShowing = false
            }) {
                Text("Not Now")
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

// 6. Info.plist considerations (add as a comment to help implementation)
/*
Add these keys to your Info.plist:

<key>NSFaceIDUsageDescription</key>
<string>We use Face ID to securely authenticate you and protect your data.</string>

This is required to use Face ID functionality.
*/
