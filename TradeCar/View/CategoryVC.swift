//
//  CategoryVC.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 10.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher


class CategoryVC: UIViewController {
    var brand: String? // Store the selected car brand.
    var collectionView: UICollectionView! // Collection view for displaying car models.
    var brandLabel: UILabel! // Label to display the selected brand name.
    var navButton: UIButton! // Button for navigating to the cart view.
    var viewModel: CategoryViewModel = CategoryViewModel() // ViewModel to manage category-related data.
    let disposeBag = DisposeBag() // Dispose bag for handling disposables.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setupGradientBackground() // Set up a gradient background for the view.
        setupUI() // Configure the user interface elements.
        setupViewModel() // Set up the ViewModel to fetch and handle data.
    }

    // Configure the user interface elements.
    func setupUI() {
        // Create a navigation button for the cart view.
        navButton = UIButton(type: .system)
        navButton.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        navButton.tintColor = .lightGray
        navButton.frame = CGRect(x: view.bounds.width - 50, y: 0, width: 44, height: 44)
        navButton.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navButton)

        // Create and configure a label to display the selected brand name.
        brandLabel = UILabel(frame: CGRect(x: 20, y: 70, width: view.bounds.width - 40, height: 60))
        brandLabel.text = brand ?? ""
        brandLabel.textColor = .white
        brandLabel.font = UIFont(name: "Impact", size: 22)
        brandLabel.textAlignment = .center
        view.addSubview(brandLabel)
    }

    // Set up the ViewModel and fetch car model data.
    func setupViewModel() {
        viewModel.brand = brand

        viewModel.fetchModels()
            .subscribe(onSuccess: { [weak self] in
                self?.setupCollectionView()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    // Set up and configure the collection view for displaying car models.
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.bounds.width - 40) / 2 - 30, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 90

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ModelCell")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-50)
        }
    }

    // Handle the cart button tap action.
    @objc func navButtonTapped() {
        let cartVC = CartVC()
        navigationController?.pushViewController(cartVC, animated: true)
    }

    // Handle the cart button tap action.
    @objc func cartButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell),
           let selectedBrand = brand {
            let selectedModel = viewModel.models.value[indexPath.item]

            // Access Firebase Firestore and Realtime Database to add items to the cart.
            let db = Firestore.firestore()
            let cartCollection = db.collection("cartItems")

            let databaseRef = Database.database().reference()
            let priceRef = databaseRef.child("modelnames").child(selectedBrand).child(selectedModel).child("Price")

            priceRef.observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
                if let price = snapshot.value as? String {
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let imageRef = storageRef.child("model_images/\(selectedModel).png")

                    imageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            print("Picture not received: \(error.localizedDescription)")
                        } else if let imageData = data, let image = UIImage(data: imageData) {
                            cartCollection.addDocument(data: [
                                "model": selectedModel,
                                "brand": selectedBrand,
                                "price": price,
                                "image": imageData
                            ]) { error in
                                if let error = error {
                                    print("Error adding data to Firestore database: \(error)")
                                } else {
                                    let alert = UIAlertController(title: "Succeeded!", message: "The product has been added to the cart.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
                                    self?.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                } else {
                    print("Price information was not found or an error occurred.")
                }
            }
        }
    }
}

