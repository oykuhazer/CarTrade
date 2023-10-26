//
//  CartFirebaseManage.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

class CartFirebaseManage {
    // Create a singleton instance of CartFirebaseManage.
    static let shared = CartFirebaseManage()

    // Initialize Firestore and Firebase Storage.
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    // Fetch cart items and provide them in a completion handler.
    func fetchCartItems(completion: @escaping ([String]?) -> Void) {
        let cartCollection = db.collection("cartItems")

        cartCollection.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error retrieving data: \(error.localizedDescription)")
                completion(nil)
            } else if let documents = snapshot?.documents {
                let cartItems = documents.compactMap { document -> String? in
                    if let model = document["model"] as? String,
                       let brand = document["brand"] as? String,
                       let price = document["price"] as? String {
                        return "\(brand) - \(model) - \(price)"
                    }
                    return nil
                }
                completion(cartItems)
            } else {
                completion(nil)
            }
        }
    }

    // Add an item to the cart.
    func addToCart(brand: String, model: String, price: String) {
        let cartCollection = db.collection("cartItems")

        cartCollection.addDocument(data: [
            "brand": brand,
            "model": model,
            "price": price
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            }
        }
    }

    // Remove an item from the cart and provide a completion handler.
    func removeFromCart(brand: String, model: String, completion: @escaping () -> Void) {
        let cartCollection = db.collection("cartItems")

        cartCollection.whereField("brand", isEqualTo: brand)
            .whereField("model", isEqualTo: model)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error deleting data: \(error.localizedDescription)")
                    completion()
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete()
                    }
                    completion()
                }
            }
    }

    // Remove an item from the cart and provide a completion handler.
    func removeItemFromCart(brand: String, model: String, completion: @escaping () -> Void) {
        let cartCollection = db.collection("cartItems")

        cartCollection.whereField("brand", isEqualTo: brand)
            .whereField("model", isEqualTo: model)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error deleting data: \(error.localizedDescription)")
                    completion()
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete()
                    }
                    completion()
                }
            }
    }

    // Download an image for a model and provide the URL in a completion handler.
    func downloadImage(forModel model: String, completion: @escaping (URL?) -> Void) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child("model_images/\(model).png")

        imageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error retrieving image URL: \(error.localizedDescription)")
                completion(nil)
            } else if let imageUrl = url {
                completion(imageUrl)
            } else {
                completion(nil)
            }
        }
    }
}
