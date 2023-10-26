//
//  ModelDFirebaseManage.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit
import RxSwift
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ModelDFirebaseManage {
    // Create a singleton instance of ModelDFirebaseManage.
    static let shared = ModelDFirebaseManage()
    
    // Private initializer to enforce the use of the singleton instance.
    private init() { }
    
    // Configure Firebase when initializing the class.
    func configure() {
        FirebaseApp.configure()
    }
    
    // Fetch models for a given brand and provide them in an Observable sequence.
    func fetchModels(forBrand brand: String) -> Observable<[String]> {
        return Observable.create { observer in
            let databaseRef = Database.database().reference()
            let modelsRef = databaseRef.child("modelnames").child(brand)
            
            modelsRef.observeSingleEvent(of: .value) { snapshot in
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    let modelNames = children.compactMap { $0.key as? String }
                    observer.onNext(modelNames)
                } else {
                    observer.onNext([])
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    // Fetch the price for a specific brand and model and provide it in an Observable sequence.
    func fetchModelPrice(brand: String, model: String) -> Observable<String?> {
        return Observable.create { observer in
            let databaseRef = Database.database().reference()
            let priceRef = databaseRef.child("modelnames").child(brand).child(model).child("Price")
            
            priceRef.observeSingleEvent(of: .value) { snapshot in
                if let price = snapshot.value as? String {
                    observer.onNext(price)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
