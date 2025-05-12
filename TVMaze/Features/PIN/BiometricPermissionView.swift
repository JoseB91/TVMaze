//
//  BiometricPermissionView.swift
//  TVMaze
//
//  Created by José Briones on 12/5/25.
//

import SwiftUI

struct BiometricPermissionView: View {
    @ObservedObject var pinManager: PINManager
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: pinManager.biometricType == .faceID ? "faceid" : "touchid")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text(pinManager.biometricType == .faceID ? "Face ID Authentication" : "Enable Touch ID")
                .font(.title)
                .fontWeight(.bold)
            
            Text("TVmaze would like to use \(pinManager.biometricType == .faceID ? "Face ID" : "Touch ID") for quicker and more secure access to the application in the future. You can deny permission on next launch.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                pinManager.useBiometrics = true
                isShowing = false
            }) {
                Text("OK")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
