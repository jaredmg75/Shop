//
//  LoginView.swift
//  Shop
//
//  Created by Jared Green on 10/30/21.
//

import SwiftUI

struct LoginView: View {
  @StateObject var viewModel: LoginViewModel
  
  @State var username = ""
  @State var password = ""

  var body: some View {
    ZStack {
      VStack {
        Text("Shop App")
          .font(.headline)
        Form {
          TextField("User Name", text: $username)
          SecureField("Password", text: $password)
        }
        Button("Login") {
          viewModel.login(username: username, password: password)
        }
        .font(.system(size: 16))
        .multilineTextAlignment(.center)
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
        .background(Color.blue)
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 8))
        Spacer()
      }
      .alert(isPresented:$viewModel.loginFailed) {
        return Alert(
          title: Text("Login Failed"),
          message: Text("Please check your username and password and try again."))
      }

      ProgressView()
        .scaleEffect(2)
        .opacity(viewModel.showActivityIndicator ? 1 : 0)
    }
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
      LoginView(viewModel: LoginViewModel(callback: { _ in }))
    }
}
