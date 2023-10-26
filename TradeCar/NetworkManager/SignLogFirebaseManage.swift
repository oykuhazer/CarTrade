//
//  SignLogFirebaseManage.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import Firebase
import FirebaseAuth

class SignLogFirebaseManage {
    // Create a singleton instance of SignLogFirebaseManage.
    static let shared = SignLogFirebaseManage()
    
    // Private initializer to enforce the use of the singleton instance.
    private init() {}
    
    // Configure Firebase when initializing the class.
    func configure() {
        FirebaseApp.configure()
    }
    
    // Sign up a user with email and password and provide a completion handler.
    func signUp(withEmail email: String, password: String, completion: @escaping (String?, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion("Error", error.localizedDescription)
            } else {
                completion("Done", "Registration has been completed successfully.")
            }
        }
    }
    
    // Log in a user with email and password and provide a completion handler.
    func logIn(withEmail email: String, password: String, completion: @escaping (String?, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion("Error", error.localizedDescription)
            } else {
                completion("Done", "The login process has been completed successfully.")
            }
        }
    }
}
