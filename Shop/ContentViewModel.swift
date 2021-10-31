//
//  ContentViewModel.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import Foundation

class ContentViewModel : ObservableObject {
  
  enum State {
    case login, app
  }
  
  @Published var currentState = State.login
  
  func createLoginViewModel() -> LoginViewModel {
    return LoginViewModel() { [weak self] action in
      if case .loginSuccessful = action {
        self?.currentState = .app
      }
    }
  }
}
