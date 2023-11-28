//
//  SearchResult.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import Foundation

struct SearchResult: Codable {
    
    struct BuyingOptions: Codable {
        let linkPath: String?
        let listedCount: Int?
        var offers: [BuyingOption]?
        var lowestPrice: String?
        
        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            self.lowestPrice = try? container.decode(String.self, forKey: .lowestPrice)
            self.linkPath = try? container.decode(String.self, forKey: .linkPath)
            self.listedCount = try? container.decode(Int.self, forKey: .listedCount)
            self.offers = try? container.decode([BuyingOption].self, forKey: .offers)
        }
    }
    struct Delivery: Codable {
        let prime: Bool
        let option1: String?
        let option2: String?
        
        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            
            self.prime = try! container.decode(Bool.self, forKey: .prime)
            self.option1 = try? container.decode(String.self, forKey: .option1)
            self.option2 = try? container.decode(String.self, forKey: .option2)
        }
    }
    struct Price: Codable {
        let current: String?
        let original: String?
        let coupon: String?

        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
    
            self.current = try? container.decode(String.self, forKey: .current)
            self.original = try? container.decode(String.self, forKey: .original)
            self.coupon = try? container.decode(String.self, forKey: .coupon)
        }
    }
    struct ProductPage: Codable {
        let title: String?
        let path: String?

        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            
            self.title = try? container.decode(String.self, forKey: .title)
            self.path = try? container.decode(String.self, forKey: .path)
        }
    }
    struct Rating: Codable {
        let stars: String?
        let totalReviews: String?
        
        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            
            self.stars = try? container.decode(String.self, forKey: .stars)
            self.totalReviews = try? container.decode(String.self, forKey: .totalReviews)
        }
    }
    
    let uuid: UUID
    let condition: String
    let delivery: Delivery
    let imgsrc: String?
    let price: Price
    let productPage: ProductPage
    let rating: Rating
    let index: Int
    let page: Int
    var buyingOptions: BuyingOptions
    
    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
        
        self.uuid = (try? container.decode(UUID.self, forKey: .uuid)) ?? .init()
        self.buyingOptions = try! container.decode(BuyingOptions.self, forKey: .buyingOptions)
        self.condition = try! container.decode(String.self, forKey: .condition)
        self.delivery = try! container.decode(Delivery.self, forKey: .delivery)
        self.imgsrc = try? container.decode(String.self, forKey: .imgsrc)
        self.price = try! container.decode(Price.self, forKey: .price)
        self.productPage = try! container.decode(ProductPage.self, forKey: .productPage)
        self.rating = try! container.decode(Rating.self, forKey: .rating)
        self.index = try! container.decode(Int.self, forKey: .index)
        self.page = (try? container.decode(Int.self, forKey: .page)) ?? 0
    }
}
