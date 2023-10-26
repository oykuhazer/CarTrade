//
//  ModelDetailVC.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 10.10.2023.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Firebase
import FirebaseDatabase

class ModelDetailVC: UIViewController {
    var model: CarModel? // Store the car model data.
    var viewModel: CarModelViewModel? // ViewModel for the car model.
    var navButton: UIButton! // Button for navigating to the cart view.
    var imageView: UIImageView! // ImageView for displaying the car model image.
    var scrollView: UIScrollView! // Scroll view for displaying content.
    var disposeBag = DisposeBag() // Dispose bag for handling disposables.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setupGradientBackground() // Set up a gradient background for the view.
        if let viewModel = viewModel {
            setupUI(with: viewModel) // Configure the UI using the provided ViewModel.
            fetchModelDetails() // Fetch and display details of the car model.
        }
    }

    // Configure the UI using the provided ViewModel.
    func setupUI(with viewModel: CarModelViewModel) {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        setupNavigationBar() // Set up the navigation bar.
        setupTitleLabel(title: viewModel.title) // Set up the title label with the car model's title.
        setupImageView(image: viewModel.image) // Set up the image view with the car model's image.
        setupCustomView(price: viewModel.price) // Set up a custom view to display additional details.
    }

    // Set up the navigation bar.
    func setupNavigationBar() {
        navButton = createNavButton() // Create a cart button for the navigation bar.
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navButton)
    }

    // Set up the title label with the provided title.
    func setupTitleLabel(title: String) {
        let titleLabel = createTitleLabel(text: title)
        scrollView.addSubview(titleLabel)
    }

    // Set up the image view with the provided image.
    func setupImageView(image: UIImage) {
        imageView = createImageView(image: image)
        scrollView.addSubview(imageView)
    }

    // Set up a custom view to display additional details and add-to-cart button.
    func setupCustomView(price: String) {
        let customView = createCustomView(price: price)
        scrollView.addSubview(customView)
    }

    // Create a cart button for the navigation bar.
    func createNavButton() -> UIButton {
        // Create and configure a cart button.
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        button.tintColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        button.frame = CGRect(x: view.bounds.width - 50, y: 0, width: 44, height: 44)
        button.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        return button
    }

    // Create a label with the provided text and frame.
    func createTitleLabel(text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.frame = CGRect(x: -80, y: 190, width: view.bounds.width, height: 50)
        return titleLabel
    }

    // Create an image view with the provided image and frame.
    func createImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 2.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        imageView.layer.shadowRadius = 8
        let imageViewWidth: CGFloat = view.bounds.width - 40
        let imageViewHeight: CGFloat = 200
        imageView.frame = CGRect(x: (view.bounds.width - imageViewWidth) / 2, y: -20, width: imageViewWidth, height: imageViewHeight)
        return imageView
    }

    // Create a custom view with the provided price and an add-to-cart button.
    func createCustomView(price: String) -> UIView {
        let customView = UIView()
        customView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        customView.layer.cornerRadius = 10
        customView.layer.masksToBounds = true

        // Create a label for "Sell Price."
        let sellPriceLabel = createLabel(text: "Sell Price", fontSize: 16, frame: CGRect(x: 10, y: 15, width: 100, height: 30))

        // Create a button for "Add to Cart."
        let button = createButton(title: "Add to Cart", fontSize: 20, frame: CGRect(x: customView.bounds.width + 140, y: 55, width: 140, height: 40))
        customView.addSubview(button)

        customView.addSubview(sellPriceLabel)

        customView.frame = CGRect(x: 68, y: 1020, width: 300, height: 110)
        return customView
    }

    // Create a label with the provided text, font size, and frame.
    func createLabel(text: String, fontSize: CGFloat, frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        return label
    }

    // Create a button with the provided title, font size, and frame.
    func createButton(title: String, fontSize: CGFloat, frame: CGRect) -> UIButton {
        let button = UIButton(type: .system)
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowRadius = 8
        return button
    }

    // Handle the navigation button tap action.
    @objc func navButtonTapped() {
        let cartVC = CartVC()
        navigationController?.pushViewController(cartVC, animated: true)
    }

    // Handle the "Add to Cart" button tap action.
    @objc func addToCartButtonTapped() {
        guard let brand = self.viewModel?.model.brand, let model = self.viewModel?.model.model else {
            return
        }

        // Fetch the price of the selected model and add it to the cart.
        ModelDFirebaseManage.shared.fetchModelPrice(brand: brand, model: model)
            .subscribe(onNext: { price in
                if let price = price {
                    print("Price: \(price)")
                    let db = Firestore.firestore()
                                       let cartCollection = db.collection("cartItems")
                                       
                                       // Add the model to the cart collection in Firestore.
                                       cartCollection.addDocument(data: [
                                           "model": model,
                                           "brand": brand,
                                           "price": price,
                                       ]) { error in
                                           if let error = error {
                                               print("Error adding data to Firestore database: \(error)")
                                           } else {
                                               let alert = UIAlertController(title: "Succeeded!", message: "The product has been added to the cart.", preferredStyle: .alert)
                                               alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                               self.present(alert, animated: true, completion: nil)
                                           }
                                       }
                                   } else {
                                       print("Price data cannot be resolved or is null.")
                                   }
                               })
                               .disposed(by: disposeBag)
                       }

                       // Fetch details of the car model from the database.
                       func fetchModelDetails() {
                           guard let brand = viewModel?.model.brand, let model = viewModel?.model.model else {
                               return
                           }
                           
                           let databaseRef = Database.database().reference()
                           let modelDetailRef = databaseRef.child("modelnames").child(brand).child(model)
                           
                           var yOffset: CGFloat = 430
                           var specificDetails: [String: String] = [:]
                           
                           let combinedTextView = createCombinedTextView()
                           scrollView.addSubview(combinedTextView)
                           
                           modelDetailRef.observeSingleEvent(of: .value) { (snapshot) in
                               if let modelDetails = snapshot.value as? [String: String] {
                                   var combinedText = ""
                                   for (key, value) in modelDetails {
                                       if key == "Price" {
                                           let priceLabel = self.createPriceLabel(withText: value)
                                           self.scrollView.addSubview(priceLabel)
                                       } else if ["Range", "Top Speed", "0-60 mph"].contains(key) {
                                           specificDetails[key] = value
                                       } else {
                                           combinedText += "\(key): \(value)\n\n"
                                       }
                                   }
                                   self.displaySpecificDetails(specificDetails)
                                   combinedTextView.text = combinedText
                                   let size = combinedTextView.sizeThatFits(CGSize(width: self.view.bounds.width - 40, height: .greatestFiniteMagnitude))
                                   combinedTextView.frame = CGRect(x: 20, y: yOffset, width: self.view.bounds.width - 40, height: size.height)
                                   let contentHeight: CGFloat = yOffset + size.height + 200
                                   self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: contentHeight)
                               }
                           }
                       }

                       // Create a text view for displaying combined details.
                       func createCombinedTextView() -> UITextView {
                           let combinedTextView = UITextView()
                           combinedTextView.text = ""
                           combinedTextView.textColor = .white
                           combinedTextView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
                           combinedTextView.isEditable = false
                           combinedTextView.isScrollEnabled = true
                           combinedTextView.font = UIFont(name: "Arial", size: 16)
                           combinedTextView.layer.borderWidth = 1
                           combinedTextView.layer.borderColor = UIColor.gray.cgColor
                           combinedTextView.layer.cornerRadius = 10
                           return combinedTextView
                       }

    // Display specific details using icons, labels, and values.
    func displaySpecificDetails(_ specificDetails: [String: String]) {
    let imageWidth: CGFloat = 40
    let imageHeight: CGFloat = 40
    let totalLabelWidth = self.view.bounds.width - 60
    let labelCount = specificDetails.count
    let labelWidth = totalLabelWidth / CGFloat(labelCount)
    let gapBetweenLabels: CGFloat = 10
    
    var xOffset: CGFloat = 40
    let yOffset: CGFloat = 300

    for (key, value) in specificDetails {
        if let image = UIImage(named: key) {
        let imageView = createImageView(image: image, frame: CGRect(x: xOffset + 5, y: yOffset - 50, width: imageWidth, height: imageHeight))
        scrollView.addSubview(imageView)
            
        }

    let keyLabel = createLabel(text: key, fontSize: 12, frame: CGRect(x: xOffset, y: yOffset + 30, width: labelWidth, height: 30))
    scrollView.addSubview(keyLabel)

    let valueLabel = createLabel(text: value, fontSize: 16, frame: CGRect(x: xOffset, y: yOffset, width: labelWidth, height: 30))
    scrollView.addSubview(valueLabel)

    xOffset += labelWidth + gapBetweenLabels
        
         }
    }
 
    // Create an image view with the provided image and frame.
    func createImageView(image: UIImage, frame: CGRect) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowOffset = CGSize(width: 0, height: 6)
        imageView.layer.shadowRadius = 8
        return imageView
        
    }

         // Create a label to display the price.
         func createPriceLabel(withText text: String) -> UILabel {
         let label = createLabel(text: "$\(text)", fontSize: 20, frame: CGRect(x: 270, y: 1035, width: self.view.bounds.width - 40, height: 30))
             
         return label
             
         }
    }
