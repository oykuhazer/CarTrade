//
//  DetailViewModel.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit

class CarModelViewModel {
    // The model that this view model represents.
    var model: CarModel
    
    // Initialize the view model with a given CarModel.
    init(model: CarModel) {
        self.model = model
    }
    
    // Computed property for the title of the model, which includes the model name.
    var title: String {
        return "Model \(model.model)"
    }
    
    // Computed property for the image of the model, which is retrieved from the CarModel.
    var image: UIImage {
        return model.image
    }
    
    // Computed property for the formatted price of the model, including the "$" symbol.
    var price: String {
        return "$\(model.price)"
    }
}
