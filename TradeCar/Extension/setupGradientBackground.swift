//
//  setupGradientBackground.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit

extension UIView {
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
