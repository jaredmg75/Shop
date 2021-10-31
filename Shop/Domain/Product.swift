//
//  Product.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import Foundation

struct Product : Codable, Identifiable {
  var id: Int
  var productName: String
  var description: String
  var style: String
  var brand: String
  var createdAt: String
  var updatedAt: String
  var url: String?
  var productType: String?
  var shippingPrice: Int
  var note: String?

  func getFormattedCreatedAtDate() -> String {
    return formatDateString(dateString: createdAt)
  }
  
  func getFormattedUpdatedAtDate() -> String {
    return formatDateString(dateString: updatedAt)
  }

  func formatDateString(dateString: String) -> String {
    // We have to trim off the milliseconds because ISO8601DateFormatter() does not work with them.
    let trimmedIsoString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
    if let date = ISO8601DateFormatter().date(from: trimmedIsoString) {
      let formatter = DateFormatter()
      formatter.timeStyle = .long
      return formatter.string(from: date)
    }
    
    return dateString
  }
}

struct ProductsResponse : Codable {
  var count: Int
  var products: [Product]
  var total: Int
}

struct ProductResponse : Codable {
  var product: Product
}

struct NewProduct: Codable {
  var productName: String
  var description: String
  var style: String
  var brand: String
  var shippingPrice: Int
}

struct NewProductResponse: Codable {
  var message: String
  var productId: Int
}
