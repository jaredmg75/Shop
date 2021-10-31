//
//  LoginViewModel.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import Foundation
import Combine

class LoginViewModel : ObservableObject {
  
  enum Action {
    case loginSuccessful
  }
  
  @Published var loginFailed = false
  @Published var showActivityIndicator = false
  
  var subscribers = [AnyCancellable]()
  var callback: ((Action) -> () )
  
  init(callback: @escaping ((Action) -> ())) {
    self.callback = callback
  }
  
  func login(username: String, password: String) {
    showActivityIndicator = true
    
    Network.shared.login(username: username, password: password)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure(_): self?.loginFailed = true
        case .finished: self?.callback(.loginSuccessful)
        }
        self?.showActivityIndicator = false
      }, receiveValue: { _ in })
      .store(in: &subscribers)
  }
}
