//
//  CategoryCollectionView.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // This function specifies the number of items in the UICollectionView section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.models.value.count
    }
    
    // This function configures and returns a cell for the given indexPath.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCell", for: indexPath)
        setupCellContent(cell, at: indexPath) // Calls a function to set up the cell's content.
        return cell
    }
    
    // This function is called when a user selects an item in the UICollectionView.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedModel = viewModel.models.value[indexPath.item]
        if let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell {
            if let image = (cell.contentView.subviews.first { $0 is UIImageView }) as? UIImageView {
                // Creates a CarModel object with brand, selected model, image, and an empty price.
                let carModel = CarModel(brand: brand!, model: selectedModel, image: image.image!, price: "")
                let carModelViewModel = CarModelViewModel(model: carModel)
                let modelDetailVC = ModelDetailVC()
                modelDetailVC.viewModel = carModelViewModel
                navigationController?.pushViewController(modelDetailVC, animated: true)
            }
        }
    }

    
    func setupCellContent(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        cell.contentView.layer.cornerRadius = 10

        // Create and configure a label to display the car model's name.
        let label = UILabel()
        label.text = viewModel.models.value[indexPath.item]
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        cell.contentView.addSubview(label)

        // Create and configure a button with a cart icon.
        let cartButton = UIButton(type: .system)
        cartButton.setImage(UIImage(systemName: "cart.circle.fill"), for: .normal)
        cartButton.tintColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cell.contentView.addSubview(cartButton)

        // Create and configure a label to display the car model's price.
        let priceLabel = UILabel()
        priceLabel.textColor = .gray
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        cell.contentView.addSubview(priceLabel)

        // Create and configure an image view to display the car model's image.
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageView)

        // Set up constraints to position and size the UI elements within the cell's content view.
        label.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView.snp.top).offset(cell.contentView.frame.height + 5)
            make.left.equalTo(cell.contentView)
            make.right.equalTo(cell.contentView)
            make.height.equalTo(30)
        }

        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(-10)
            make.left.equalTo(cell.contentView)
            make.right.equalTo(cell.contentView)
            make.height.equalTo(30)
        }

        cartButton.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView)
            make.right.equalTo(cell.contentView).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView)
        }

        if let selectedBrand = brand {
            // Access a Firebase Realtime Database reference and fetch the car model's price.
            let databaseRef = Database.database().reference()
            let model = viewModel.models.value[indexPath.item]
            let priceRef = databaseRef.child("modelnames").child(selectedBrand).child(model).child("Price")

            priceRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                if let price = snapshot.value as? String {
                    priceLabel.text = "$\(price)"
                } else {
                    print("Price not found or error occurred")
                }
            }
            // Access Firebase Storage, fetch the car model's image, and display it in the image view.
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let modelName = viewModel.models.value[indexPath.item]
            let imageRef = storageRef.child("model_images/\(modelName).png")

            imageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Picture not received: \(error.localizedDescription)")
                } else if let imageData = data, let image = UIImage(data: imageData) {
                    imageView.image = image
                } else {
                    print("The image data is not valid or could not be converted.")
                }
            }
        }
    }
    }
