# Trade Car

## [Click here to watch the video of the app](https://youtu.be/JK4dP12vtUs)

Trade Car application is a versatile mobile app that allows users to explore car brands and models, register or log in, view vehicle details, and add products to a shopping cart. While **Firebase** infrastructure is used for user authentication and data storage, frameworks like **RxSwift** manage asynchronous processes and build the user interface. Users can browse car brands and models, access detailed information, and add products to their shopping cart. This app provides a convenient tool for automotive enthusiasts to streamline the process of vehicle selection and purchase.

This application is an iOS application built on the foundation of the **MVVM architecture**.  The application manages data exchange using powerful frameworks such as **Firebase, RxSwift, Kingfisher, SnapKit and WebKit**. 

## Folder Structure 

## HomePage 
<p align="center">
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/b0f9fc81-3867-4e57-bf56-5caa66d0c728" alt="zyro-image" width="200" height="450" />
    </p>
This page displays a welcome message, loads web-based content, and provides users with the option to navigate to another page by clicking the "Explore Cars" button. This code contains a web viewer that serves as the initial page for an iOS application.

### Frameworks 

- **RxSwift and RxCocoa:** They are used to manage asynchronous processes and user interactions.
- **SnapKit:** It simplifies the process of automatic layout.
- **WebKit:** It is used for viewing and processing web pages.

## Sign Up & Log In Screen
<p align="center">
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/0c901224-6e01-40e7-97f3-6109786b3ee0" alt="zyro-image" width="200" height="450" />
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/95dbacfd-2454-48c5-b2fb-d5a2dd744526" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/aa1946b3-cada-4a86-94f3-d1a4fa19946a" alt="zyro-image" width="200" height="450" />
  </p>
The primary function of this page is to enable users to sign up or log in through Firebase. It also includes a View Controller and ViewModel that create and control the user interface using UIKit.

### Functionalities

**UIView, UILabel, UISegmentedControl, UITextField, UIProgressView, and UIButton:** These are fundamental components that make up the user interface. UIView represents the main view that contains other components. The other components represent interface elements such as text, input fields, progress indicators, and buttons.

**SignLogVC (View Controller):** This class manages and displays the user interface. It allows users to sign in or sign up. It uses the SignLogViewModel class to perform the user's chosen action (Sign In or Sign Up). It retrieves user input and processes it through Firebase.

**SignLogViewModel:** This class manages the user's login information and the selected action (Sign In or Sign Up). It handles the outcome of the Sign In or Sign Up process and processes errors if necessary. The ViewModel is used to communicate process outcomes to the View Controller and to update the user interface by the View Controller.

### Frameworks

- **Firebase and FirebaseAuth:**

FirebaseAuth assists in managing user authentication processes using Firebase Authentication service.
SignLogFirebaseManage class handles the connection to Firebase and manages user registration and login processes.

- **SnapKit:** Simplifies user interface layout and autolayout operations.

## Entry Screen
<p align="center">
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/ac57d794-7f1d-43ff-b59a-5b62857340cb" alt="zyro-image" width="200" height="450" />
    </p>
It is the class that manages the main entry screen. It is used in conjunction with the EntryFirebaseManage class, which is used to fetch data from Firebase, and the ViewModel class (CategoryViewModel).

### Functionalities

**EntryFirebaseManage Class:**

- Used to interact with Firebase database and storage services.
- The fetchCarBrands function retrieves car brand names from Firebase.
- The fetchRandomCarModels function retrieves random car models and their prices from Firebase.
- The downloadImageForModel function downloads the image for a specific car model from Firebase storage.

**EntryViewModel Class:**

- Manages data related to car brands and models.
- The fetchModels function communicates with Firebase to fetch models belonging to a specific brand.

**EntryVC Class:**

- This is the View Controller class responsible for creating and displaying the user interface.
- It includes three different collection views in the top, middle, and bottom sections.
- The viewModel object manages data retrieval from Firebase and updates the user interface.
- The createCollectionView function creates and configures a specific collection view.
- The configureCell, configureSubModelCell, and configureBrandCell functions configure and display collection view cells.

### Frameworks

- **FirebaseDatabase:** Reading and writing data from the database is done using Database.database().reference().

- **FirebaseStorage:** Provides access to Firebase Storage services. It is used to store and access visual data (e.g., car model images).

- **RxSwift:** Particularly used for managing data retrieval processes from Firebase with a reactive approach.

- **Kingfisher:** Used for downloading and displaying car model images.

## Category Screen
<p align="center">
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/f4d24a80-4570-4ae9-a254-afa741bd304f" alt="zyro-image" width="200" height="450" />
   <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/6e9ecb9e-4dd3-4a24-80ca-72e1cc45b0b6" alt="zyro-image" width="200" height="450" />
    </p>
It represents a screen displaying information about car brands and models. It allows users to view and select different car brands and their respective models.

### Functionalities

