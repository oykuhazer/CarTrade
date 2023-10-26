//
//  ViewController.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 10.10.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth


class SignLogVC: UIViewController {
    // MARK: - Properties

    private var signLogLabel: UILabel!
    private var pageSegmentControl: UISegmentedControl!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var progressView: UIProgressView!
    private var signUpButton: UIButton!

    private var viewModel = SignLogViewModel()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        view.setupGradientBackground() // Set up the view background gradient.
        viewModel.updateSignUpButtonText = { [weak self] in
            self?.updateSignUpButtonTitle()
        }
    }

    // MARK: - View Configuration

    private func configureView() {
        setupSignLogLabel() // Configure the introductory label.
        createSegmentControl() // Create the segmented control for Log In and Sign Up.
        createTextFields() // Create email and password text fields.
        createProgressView() // Create the password strength progress view.
        createSignUpButton() // Create the Log In/Sign Up button.
    }

    // MARK: - SignLogLabel Setup

    private func setupSignLogLabel() {
        signLogLabel = UILabel()
        signLogLabel.text = "Enter your email address and password here to embark on an adventure!"
        signLogLabel.textColor = .white
        signLogLabel.font = UIFont.boldSystemFont(ofSize: 22)
        signLogLabel.textAlignment = .justified
        signLogLabel.numberOfLines = 3
        view.addSubview(signLogLabel)

        // Set constraints for the signLogLabel
        signLogLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
    }

    // MARK: - Segmented Control Setup

    private func createSegmentControl() {
        pageSegmentControl = UISegmentedControl(items: ["Log In", "Sign Up"])
        view.addSubview(pageSegmentControl)

        // Set constraints for the segmented control
        pageSegmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signLogLabel.snp.bottom).offset(120)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        // Customize the segmented control's appearance
        pageSegmentControl.layer.borderWidth = 2.0
        pageSegmentControl.layer.borderColor = UIColor(red: 77/255, green: 83/255, blue: 96/255, alpha: 1.0).cgColor
        pageSegmentControl.selectedSegmentTintColor = UIColor(red: 77/255, green: 83/255, blue: 96/255, alpha: 1.0)
        pageSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        pageSegmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
    }

    // MARK: - Text Field Setup

    private func createTextFields() {
        let textFieldWidth: CGFloat = 250
        let textFieldHeight: CGFloat = 40

        emailTextField = createTextField(placeholder: "E-mail Address") // Create email text field
        passwordTextField = createTextField(placeholder: "Password") // Create password text field

        let passwordToggleButton = createPasswordToggleButton() // Create the password visibility toggle button
        passwordTextField.rightView = passwordToggleButton
        passwordTextField.rightViewMode = .always

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)

        // Set constraints for the emailTextField and passwordTextField
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageSegmentControl.snp.bottom).offset(70)
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(textFieldHeight)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(textFieldHeight)
        }
    }

    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect

        // If it's a password field, make it secure and add an editing change listener
        if placeholder == "Password" {
            textField.isSecureTextEntry = true
            textField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        }
        return textField
    }

    // MARK: - Password Toggle Button Setup

    private func createPasswordToggleButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "key.fill"), for: .normal)
        button.setImage(UIImage(systemName: "key"), for: .selected)
        button.tintColor = UIColor(red: 77/255, green: 83/255, blue: 96/255, alpha: 1.0)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        button.isSelected = true
        return button
    }

    // MARK: - Password Strength Progress View Setup

    private func createProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        view.addSubview(progressView)

        // Set constraints for the progress view
        progressView.snp.makeConstraints { make in
            make.centerX.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.width.equalTo(passwordTextField)
            make.height.equalTo(10)
        }

        // Customize the progress view's appearance
        progressView.progressTintColor = UIColor(red: 77/255, green: 83/255, blue: 96/255, alpha: 1.0)
        progressView.isHidden = true
    }

    // MARK: - Button Actions

    @objc private func togglePasswordVisibility(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }

    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            var progress: Float = 0.0
            let minPasswordLength = 8

            if text.count >= minPasswordLength {
                progress += 0.5
            }

            if text.rangeOfCharacter(from: CharacterSet(charactersIn: ".,;*%&:")) != nil {
                progress += 0.5
            }

            progressView.isHidden = (text.isEmpty)
            progressView.progress = progress
        }
    }

    // MARK: - Sign Up Button Setup

    private func createSignUpButton() {
        signUpButton = UIButton(type: .system)
        view.addSubview(signUpButton)
        
        // Set constraints for the sign-up button
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        // Customize the sign-up button's appearance and title
        signUpButton.backgroundColor = UIColor(red: 77/255, green: 83/255, blue: 96/255, alpha: 1.0)
        signUpButton.setTitleColor(.white, for: .normal)
                signUpButton.layer.cornerRadius = 5
                updateSignUpButtonTitle() // Set the initial title of the button
                signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
            }

            @objc private func signUpButtonTapped() {
                if signUpButton.currentTitle == "Log In" {
                    // If the button's title is "Log In," initiate the login process
                    if let email = emailTextField.text, let password = passwordTextField.text {
                        viewModel.setEmail(email)
                        viewModel.setPassword(password)
                        viewModel.signUpOrLogIn { title, message in
                            if title == "Done" {
                                // If the login process is successful, navigate to the EntryVC page
                                let entryVC = EntryVC() // Replace with the correct class name for EntryVC
                                self.navigationController?.pushViewController(entryVC, animated: true)
                            } else {
                                self.showAlert(withTitle: title!, message: message!)
                            }
                        }
                    } else {
                        showAlert(withTitle: "Error", message: "Email or password is missing.")
                    }
                } else {
                    if signUpButton.currentTitle == "Sign Up" {
                        // If the button's title is "Sign Up," initiate the registration process
                        if let email = emailTextField.text, let password = passwordTextField.text {
                            viewModel.setEmail(email)
                            viewModel.setPassword(password)
                            viewModel.signUpOrLogIn { title, message in
                                if title == "Done" {
                                    // If the registration process is successful, show a success message
                                    self.showAlert(withTitle: "Success", message: "Registration completed successfully. Please log in.")
                                } else {
                                    self.showAlert(withTitle: title!, message: message!)
                                }
                            }
                        } else {
                            showAlert(withTitle: "Error", message: "Email or password is missing.")
                        }
                    }
                }
            }

            @objc private func segmentControlValueChanged() {
                viewModel.isSignUp.toggle() // Toggle between Log In and Sign Up mode
                emailTextField.text = ""
                passwordTextField.text = ""
            }

            // Update the title of the Sign Up button based on the current mode (Log In or Sign Up)
            private func updateSignUpButtonTitle() {
                if viewModel.isSignUp {
                    signUpButton.setTitle("Sign Up", for: .normal)
                } else {
                    signUpButton.setTitle("Log In", for: .normal)
                }
            }

            // Display an alert with the provided title and message
            private func showAlert(withTitle title: String, message: String) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
