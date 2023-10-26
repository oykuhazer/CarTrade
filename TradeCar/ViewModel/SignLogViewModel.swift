//
//  SignLogViewModel.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation

class SignLogViewModel {
    // Private properties to store email and password.
    private var email: String = ""
    private var password: String = ""
    
    // Indicates whether the user is signing up or logging in.
    var isSignUp: Bool = false {
        didSet {
            updateSignUpButtonText?()
        }
    }
    
    // Closure to update the sign-up button text when isSignUp changes.
    var updateSignUpButtonText: (() -> Void)?
    
    // Set the email for authentication.
    func setEmail(_ email: String) {
        self.email = email
    }
    
    // Set the password for authentication.
    func setPassword(_ password: String) {
        self.password = password
    }
    
    // Perform the sign-up or login action.
    func signUpOrLogIn(completion: @escaping (String?, String?) -> Void) {
        if email.isEmpty {
            completion("Warning", "Please enter a valid email address.")
            return
        }
        
        if password.isEmpty {
            completion("Warning", "Please enter a password.")
            return
        }
        
        // Check if the password meets the required strength.
        if passwordStrength() < 1.0 {
            completion("Warning", "The password is not strong enough. Please use a stronger password.")
            return
        }
        
        if isSignUp {
            // Perform the sign-up action using the shared SignLogFirebaseManage.
            SignLogFirebaseManage.shared.signUp(withEmail: email, password: password, completion: completion)
        } else {
            // Perform the login action using the shared SignLogFirebaseManage.
            SignLogFirebaseManage.shared.logIn(withEmail: email, password: password, completion: completion)
        }
    }
    
    // Evaluate the strength of the password.
    private func passwordStrength() -> Float {
        var progress: Float = 0.0
        let minPasswordLength = 8
        
        if password.count >= minPasswordLength {
            progress += 0.5
        }
        
        // Check if the password contains special characters.
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: ".,;*%&:")) != nil {
            progress += 0.5
        }
        
        return progress
    }
}
