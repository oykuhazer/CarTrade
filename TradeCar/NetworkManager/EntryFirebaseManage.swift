//
//  EntryFirebaseManage.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import RxSwift

class EntryFirebaseManage {
    // Create a singleton instance of EntryFirebaseManage.
    static let shared = EntryFirebaseManage()
    
    // Initialize references to the Firebase Database and Storage.
    private let databaseRef = Database.database().reference()
    private let storageRef = Storage.storage().reference()
    
    // Private initializer to enforce the use of the singleton instance.
    private init() { }
    
    // Fetch car brands from the database and provide them in a completion handler.
    func fetchCarBrands(completion: @escaping ([String]) -> Void) {
        let modelnamesRef = self.databaseRef.child("modelnames")
        
        modelnamesRef.observeSingleEvent(of: .value) { snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                completion([])
                return
            }
            
            let carBrands = children.compactMap { $0.key }
            completion(carBrands)
        }
    }
    
    // Fetch random car models and their prices from the database and provide them in a completion handler.
    func fetchRandomCarModels(completion: @escaping ([String], [String]) -> Void) {
        let modelnamesRef = self.databaseRef.child("modelnames")
        
        modelnamesRef.observeSingleEvent(of: .value) { snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                completion([], [])
                return
            }
            
            var allModels: [String] = []
            var allPrices: [String] = []
            
            for child in children {
                if let models = child.children.allObjects as? [DataSnapshot] {
                    for model in models.prefix(6) {
                        if let modelName = model.key as? String {
                            var modelInfo = modelName
                            
                            if let price = model.childSnapshot(forPath: "Price").value as? String {
                                allPrices.append(price)
                            } else {
                                allPrices.append("Price not available")
                            }
                            
                            allModels.append(modelInfo)
                        }
                    }
                }
            }
            
            // Shuffle the models and provide them with their prices.
            let shuffledModels = allModels.shuffled()
            completion(shuffledModels, allPrices)
        }
    }
    
    // Download an image for a car model and provide it in a completion handler.
    func downloadImageForModel(_ modelName: String, completion: @escaping (UIImage?) -> Void) {
        let modelImagesRef = self.storageRef.child("model_images")
        
        modelImagesRef.child("\(modelName).png").getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image for \(modelName): \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}
