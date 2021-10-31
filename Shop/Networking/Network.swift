//
//  Network.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import Foundation
import Combine

enum NetworkError : Error {
  case login, product
}

class Network {
  
  let SECONDS_1_MINUTE: Double = 60
  let baseUrl = "https://cscodetest.herokuapp.com/api"
  
  var session: URLSession {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = SECONDS_1_MINUTE
    config.timeoutIntervalForResource = SECONDS_1_MINUTE
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.waitsForConnectivity = true
    config.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.never
    return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
  }
  var jwtToken: String?
  var subscribers = [AnyCancellable]()

  static let shared = Network()
  
  private init() {}
    
  func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error> {
    let loginString = "\(username):\(password)"
    guard let url = URL(string: "\(baseUrl)/status"), let loginData = loginString.data(using: String.Encoding.utf8) else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    
    let base64LoginString = loginData.base64EncodedString()
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    
    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: LoginResponse.self, decoder: JSONDecoder())
      .handleEvents( receiveOutput: { [weak self] loginResponse in
        if let token = loginResponse.token {
          self?.jwtToken = token
        }
      })
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func getProductsResponse() -> AnyPublisher<ProductResponse, Error> {
    guard let url = URL(string: "\(baseUrl)/products") else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: ProductResponse.self, decoder: decoder)
      .eraseToAnyPublisher()
  }
  
}

struct LoginResponse: Codable {
  var error: Int?
  var token: String?
}
