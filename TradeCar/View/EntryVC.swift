//
//  EntryVC.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 10.10.2023.
//

import UIKit
import SnapKit
import RxSwift
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class EntryVC: UIViewController {
    let viewModel = EntryViewModel() // Create an instance of EntryViewModel to manage data.

    // Firebase storage instance for managing data storage.
    let storage = Storage.storage()

    var selectedBrand: String? // Store the selected car brand.
    var selectedIndexPath: IndexPath? // Store the selected index path.

    // Constants for configuring collection view layout.
    let collectionViewHeight: CGFloat = 200
    let spacing: CGFloat = 10
    let horizontalInset: CGFloat = 20

    // Create a UICollectionView for displaying car brands.
    lazy var topCollectionView: UICollectionView = {
        return createCollectionView(itemSize: CGSize(width: (view.frame.size.width - 3 * horizontalInset) / 5, height: (collectionViewHeight - spacing) / 2), identifier: "CarBrandCell", verticalSpacing: 10.0, horizontalSpacing: spacing, scrollDirection: .vertical)
    }()

    // Create a UICollectionView for displaying top car models.
    lazy var midCollectionView: UICollectionView = {
        return createCollectionView(itemSize: CGSize(width: (view.frame.size.width - 3 * horizontalInset) / 4, height: 40), identifier: "TopModelCell", verticalSpacing: 10.0, horizontalSpacing: spacing, scrollDirection: .horizontal)
    }()

    // Create a UICollectionView for displaying sub-models.
    lazy var subCollectionView: UICollectionView = {
        return createCollectionView(itemSize: CGSize(width: (view.frame.size.width - 3 * horizontalInset - 2 * spacing) / 2, height: 150), identifier: "SubModelCell", verticalSpacing: 70.0, horizontalSpacing: spacing, scrollDirection: .vertical)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setupGradientBackground() // Set up the gradient background for the view.
        setupCollectionView() // Configure and set up the collection views.

        // Fetch car brand and top model data from Firebase.
        viewModel.fetchDataFromFirebase {
            self.topCollectionView.reloadData()
            self.midCollectionView.reloadData()
        }

        if selectedBrand == nil && selectedIndexPath == nil {
            // If no brand or index path is selected, fetch random sub-model data.
            viewModel.fetchRandomModels {
                self.subCollectionView.reloadData()
            }
        }
    }

    // Create a UICollectionView with specified layout parameters.
    func createCollectionView(itemSize: CGSize, identifier: String, verticalSpacing: CGFloat, horizontalSpacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection = .vertical) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = horizontalSpacing
        layout.minimumLineSpacing = verticalSpacing
        layout.itemSize = itemSize
        layout.scrollDirection = scrollDirection

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        return collectionView
    }

    // Set up and configure the collection views and labels.
    func setupCollectionView() {
        // Configure topCollectionView.
        topCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalInset)
            make.right.equalToSuperview().inset(horizontalInset)
            make.top.equalToSuperview()
            make.height.equalTo(collectionViewHeight + 100)
        }

        // Create and configure a label for car types.
        let carTypesLabel = UILabel()
        carTypesLabel.text = "CAR TYPES"
        carTypesLabel.textAlignment = .left
        carTypesLabel.font = UIFont(name: "Impact", size: 22)
        carTypesLabel.textColor = .white
        view.addSubview(carTypesLabel)
        carTypesLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalInset)
            make.right.equalToSuperview().inset(horizontalInset)
            make.top.equalTo(topCollectionView.snp.bottom).offset(40)
            make.height.equalTo(20)
        }

        // Configure midCollectionView to display top car models.
        midCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalInset)
            make.right.equalToSuperview().inset(horizontalInset)
            make.top.equalTo(carTypesLabel.snp.bottom).offset(0)
            make.height.equalTo(80)
        }

        // Configure subCollectionView to display sub-models.
        subCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalInset)
            make.right.equalToSuperview().inset(horizontalInset)
            make.top.equalTo(midCollectionView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}
