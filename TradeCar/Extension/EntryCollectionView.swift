//
//  EntryCollectionView.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import UIKit

// Conforming to the UICollectionViewDelegate and UICollectionViewDataSource protocols
extension EntryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // Define the number of items in each section of the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case midCollectionView:
            return viewModel.carBrands.count
        case subCollectionView:
            return min(viewModel.models.count, 6)
        default:
            return viewModel.carBrands.count
        }
    }
    // Create and configure cells for the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == midCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopModelCell", for: indexPath)
            let type = viewModel.carTypes[indexPath.item]
            configureCell(cell, withType: type)
            return cell
        } else if collectionView == subCollectionView {
            if indexPath.item < min(viewModel.models.count, 6) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubModelCell", for: indexPath)
                configureSubModelCell(cell, at: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubModelCell", for: indexPath)
                cell.backgroundColor = .clear
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarBrandCell", for: indexPath)
            let brand = viewModel.carBrands[indexPath.item]
            configureBrandCell(cell, withBrand: brand)
            return cell
        }
    }
    // Handle the selection of items in the collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == midCollectionView {
            let selectedBrand = viewModel.carBrands[indexPath.item]
            // Fetch random models and update the subCollectionView
                viewModel.fetchRandomModels {
                    self.subCollectionView.reloadData()
                    self.subCollectionView.isHidden = false
                }
            // Deselect the previously selected item
            if let previousSelectedIndexPath = selectedIndexPath {
                midCollectionView.deselectItem(at: previousSelectedIndexPath, animated: false)
                if let previousSelectedCell = midCollectionView.cellForItem(at: previousSelectedIndexPath) {
                    previousSelectedCell.backgroundColor = .white
                    if let label = previousSelectedCell.contentView.subviews.first as? UILabel {
                        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
                    }
                }
            }
            // Select the current item and update its appearance
            midCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            if let cell = midCollectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
                if let label = cell.contentView.subviews.first as? UILabel {
                    label.textColor = .white
                }
            }
            
            selectedIndexPath = indexPath
            // Handle the selection in the topCollectionView
        } else if collectionView == topCollectionView {
            selectedBrand = viewModel.carBrands[indexPath.item]
            let modelListVC = CategoryVC()
            modelListVC.brand = selectedBrand
            navigationController?.pushViewController(modelListVC, animated: true)
        } else if collectionView == subCollectionView {
           
               }
           }
    
          // Function to configure cells for the midCollectionView and carTypes
           func configureCell(_ cell: UICollectionViewCell, withType type: String) {
               let label = UILabel()
               label.text = type
               label.textAlignment = .center
               label.font = UIFont.boldSystemFont(ofSize: 14)
               label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
               cell.contentView.addSubview(label)
               label.snp.makeConstraints { make in
                   make.top.equalToSuperview()
                   make.leading.trailing.bottom.equalToSuperview()
               }

               cell.layer.borderWidth = 2.0
               cell.layer.cornerRadius = 10.0
               cell.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7).cgColor
               cell.backgroundColor = .white
           }
           // Function to configure cells for the subCollectionView and models
           func configureSubModelCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
               for subview in cell.contentView.subviews {
                   subview.removeFromSuperview()
               }

               let model = viewModel.models[indexPath.item]

               let label = UILabel()
               label.text = model
               label.textAlignment = .left
               label.font = UIFont.boldSystemFont(ofSize: 14)
               label.textColor = .gray
               cell.contentView.addSubview(label)
               label.snp.makeConstraints { make in
                   make.top.equalTo(cell.contentView.snp.bottom).offset(10)
                   make.leading.trailing.equalToSuperview()
               }

               let priceLabel = UILabel()
               priceLabel.textAlignment = .left
               priceLabel.font = UIFont.systemFont(ofSize: 14)
               priceLabel.textColor = .gray

               if indexPath.item < viewModel.carPrices.count {
                   let price = viewModel.carPrices[indexPath.item]
                   let model = viewModel.models[indexPath.item]
                   priceLabel.text = "$\(price)"
               } else {
                   priceLabel.text = "Price not available"
               }

               cell.contentView.addSubview(priceLabel)
               priceLabel.snp.makeConstraints { make in
                   make.top.equalTo(label.snp.bottom).offset(5)
                   make.leading.trailing.equalToSuperview()
               }
               cell.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
               cell.layer.cornerRadius = 10.0

               let imageView = UIImageView()
               imageView.contentMode = .scaleAspectFit

               if let image = viewModel.modelImages[model] {
                   imageView.image = image
               } else {
                   print("No image found for \(model)")
               }

               cell.contentView.addSubview(imageView)
               imageView.snp.makeConstraints { make in
                   make.top.leading.trailing.bottom.equalToSuperview()
               }
           }
    
           // Function to configure cells for the car brand collection view
           func configureBrandCell(_ cell: UICollectionViewCell, withBrand brand: String) {
               let circleView = UIView()
               circleView.layer.cornerRadius = 65 / 2
               circleView.backgroundColor = UIColor.systemGray4
               circleView.clipsToBounds = true
               cell.contentView.addSubview(circleView)

               circleView.snp.makeConstraints { make in
                   make.top.leading.trailing.equalToSuperview()
                   make.height.equalTo(65)
                   make.width.equalTo(65)
               }

               let label = UILabel()
               label.text = brand
               label.textColor = UIColor.systemGray4
               label.textAlignment = .center
               label.font = UIFont.boldSystemFont(ofSize: 10)
               cell.contentView.addSubview(label)
               label.snp.makeConstraints { make in
                   make.top.equalTo(circleView.snp.bottom).offset(10)
                   make.leading.trailing.equalToSuperview()
                   make.height.equalTo(20)
               }

               if let imageName = viewModel.brandImages[brand] {
                   let imageSize: CGFloat = 30
                   let imageView = UIImageView()
                   imageView.contentMode = .scaleAspectFit
                   imageView.image = UIImage(named: imageName)
                   circleView.addSubview(imageView)
                   imageView.snp.makeConstraints { make in
                       make.centerX.centerY.equalToSuperview()
                       make.width.height.equalTo(imageSize)
                   }

                   imageView.layer.shadowColor = UIColor.black.cgColor
                   imageView.layer.shadowOpacity = 0.5
                   imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
                   imageView.layer.shadowRadius = 2
               }
               cell.backgroundColor = .clear
           }
    }
