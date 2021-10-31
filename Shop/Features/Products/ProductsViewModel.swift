//
//  ProductsViewModel.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import Foundation
import Combine

class ProductsViewModel : ObservableObject {
  
  @Published var showError = false
  @Published var products = [Product]()
  
  var observables = [AnyCancellable]()
  
  init() {
    readProducts()
  }
    
  func readProducts() {
    Manager.shared.getProductsSubject()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure(_): self?.showError = true
        case .finished: print("Successfully read a page of products")
        }
      }, receiveValue: { [weak self] products in
        self?.products = products
      })
      .store(in: &observables)
    
    Manager.shared.getProducts()
  }
  
}
