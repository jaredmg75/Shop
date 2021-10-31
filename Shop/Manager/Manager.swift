//
//  Manager.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import Foundation
import Combine

class Manager {

  public var styles = [String]()
  
  private var products = [Product]()
  private var nextProductPage = 0
  private var hasMoreProducts = true
  private let productsSubject = PassthroughSubject<[Product], Error>()
    
  private var observables = [AnyCancellable]()

  static let shared = Manager()
  
  private init() {
    getStyles()
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] styles in
        self?.styles = styles
      })
      .store(in: &observables)
  }
  
  func getProductsSubject() -> PassthroughSubject<[Product], Error> {
    return productsSubject
  }
  
  func getProducts() {
    guard hasMoreProducts else {
      self.productsSubject.send(self.products)
      return
    }
    
    Network.shared.getProductsResponse(page: nextProductPage)
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure(let error) = completion {
          self?.productsSubject.send(completion: .failure(error))
        }
      }, receiveValue: { [weak self] productsResponse in
        if let self = self {
          self.products.append(contentsOf: productsResponse.products)
          self.productsSubject.send(self.products)
          
          self.hasMoreProducts = self.products.count < productsResponse.total
          if self.hasMoreProducts {
            self.nextProductPage = self.nextProductPage + 1
            self.getProducts()
          }
        }
      })
      .store(in: &observables)
  }

  func readNewProduct(productId: Int) {
    Network.shared.getProductResponse(productId: productId)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] productResponse in
        if let self = self {
          self.products.insert(productResponse.product, at: 0)
          self.productsSubject.send(self.products)
        }
      })
      .store(in: &observables)
  }
  
  func getStyles() -> (AnyPublisher<[String], Error>) {
    //TODO: Caching the styles in memory
    
    return Network.shared.getStyles()
      .map { styles in
        return styles.styles
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func saveProduct(name: String, description: String, style: String, brand: String, shippingPriceCents: Int) -> (AnyPublisher<Int, Error>) {
    return Network.shared.saveProduct(name: name, description: description, style: style, brand: brand, shippingPriceCents: shippingPriceCents)
  }
  
  
}
