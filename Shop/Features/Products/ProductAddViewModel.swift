//
//  ProductAddViewModel.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import Foundation
import Combine
import SwiftUI

class ProductAddViewModel : ObservableObject {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  @Published var saveFailed = false
  @Published var showActivityIndicator = false
  @Published var styles: [String]
  @Published var colors = [String]()

  var observables = [AnyCancellable]()
  
  private var closeCB: (()->())?

  init() {
    self.styles = Manager.shared.styles
  }
  
  func save(name: String, description: String, style: String, brand: String, shippingPrice: String, escaping closeCB: @escaping ()->()) {
    self.closeCB = closeCB
    //TODO: Form validation
    if let shippingPriceDouble = Double(shippingPrice) {
      let shippingPriceCents = Int(shippingPriceDouble * 100)

      showActivityIndicator = true

      Manager.shared.saveProduct(name: name, description: description, style: style, brand: brand, shippingPriceCents: shippingPriceCents)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] completion in
          switch completion {
          case .failure(let error):
            print(error)
            self?.saveFailed = true
            self?.showActivityIndicator = false
          case .finished: print("Successfully created product")
          }
        }, receiveValue: { [weak self] productId in
          Manager.shared.readNewProduct(productId: productId)
          self?.closeCB?()
        })
        .store(in: &observables)
    }
  }
    
  func close() {
    DispatchQueue.main.async {
//      self.showActivityIndicator = false
      self.presentationMode.wrappedValue.dismiss()
    }
  }
}
