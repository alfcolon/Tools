//
//  WKWebViewRepresentable.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import WebKit
import SwiftUI

struct WKWebViewRepresentable: UIViewRepresentable  {

    typealias UIViewType = WKWebView

    let presenter: WebViewPresenter

    init(presenter: WebViewPresenter) {
        self.presenter = presenter
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        
        let config = WKWebViewConfiguration()
        
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator

        self.presenter.added(webView: webView)

        return webView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        self.presenter.updateUIView()
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(presenter: self.presenter)
        return coordinator
    }
}

extension WKWebViewRepresentable {

    final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler  {

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            // using evalJS
            fatalError()
        }
        
        let presenter: WebViewPresenter
        
        init(presenter: WebViewPresenter) {
            self.presenter = presenter
        }
        
        // MARK: - WKNavigationDelegate

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.presenter.didFinishLoading()
        }
    }
}

