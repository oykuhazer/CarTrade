//
//  CartCollectionView.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit
import FirebaseStorage

extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the cart.
        return viewModel.cartItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartItemCell", for: indexPath)

        // Create and configure a checkmark button to mark items.
        let checkmarkButton = UIButton(type: .system)
        cell.contentView.addSubview(checkmarkButton)
        checkmarkButton.tintColor = .white
        checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(cell.contentView)
            make.leading.equalTo(cell.contentView).offset(10)
            make.width.height.equalTo(20)
        }

        // Extract cart item components.
        let cartItem = viewModel.cartItems[indexPath.item]
        let components = cartItem.components(separatedBy: " - ")
              
        if components.count >= 3 {
            let brand = components[0]
            let model = components[1]
            let price = components[2]
            let labelHeight: CGFloat = 20
            let padding: CGFloat = 10
            let labelWidth: CGFloat = cell.contentView.bounds.width - 2 * padding
            
            // Create and configure labels for brand, model, and price.
            let brandLabel = UILabel()
            brandLabel.text = brand
            brandLabel.textColor = .white
            brandLabel.font = UIFont.boldSystemFont(ofSize: 20)
            brandLabel.textAlignment = .left
            cell.contentView.addSubview(brandLabel)
            brandLabel.snp.makeConstraints { make in
                make.leading.equalTo(cell.contentView).offset(160)
                make.top.equalTo(cell.contentView).offset(18)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
            
            let modelLabel = UILabel()
            modelLabel.text = model
            modelLabel.textColor = .white
            modelLabel.textAlignment = .left
            cell.contentView.addSubview(modelLabel)
            modelLabel.snp.makeConstraints { make in
                make.leading.equalTo(brandLabel)
                make.top.equalTo(brandLabel.snp.bottom).offset(0)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
            
            let priceLabel = UILabel()
            priceLabel.text = "$\(price)"
            priceLabel.textColor = .white
            priceLabel.textAlignment = .left
            cell.contentView.addSubview(priceLabel)
            priceLabel.snp.makeConstraints { make in
                make.leading.equalTo(brandLabel)
                make.top.equalTo(modelLabel.snp.bottom).offset(0)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
            
            // Fetch and display the image of the model.
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child("model_images/\(model).png")
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error retrieving image URL: \(error.localizedDescription)")
                    return
                }
                
                if let imageUrl = url {
                    let imageView = UIImageView()
                    cell.contentView.addSubview(imageView)
                    imageView.snp.makeConstraints { make in
                        make.leading.equalTo(cell.contentView).offset(45)
                        make.top.equalTo(cell.contentView).offset(25)
                        make.width.equalTo(90)
                        make.height.equalTo(50)
                    }
                    
                    // Load and display the image using Kingfisher.
                    imageView.kf.setImage(with: imageUrl, placeholder: nil, options: nil, completionHandler: { result in
                        switch result {
                        case .success(_):
                            print("The image has been uploaded successfully.")
                        case .failure(let error):
                            print("Image could not be loaded: \(error)")
                        }
                    }
                )}
            }
        }
        
        // Configure the appearance of the cell.
        cell.contentView.backgroundColor = .black
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        // Attach a target action to the checkmark button.
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        checkmarkButton.tag = indexPath.item
        
        return cell
    }
}
