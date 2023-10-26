//
//  CartViewModel.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation

class CartViewModel {
    // An array to store cart items as strings.
    var cartItems: [String] = []
    
    // A closure to update the total label text in the view.
    var totalLabelText: ((String) -> Void)?
    
    // Fetch cart items from Firebase and update the view model.
    func fetchCartItems(completion: @escaping () -> Void) {
        CartFirebaseManage.shared.fetchCartItems { [weak self] cartItems in
            guard let self = self else { return }
            
            if let cartItems = cartItems {
                self.cartItems = cartItems
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    // Calculate and update the total price of the items in the cart.
    func updateTotalPrice() {
        var totalPrice: Double = 0.0
        for cartItem in cartItems {
            let components = cartItem.components(separatedBy: " - ")
            if components.count >= 3 {
                let priceStr = components[2].trimmingCharacters(in: .whitespaces)
                let priceWithoutDollar = priceStr.replacingOccurrences(of: "$", with: "")

                if let price = Double(priceWithoutDollar) {
                    totalPrice += price
                } else {
                    print("Price could not be converted to double: \(priceWithoutDollar)")
                }
            } else {
                print("Insufficient number of components: \(components.count)")
            }
        }
        totalLabelText?("$\(String(format: "%.2f", totalPrice))")
    }

    // Remove an item from the cart at the specified index.
    func removeItem(at index: Int, completion: @escaping () -> Void) {
        let cartItem = cartItems[index]
        let components = cartItem.components(separatedBy: " - ")
        
        if components.count >= 3 {
            let brand = components[0]
            let model = components[1]
            CartFirebaseManage.shared.removeFromCart(brand: brand, model: model) {
                self.cartItems.remove(at: index)
                self.updateTotalPrice()
                completion()
            }
        }
    }
}
