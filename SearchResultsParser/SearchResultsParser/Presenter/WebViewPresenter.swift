//
//  WebViewPresenter.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import WebKit

class WebViewPresenter: ObservableObject {
    
    enum InteractionMode {
        case user
        case addingSearchResults
    }
    
    var interactionMode: InteractionMode = .user
    var searchResults: [SearchResult] = []
    var webView: WKWebView!

    @Published var showExporter = false
    @Published var canExportSearchResults: Bool = false
    
    func added(webView: WKWebView) {
        self.webView = webView
    }

    func updateUIView() {
        let url = URL(string: "https://www.amazon.com/")!
        
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)
    }

    func exportButtonTapped() {
        guard self.interactionMode == .user else { return }
        
        self.webView.isUserInteractionEnabled = false
        self.interactionMode = .addingSearchResults
        self.updateSearchResults()
    }
    
    func updateSearchResults() {
        self.webView.evaluateJavaScript(JavaScript.SearchResultsPage.jsondSearchResults) { result, error in
            guard error == nil else { fatalError() }
            guard let jsonString = result as? String else { fatalError() }
            guard let data = jsonString.data(using: .utf8) else { fatalError() }
            
            do {
                let searchResults = try JSONDecoder().decode([SearchResult].self, from: data)
                self.searchResults += searchResults
                
                self.webView.evaluateJavaScript(JavaScript.nextPagePath) { result, error in
                    guard error == nil else { fatalError() }
                    
                    if let href = result as? String {
                        let path = "https://www.amazon.com" + href
                        let url = URL(string: path)!
                        self.webView.load(URLRequest(url: url))
                    } else {
                        self.showExporter = true
                    }
                }
            } catch {
                fatalError()
            }
        }
    }

    func didFinishLoading() {
        switch self.interactionMode {
        case .user:
            guard let url = self.webView.url else { fatalError() }
            
            self.canExportSearchResults = url.absoluteString.contains("https://www.amazon.com/s?k")
        case .addingSearchResults:
            self.updateSearchResults()
        }
    }
}
