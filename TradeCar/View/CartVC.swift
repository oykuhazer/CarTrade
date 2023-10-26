//
//  CartVC.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 10.10.2023.
//

import UIKit
import SnapKit
import Kingfisher
import FirebaseFirestore
import FirebaseStorage


class CartVC: UIViewController {
    private var collectionView: UICollectionView!
    private var totalLabel: UILabel!
    private var bottomSheet: UIView!
    var viewModel = CartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Setup the collection view to display cart items.
        setupCollectionView()
        
        // Setup the bottom sheet that displays total price and checkout button.
        setupBottomSheet()
        
        // Fetch cart items from the ViewModel and update the collection view and total price.
        viewModel.fetchCartItems {
            self.collectionView.reloadData()
            self.viewModel.updateTotalPrice()
        }
        
        // Subscribe to the ViewModel's totalLabelText property to update the total price label.
        viewModel.totalLabelText = { [weak self] totalText in
            self?.totalLabel.text = totalText
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width - 40, height: 100)
        layout.minimumLineSpacing = 40

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CartItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)

        // Set constraints for the collection view.
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(100)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-150)
        }
    }

    private func setupBottomSheet() {
        bottomSheet = UIView()
        bottomSheet.backgroundColor = .black

        view.addSubview(bottomSheet)

        // Set constraints for the bottom sheet.
        bottomSheet.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(150)
        }

        let padding: CGFloat = 20

        let titleLabel = UILabel()
        titleLabel.text = "Total Price"
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white

        bottomSheet.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bottomSheet).offset(padding)
            make.top.equalTo(bottomSheet).offset(30)
        }

        totalLabel = UILabel()
        totalLabel.textAlignment = .left
        totalLabel.numberOfLines = 1
        totalLabel.font = UIFont.systemFont(ofSize: 16)
        totalLabel.textColor = .white

        bottomSheet.addSubview(totalLabel)

        totalLabel.snp.makeConstraints { make in
            make.leading.equalTo(bottomSheet).offset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        let checkoutButton = UIButton()
        checkoutButton.setTitle("Proceed Checkout", for: .normal)
        checkoutButton.setTitleColor(.black, for: .normal)
        checkoutButton.backgroundColor = .white
        checkoutButton.layer.cornerRadius = 5

        bottomSheet.addSubview(checkoutButton)

        checkoutButton.snp.makeConstraints { make in
            make.trailing.equalTo(bottomSheet).offset(-padding)
            make.bottom.equalTo(bottomSheet.snp.centerY)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
    }

    @objc  func checkmarkTapped(sender: UIButton) {
        let selectedIndex = sender.tag
        let cartItem = viewModel.cartItems[selectedIndex]
        let components = cartItem.components(separatedBy: " - ")

        if components.count >= 2 {
            let brand = components[0]
            let model = components[1]

            // Remove the selected item from the cart.
            CartFirebaseManage.shared.removeItemFromCart(brand: brand, model: model) {
                self.viewModel.cartItems.remove(at: selectedIndex)
                self.collectionView.deleteItems(at: [IndexPath(item: selectedIndex, section: 0)])
                self.viewModel.updateTotalPrice()
            }
        }

        sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)

        // Display a success message when the item is removed from the cart.
        let alertController = UIAlertController(title: "Succeeded!", message: "Removed from cart.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
