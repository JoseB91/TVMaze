//
//  PINManager.swift
//  TVMaze
//
//  Created by José Briones on 11/5/25.
//

import Foundation
import LocalAuthentication

class PINManager: ObservableObject {
    private let pinKey = "app_pin_code"
    private let isSetupKey = "pin_is_setup"
    private let useBiometricsKey = "use_biometrics"
    
    @Published var isPINSetup: Bool
    @Published var isAuthenticated: Bool = false
    @Published var useBiometrics: Bool {
        didSet {
            UserDefaults.standard.set(useBiometrics, forKey: useBiometricsKey)
        }
    }
    
    // Biometric authentication properties
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .faceID:
                return .faceID
            case .touchID:
                return .touchID
            default:
                return .none
            }
        } else {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    init() {
        // Check if PIN is already set up
        self.isPINSetup = UserDefaults.standard.bool(forKey: isSetupKey)
        self.useBiometrics = UserDefaults.standard.bool(forKey: useBiometricsKey)
    }
    
    func setupPIN(pin: String) -> Bool {
        // Validate PIN (must be 4-6 digits)
        guard pin.count >= 4 && pin.count <= 6, pin.allSatisfy({ $0.isNumber }) else {
            return false
        }
        
        // Store PIN securely (in a real app, use Keychain instead of UserDefaults)
        UserDefaults.standard.set(pin, forKey: pinKey)
        UserDefaults.standard.set(true, forKey: isSetupKey)
        isPINSetup = true
        isAuthenticated = true
        return true
    }
    
    func validatePIN(pin: String) -> Bool {
        guard let storedPIN = UserDefaults.standard.string(forKey: pinKey) else {
            return false
        }
        
        let isValid = storedPIN == pin
        if isValid {
            isAuthenticated = true
        }
        return isValid
    }
    
    func resetPIN() {
        UserDefaults.standard.removeObject(forKey: pinKey)
        UserDefaults.standard.set(false, forKey: isSetupKey)
        isPINSetup = false
        isAuthenticated = false
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        let reason = "Unlock TVMaze app"
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                }
                completion(success)
            }
        }
    }
}

//class PINManager: ObservableObject {
//    private let pinKey = "app_pin_code"
//    private let isSetupKey = "pin_is_setup"
//    
//    @Published var isPINSetup: Bool
//    @Published var isAuthenticated: Bool = false
//    
//    init() {
//        self.isPINSetup = UserDefaults.standard.bool(forKey: isSetupKey)
//    }
//    
//    func setupPIN(pin: String) -> Bool {
//        guard pin.count == 4, pin.allSatisfy({ $0.isNumber }) else {
//            return false
//        }
//        
//        // Store PIN securely (in a real app, use Keychain instead of UserDefaults)
//        UserDefaults.standard.set(pin, forKey: pinKey)
//        UserDefaults.standard.set(true, forKey: isSetupKey)
//        isPINSetup = true
//        isAuthenticated = true
//        return true
//    }
//    
//    func validatePIN(pin: String) -> Bool {
//        guard let storedPIN = UserDefaults.standard.string(forKey: pinKey) else {
//            return false
//        }
//        
//        let isValid = storedPIN == pin
//        if isValid {
//            isAuthenticated = true
//        }
//        return isValid
//    }
//    
//    func resetPIN() {
//        UserDefaults.standard.removeObject(forKey: pinKey)
//        UserDefaults.standard.set(false, forKey: isSetupKey)
//        isPINSetup = false
//        isAuthenticated = false
//    }
//}
