//
//  ProductDetailView.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import SwiftUI

struct ProductDetailView: View {
  
  @Binding var product: Product?
  
  @StateObject var viewModel = ProductDetailViewModel()
  
  var body: some View {
    if let product = product {
      ScrollView(showsIndicators: false)   {
        VStack(alignment: .leading, spacing: 10) {
          ProductField(label: "Name:", value: product.productName)
          ProductField(label: "Type:", value: product.productType ?? "")
          ProductField(label: "Description:", value: product.description)
          ProductField(label: "Style:", value: product.style)
          ProductField(label: "brand:", value: product.brand)
          ProductField(label: "URL:", value: product.url ?? "")
          ProductField(label: "Price:", value: product.shippingPrice.toCurrencyFormat())
          ProductField(label: "Note:", value: product.note ?? "")
          ProductField(label: "Created:", value: product.getFormattedCreatedAtDate())
          ProductField(label: "Last Updated:", value: product.getFormattedUpdatedAtDate())
        }
        Text("Inventory")
          .font(.largeTitle)
          .bold()
          .padding(.top, 30)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 16)
      .navigationTitle("Product Details")
    }
  }
}

struct ProductField: View {
  var label: String
  var value: String
  
  var body: some View {
    HStack(alignment: .top) {
      Text(label)
      Text(value)
    }
  }
}

//struct ProductDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//      ProductDetailView(product: nil)
//    }
//}
