//
//  AuthorizationWebView.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/19/25.
//  Copyright © 2025 orgName. All rights reserved.
//


import SwiftUI
import UIKit
@preconcurrency import WebKit
import shared

struct AuthorizationWebView: UIViewRepresentable {
    let urlPath: String
    let notFoundURL: URL = URL(string: Networking.Paths().notFound())!
    let onSessionTokenReceived: (String) -> Void // Callback closure
    let loginFailed: (String?) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Mobile Safari/537.36"
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: urlPath) ?? notFoundURL
        print(url.absoluteString)
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onSessionTokenReceived: onSessionTokenReceived, loginFailed: loginFailed)
    }

    // MARK: - Coordinator Class
    class Coordinator: NSObject, WKNavigationDelegate {
        let onSessionTokenReceived: (String) -> Void
        let loginFailed: (String?) -> Void

        init(onSessionTokenReceived: @escaping (String) -> Void, loginFailed: @escaping (String?) -> Void) {
            self.onSessionTokenReceived = onSessionTokenReceived
            self.loginFailed = loginFailed
        }

        // WKNavigationDelegate method to decide policy for navigation action
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = webView.url else {
                decisionHandler(.cancel)
                // dismiss the webview here
                return
            }
            
            
            if(EnvironmentConfiguration().environmentType == EnvironmentConfiguration.Types.dev) {
                if(url.absoluteString.starts(with: EnvironmentConfiguration().callbackOrigin)) {
                    let updatedString = url.absoluteString.replacing(EnvironmentConfiguration().callbackOrigin,
                                                                     with: EnvironmentConfiguration().apiOrigin)
                    guard let newURL = URL(string: updatedString) else {
                        decisionHandler(.cancel)
                        // dismiss the webview here
                        return
                    }
                    let request = URLRequest(url: newURL)
                    webView.load(request)
                    decisionHandler(.allow)
                    return
                }
            }
            
            if url.absoluteString.starts(with: Networking.Paths().authorizationSuccessStart()),
                           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                           let queryItems = components.queryItems,
                           let sessionToken = queryItems.first(where: { $0.name == "sessionToken" })?.value {
                            onSessionTokenReceived(sessionToken)
            } else if url.absoluteString.starts(with: Networking.Paths().authorizationFailureStart()) {
                // Error description can be nil
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                let queryItems = components?.queryItems
                let error_description = queryItems?.first(where: { $0.name == "error_description" })?.value
                loginFailed(error_description)
            }
                
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url {
            print("Finished loading URL: \(currentURL.absoluteString)")
        }
    }
}
