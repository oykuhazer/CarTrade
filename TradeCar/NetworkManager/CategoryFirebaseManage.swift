//
//  CategoryFirebaseManage.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit
import RxSwift
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class CategoryFirebaseManage {
    // Create a singleton instance of CategoryFirebaseManage.
    static let shared = CategoryFirebaseManage()

    // Private initializer to enforce the use of the singleton instance.
    private init() {}

    // Configure Firebase when initializing the class.
    func configure() {
        FirebaseApp.configure()
    }

    // Fetch models for a given brand and provide them in a Single observable.
    func fetchModels(forBrand brand: String) -> Single<[String]> {
        return Single.create { single in
            let databaseRef = Database.database().reference()
            let modelsRef = databaseRef.child("modelnames").child(brand)
            modelsRef.observeSingleEvent(of: .value) { (snapshot) in
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    let modelNames = children.compactMap { $0.key as? String }
                    single(.success(modelNames))
                } else {
                    single(.success([]))
                }
            }
            return Disposables.create()
        }
    }

    // Fetch the price for a specific brand and model and provide it in a Single observable.
    func fetchModelPrice(brand: String, model: String) -> Single<String?> {
        return Single.create { single in
            let databaseRef = Database.database().reference()
            let priceRef = databaseRef.child("modelnames").child(brand).child(model).child("Price")
            priceRef.observeSingleEvent(of: .value) { (snapshot) in
                if let price = snapshot.value as? String {
                    single(.success(price))
                } else {
                    single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }

    // Fetch an image for a given model name and provide it in a Single observable.
    func fetchModelImage(modelName: String) -> Single<UIImage?> {
        return Single.create { single in
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child("model_images/\(modelName).png")
            imageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Picture not received: \(error.localizedDescription)")
                    single(.success(nil))
                } else if let imageData = data, let image = UIImage(data: imageData) {
                    single(.success(image))
                } else {
                    print("The image data is not valid or could not be converted.")
                    single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }
}