**fetchModels() Function:** Retrieves models from the Firebase database for a specific car brand. When a user selects a car brand, this function is called to fetch the models under the selected brand. This function provides access to the Firebase database and retrieves the relevant data.

**setupCellContent() Function:** Creates the content of each cell displaying a car model. It inserts information such as the model's name, price, and image into the cell. It also allows users to navigate to the details of the selected model when chosen.

**navButtonTapped() Function:** Allows users to navigate to the cart page. When users click the cart button, this function is triggered and redirects them to the cart page.

**cartButtonTapped() Function:** Enables users to add a car model to their cart. To add a model to the cart, it adds the information of the selected brand and model to the Firebase Firestore database. Additionally, it adds the image of the respective model to the cart.

### Frameworks

- **FirebaseDatabase:** It is used to store and access data, such as car model names and price information, in the Firebase database.

- **FirebaseStorage:** Car model images are stored in Firebase Storage, and this service is used to access these images.

- **RxSwift:** Reactive programming methods are used to fetch and process Firebase data. RxSwift is used to manage data streams and facilitate asynchronous operations.

- **Kingfisher:** It is used for downloading model images and displaying them.

## ModelDetail Screen
<p align="center">
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/7783e892-ccdf-4cfc-8904-fbfb3f3302a3" alt="zyro-image" width="200" height="450" />
   <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/d0059ef6-842f-477d-b74b-3165a13c5a18" alt="zyro-image" width="200" height="450" />
     <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/70d33227-b6db-41d7-b2c1-77484a481fb8" alt="zyro-image" width="200" height="450" />
    </p>
It provides users with the ability to view the details of a specific car model and add it to the cart. Firebase, RxSwift, and other frameworks like UIKit and SnapKit are used to perform these functions.

### Functionalities

**ModelDFirebaseManage Class:** This class provides access to the Firebase database and retrieves the data required for car model details. 

- Its functions include:

**configure():** Initiates Firebase configuration.
**fetchModels(forBrand brand: String):** Retrieves models for a specific car brand.
**fetchModelPrice(brand: String, model: String):** Retrieves the price of a specific model for a given car brand.

**CarModel Structure:** This structure contains the characteristics of a car model and represents information such as brand, model, image, and price.

**CarModelViewModel Class:** It presents car model data using the CarModel structure through a ViewModel. Its main function is to transfer the model's title, image, and price to the user interface.

**ModelDetailVC Class:** Manages the functionality of the screen that displays car model details. 

- Its key functions include:

**setupUI(with viewModel:** CarModelViewModel): Creates and displays UI elements.
**navButtonTapped():** Redirects to the cart page when the user clicks the cart button.
**addToCartButtonTapped():** Executes when the user clicks to add a car model to the cart and adds the relevant model to the Firestore database.
**fetchModelDetails():** Retrieves the details of the selected car model and displays them on the page.

### Frameworks

- **RxSwift:** Especially when fetching data from Firebase, Observable and other RxSwift operators are used to monitor the flow and transformations of this data.

- **SnapKit:** Used to define the layout of interface elements. The positions and sizes of elements are defined using SnapKit.
 
- **Firebase Realtime Database:** 

**Access to car brands and models:** Allows users to access car brands and the models under those brands. Data is updated and retrieved in real-time in this database.

**Getting car prices:** Enables users to obtain the price of a selected car model, matching price data with the selected brand and model.

**Storing car images:** Car model images are uploaded to Firebase Storage and provide access to these images.

- **Firebase Firestore:** Demonstrates the storage, retrieval, and update of data associated with a specific car model.

- **Firebase Storage:** Used to store application images. It allows users to store and access images of cars.

## Cart Screen
<p align="center">
  <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/87c3094f-9e03-4981-b390-c06be62bf902" alt="zyro-image" width="200" height="450" />
   <img src="https://github.com/oykuhazer/CarTrade/assets/130215854/5bb99d78-62cb-4c3a-876d-6c30e390e0ec" alt="zyro-image" width="200" height="450" />
    </p>
This page includes a shopping cart functionality.

### Functionalities

Lists the items in the shopping cart.
Removes items from the cart and updates the total price.
Displays the total price to the user.
Asks the user if an item can be removed, and if necessary, removes the item.

- **fetchCartItems(completion:):** Retrieves and displays items in the cart from Firestore.
- **updateTotalPrice():** Calculates and shows the total price of items in the cart to the user.
- **removeItem(at:index:completion:):** Allows the user to remove a specific item from the cart.
- **checkmarkTapped(sender:):** Triggers the user to remove an item from the cart and provides feedback.

### Frameworks

- **Firebase Firestore:** Firestore is used for storing and retrieving data. Cart items are stored in Firestore documents and used for retrieving these items. Additionally, the process of removing items is performed in Firestore.

- **Firebase Storage:** It allows the storage of product images in Firebase Storage. Product images are downloaded using their URLs, and the product images are displayed in collection views.

- **Kingfisher:** Kingfisher is used for loading and displaying images. It facilitates the display of images retrieved from Firebase Storage in collection view cells.

