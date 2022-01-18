//
//  String+Extension.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 18.01.22.
//

import Foundation

extension String {
  var removingHTMLOccurences: String {
    self.replacingOccurrences(
      of: "<[^>]+>",
      with: "",
      options: .regularExpression,
      range: nil
    )
  }
}
