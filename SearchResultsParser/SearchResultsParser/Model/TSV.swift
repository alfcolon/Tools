//
//  TSV.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import UniformTypeIdentifiers
import SwiftUI

struct TSV: FileDocument, Codable {
    
    static var readableContentTypes: [UTType] { [UTType.tabSeparatedText] }
    static var writableContentTypes: [UTType] { [UTType.tabSeparatedText] }

    let data: Data

    init(searchResults: [SearchResult]) {
        
        func format(text: String?) -> String {
            guard text != nil else { return "" }
            var text = text!.replacingOccurrences(of: "\t", with: "")
            text = text.replacingOccurrences(of: "\n", with: "")
            return text
        }

        let header = "title\tlink\tprime\tdelivery1\tdelivery2\tprice\tcoupon\tstars\treviews\tbuyingOptions\tbuyingOptionsLowestPrice\n"
        
        let body = {
            var body = ""
            
            for searchResult in searchResults {
                let title = format(text: searchResult.productPage.title)
                let link = format(text: searchResult.productPage.path)
                let primeEligible = format(text: searchResult.delivery.prime ? "yes": "no")
                let delivery1 = format(text: searchResult.delivery.option1)
                let delivery2 = format(text: searchResult.delivery.option2)
                let price = format(text: searchResult.price.current)
                let coupon = format(text: searchResult.price.coupon)
                let stars = format(text: searchResult.rating.stars)
                let reviews = format(text: searchResult.rating.totalReviews)
                let buyingOptions = format(text: searchResult.buyingOptions.linkPath)
                let buyingOptionsLowestPrice = format(text: searchResult.buyingOptions.lowestPrice)
                
                body += "\(title)\t\(link)\t\(primeEligible)\t\(delivery1)\t\(delivery2)\t\(price)\t\(coupon)\t\(stars)\t\(reviews)\t\(buyingOptions)\t\(buyingOptionsLowestPrice)\n"
            }
            
            return body
        }()

        let text = header + body
        self.data = text.data(using: .utf8)!
    }
    

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { fatalError() }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: self.data)
    }
}
