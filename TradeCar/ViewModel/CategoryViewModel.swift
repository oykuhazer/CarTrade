//
//  CategoryViewModel.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryViewModel {
    // The brand for which models are fetched.
    var brand: String?
    
    // BehaviorRelay to store and observe an array of model names.
    var models: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    // Fetch models for the selected brand.
    func fetchModels() -> Single<Void> {
        guard let brand = brand else {
            // If the brand is not set, return a Single with a value of ().
            return Single.just(())
        }

        // Use the CategoryFirebaseManage to fetch models for the selected brand from Firebase.
        return CategoryFirebaseManage.shared.fetchModels(forBrand: brand)
            .do(onSuccess: { [weak self] modelNames in
                // Update the models BehaviorRelay with the fetched model names.
                self?.models.accept(modelNames)
            })
            .map { _ in () }
    }
}
