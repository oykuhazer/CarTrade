//
//  StartedVC.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 19.10.2023.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

class StartedVC: UIViewController {
    // Initialize the WKWebView, button, and label.
    private var webView: WKWebView!
    private var getStartedButton: UIButton!
    private var welcomeLabel: UILabel!

    // Initialize the view model and a DisposeBag for managing disposables.
    private var viewModel = StartedViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up a gradient background for the view.
        view.setupGradientBackground()

        // Initialize and set up the WebView, welcome label, and "Get Started" button.
        setupWebView()
        setupWelcomeLabel()
        setupGetStartedButton()
    }

    // Set up the WKWebView to display content.
    private func setupWebView() {
        let webViewSize = CGSize(width: 300, height: 200)
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)

        view.addSubview(webView)

        webView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(webViewSize)
        }

        // Load content into the WebView using RxSwift.
        Observable.just(viewModel.carTradeData.videoURL)
            .flatMap { url -> Observable<URLRequest> in
                return Observable.create { observer in
                    let request = URLRequest(url: url)
                    observer.onNext(request)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { [weak self] request in
                self?.webView.load(request)
            })
            .disposed(by: disposeBag)
    }

    // Set up the "Get Started" button.
    private func setupGetStartedButton() {
        getStartedButton = UIButton()
        view.addSubview(getStartedButton)
        getStartedButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(650)
            make.width.equalTo(300)
            make.height.equalTo(70)
        }
        
        getStartedButton.setTitle("Explore Cars", for: .normal)
        getStartedButton.backgroundColor = .white
        getStartedButton.setTitleColor(.black, for: .normal)
        getStartedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        getStartedButton.layer.cornerRadius = 35
        getStartedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -110, bottom: 0, right: 0)
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)

        // Add an arrow icon next to the button.
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right.circle.fill"))
        view.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.left.equalTo(getStartedButton.snp.right).offset(-70)
            make.centerY.equalTo(getStartedButton)
            make.width.height.equalTo(50)
        }
        arrowImageView.tintColor = .black
    }

    // Set up the welcome label.
    private func setupWelcomeLabel() {
        welcomeLabel = UILabel()
        view.addSubview(welcomeLabel)
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 2
        welcomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(140)
            make.height.equalTo(80)
        }

        welcomeLabel.text = viewModel.carTradeData.welcomeText
    }
    
    // Handle the "Get Started" button tap.
    @objc func getStartedButtonTapped() {
        let signLogVC = SignLogVC()
        navigationController?.pushViewController(signLogVC, animated: true)
    }
}


