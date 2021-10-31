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
  var jwtToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjYxLCJleHAiOjE2NjcyMzcwMzF9.iutiCiTwOhkr4gYWj2kHA7mh4jnhwB4BC5bP_mL6jHU"
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
  
  func getProductsResponse(page: Int) -> AnyPublisher<ProductsResponse, Error> {
    guard let url = URL(string: "\(baseUrl)/products?page=\(page)"), let jwtToken = jwtToken else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: ProductsResponse.self, decoder: decoder)
      .eraseToAnyPublisher()
  }

  func getProductResponse(productId: Int) -> AnyPublisher<ProductResponse, Error> {
    guard let url = URL(string: "\(baseUrl)/product/\(productId)"), let jwtToken = jwtToken else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: ProductResponse.self, decoder: decoder)
      .eraseToAnyPublisher()
  }

  func getStyles() -> AnyPublisher<Styles, Error> {
    guard let url = URL(string: "\(baseUrl)/styles"), let jwtToken = jwtToken else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: Styles.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func saveProduct(name: String, description: String, style: String, brand: String, shippingPriceCents: Int) -> (AnyPublisher<Int, Error>) {
    guard let url = URL(string: "\(baseUrl)/product"), let jwtToken = jwtToken else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    let newProduct = NewProduct(productName: name, description: description, style: style, brand: brand, shippingPrice: shippingPriceCents)
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase

    guard let encodedBody = try? encoder.encode(newProduct) else {
      return Fail(error: NetworkError.product).eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.httpBody = encodedBody

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: NewProductResponse.self, decoder: decoder)
      .map {
        $0.productId
      }
      .eraseToAnyPublisher()

  }

}

struct LoginResponse: Codable {
  var error: Int?
  var token: String?
}

