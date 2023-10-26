//
//  EntryViewModel.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit

class EntryViewModel {
    // Arrays to store car brands, models, prices, and model images.
    var carBrands: [String] = []
    var models: [String] = []
    var carPrices: [String] = []
    var modelImages: [String: UIImage] = [:]
    
    // Array to store car types.
    var carTypes: [String] = ["Crossover", "Sedan", "Hatchback", "Van", "Crossover", "Hybrid", "EV", "Coupe"]
      
    // Dictionary to map brand names to their respective images.
    var brandImages: [String: String] = [
        "TOYOTA": "TOYOTA",
        "HONDA": "HONDA",
        "BMW": "BMW",
        "MERCEDES-BENZ": "MERCEDES-BENZ",
        "FORD": "FORD",
        "AUDI": "AUDI",
        "NISSAN": "NISSAN",
        "VOLKSWAGEN": "VOLKSWAGEN"
    ]
    
    // Fetch car brands from Firebase and update the carBrands array.
    func fetchDataFromFirebase(completion: @escaping () -> Void) {
        EntryFirebaseManage.shared.fetchCarBrands { [weak self] carBrands in
            self?.carBrands = carBrands
            completion()
        }
    }

    // Fetch random car models and their prices from Firebase.
    func fetchRandomModels(completion: @escaping () -> Void) {
        EntryFirebaseManage.shared.fetchRandomCarModels { [weak self] models, prices in
            self?.models = models
            self?.carPrices = prices
            completion()
            
            // Fetch images for each model.
            for modelInfo in models {
                self?.fetchImagesForModel(modelInfo)
            }
        }
    }

    // Fetch and update the image for a specific car model.
    func fetchImagesForModel(_ modelName: String) {
        EntryFirebaseManage.shared.downloadImageForModel(modelName) { [weak self] image in
            if let image = image {
                self?.updateImageForModel(modelName, image: image)
            }
        }
    }

    // Update the modelImages dictionary with the image for a specific model.
    func updateImageForModel(_ modelName: String, image: UIImage) {
        modelImages[modelName] = image
    }
}
