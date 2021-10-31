//
//  StringExtension.swift
//  Shop
//
//  Created by Jared Green on 10/31/21.
//

import Foundation

extension Int {
  func toCurrencyFormat() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale.current
    numberFormatter.numberStyle = NumberFormatter.Style.currency
    let doubleValue = Double(self) / 100
    return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
  }
}
