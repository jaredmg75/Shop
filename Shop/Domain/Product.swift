//
//  Product.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import Foundation

let dateFormatter = ISO8601DateFormatter()

struct Product : Codable {
  var id: Int
  var productName: String
  var description: String
  var style: String
  var brand: String
  var createdAt: String
  var updatedAt: String
  var url: String
  var productType: String
  var shippingPrice: Int
  var note: String

  func getCreatedAtDate() -> Date? {
    return dateFormatter.date(from: createdAt)
  }
  
  func getUpdatedAtDate() -> Date? {
    return dateFormatter.date(from: updatedAt)
  }

}

struct ProductResponse : Codable {
  var count: Int
  var products: [Product]
  var total: Int
}
