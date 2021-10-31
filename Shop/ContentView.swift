//
//  ContentView.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = ContentViewModel()
  
  var body: some View {
    switch viewModel.currentState {
    case .login: LoginView(viewModel: viewModel.createLoginViewModel())
    case .app: TabView {
      Color.red
        .tabItem {
            Label("Menu", systemImage: "list.dash")
        }
      Color.blue
        .tabItem {
            Label("Order", systemImage: "square.and.pencil")
        }
    }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
