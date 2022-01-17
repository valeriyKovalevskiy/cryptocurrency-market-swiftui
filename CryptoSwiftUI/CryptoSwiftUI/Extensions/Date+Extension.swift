//
//  Date+Extension.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 17.01.22.
//

import Foundation

extension Date {

  private var shortFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    
    return formatter
  }

  //"2021-03-13T20:49:26.606Z"
  init(coinGeckoString: String?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = formatter.date(from: coinGeckoString ?? "") ?? Date()
    
    self.init(timeInterval: 0, since: date)
  }
  

  
  func asShortDateString() -> String {
    shortFormatter.string(from: self)
  }
}
