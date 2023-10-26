//
//  NetworkStarted.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation
import WebKit

class NetworkStarted {
    // This static function loads a web page in a WKWebView.
    static func loadWebView(webView: WKWebView, url: URL) {
        // Create a URLRequest with the given URL.
        let request = URLRequest(url: url)
        
        // Load the web page in the WKWebView.
        webView.load(request)
    }
}

