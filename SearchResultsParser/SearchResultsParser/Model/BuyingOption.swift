//
//  BuyingOption.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import Foundation

struct BuyingOption: Codable {
    
    struct Condition: Codable {
        let category: String?
        let description: String?
        
        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            
            self.category = try? container.decode(String.self, forKey: .category)
            self.description = try? container.decode(String.self, forKey: .description)
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
    struct SellerRating: Codable {
        
        struct Rating: Codable {
            let lifeTime: String?
            let pastYear: String?
            
            init(from decoder: Decoder) throws {
                guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
                
                self.lifeTime = try? container.decode(String.self, forKey: .lifeTime)
                self.pastYear = try? container.decode(String.self, forKey: .pastYear)
            }
        }
        let stars: String?
        let ratings: Rating
        
        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            
            self.stars = try? container.decode(String.self, forKey: .stars)
            self.ratings = try! container.decode(Rating.self, forKey: .ratings)
        }
    }
    struct SoldBy: Codable {
        let name: String?
        let pagePath: String?

        init(from decoder: Decoder) throws {
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
            
            self.name = try? container.decode(String.self, forKey: .name)
            self.pagePath = try? container.decode(String.self, forKey: .pagePath)
        }
    }
    
    let condition: Condition
    let delivery: Delivery
    let element: String = ""
    let price: String?
    let sellerRating: SellerRating
    let shipsFrom: String?
    let soldBy: SoldBy
    
    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError() }
        
        self.condition = try! container.decode(Condition.self, forKey: .condition)
        self.delivery = try! container.decode(Delivery.self, forKey: .delivery)
        self.price = try? container.decode(String.self, forKey: .price)
        self.sellerRating = try! container.decode(SellerRating.self, forKey: .sellerRating)
        self.shipsFrom = try? container.decode(String.self, forKey: .shipsFrom)
        self.soldBy = try! container.decode(SoldBy.self, forKey: .soldBy)
    }
}
