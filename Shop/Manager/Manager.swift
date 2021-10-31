//
//  Manager.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import Foundation
import Combine

class Manager {
  
  var products = [Product]()
  var totalProducts: Int?
  
  func getProducts() -> AnyPublisher<[Product], Error> {
//    if let totalProducts = totalProducts, products.count >= totalProducts {
//      return products.publisher
//    }
    
    return Network.shared.getProductsResponse()
      .map { [weak self] productResponse in
        if let self = self {
          self.products.append(contentsOf: productResponse.products)
          self.totalProducts = productResponse.total
          return self.products
        }
        return productResponse.products
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
