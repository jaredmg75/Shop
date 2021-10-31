//
//  ProductsView.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import SwiftUI

struct ProductsView: View {
  @StateObject var viewModel = ProductsViewModel()
  
  @State var selection: String?
  @State var selectedProduct: Product?
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        NavigationLink(destination: ProductDetailView(product: $selectedProduct), tag: "detail", selection: $selection) { EmptyView() }
        NavigationLink(destination: ProductAddView(), tag: "add", selection: $selection) { EmptyView() }
        ForEach(viewModel.products) { product in
          HStack {
            Text(product.productName)
            Spacer()
            Text(product.brand)
          }
          .padding()
          .background(Color.background)
          .cornerRadius(15)
          .onTapGesture {
            self.selectedProduct = product
            self.selection = "detail"
          }
        }
      }
      .padding(.horizontal, 16)
      .navigationTitle("Products")
      .navigationBarItems(
        trailing:
          Button(action: {
            self.selection = "add"
          }) {
            Image(systemName: "plus.app.fill")
          })
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .alert(isPresented:$viewModel.showError) {
      return Alert(
        title: Text("Unable to read product list"),
        message: Text("Please check your connection or try again later."))
    }
  }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
