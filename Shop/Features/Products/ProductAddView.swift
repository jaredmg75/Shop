//
//  ProductAddView.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import SwiftUI

struct ProductAddView: View {
  @Environment(\.presentationMode) var presentation
  
  @ObservedObject var viewModel = ProductAddViewModel()
  
  @State var name = ""
  @State var description = ""
  @State var style = ""
  @State var brand = ""
  @State var shippingPrice = ""
  
  var body: some View {
    ZStack {
      VStack {
        Form {
          TextField("Name", text: $name)
          TextField("Description", text: $description)
          //TODO: Only allow up to 2 digit decimal precision
          Picker("Style", selection: $style) {
            ForEach(viewModel.styles, id: \.self) {
              Text($0)
            }
          }
          TextField("Brand", text: $brand)
          TextField("Shipping Price", text: $shippingPrice)
            .keyboardType(.decimalPad)
        }
        Button("Save") {
          viewModel.save(name: name, description: description, style: style, brand: brand, shippingPrice: shippingPrice) {
            self.presentation.wrappedValue.dismiss()
          }
        }
        .font(.system(size: 16))
        .multilineTextAlignment(.center)
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
        .background(Color.blue)
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 8))
        .disabled(name.isEmpty || description.isEmpty || style.isEmpty || brand.isEmpty || shippingPrice.isEmpty)
        Spacer()
      }
      .alert(isPresented:$viewModel.saveFailed) {
        return Alert(
          title: Text("Save Failed"),
          message: Text("Please check your connection or try again later."))
      }
      .navigationTitle("Add New Product")

      ProgressView()
        .scaleEffect(2)
        .opacity(viewModel.showActivityIndicator ? 1 : 0)
    }
  }
}

struct ProductAddEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductAddView()
    }
}
