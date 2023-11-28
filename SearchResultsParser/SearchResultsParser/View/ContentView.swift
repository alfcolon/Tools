//
//  ContentView.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @ObservedObject var presenter: WebViewPresenter = .init()
    
    var body: some View {
        NavigationStack {
            WKWebViewRepresentable(presenter: self.presenter)
                .navigationBarItems(
                    trailing:
                        HStack {
                            Image(systemName: "tablecells")
                                .foregroundColor(self.presenter.canExportSearchResults ? .green : .red)
                                .onTapGesture {
                                    self.presenter.exportButtonTapped()
                                }
                        }
                )
                .fileExporter(isPresented: self.$presenter.showExporter, document: TSV(searchResults: self.presenter.searchResults), contentType: .tabSeparatedText) { result in
                    switch result {
                    case .success(let url):
                        print("Saved to \(url)");
                    case .failure(let error):
                        print(error.localizedDescription);
                    }
                }
        }
    }
}
