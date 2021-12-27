//
//  Double+Extension.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 12.12.21.
//

import Foundation

extension Double {
    
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    ///Convert 1234.56 to $1,234.56
    ///Convert 12.3456 to $12.34
    ///Convert 0.123456 to $0.12
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    /// Converts a Double into a Currency as a String with 2-6 decimal places
    /// ```
    ///
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 12.3456 to "$12.34"
    ///Convert 0.123456 to "$0.12"
    ///
    /// ```
    func asCurrencyWith2Decimals() -> String {
        currencyFormatter2.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    ///
    ///Convert 1234.56 to $1,234.56
    ///Convert 12.3456 to $12.3456
    ///Convert 0.123456 to $0.123456
    ///
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    /// Converts a Double into a Currency as a String with 2-6 decimal places
    /// ```
    ///
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 12.3456 to "$12.3456"
    ///Convert 0.123456 to "$0.123456"
    ///
    /// ```
    func asCurrencyWith6Decimals() -> String {
        currencyFormatter6.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    /// Converts a Double into string representation
    /// ```
    ///
    ///Convert 12.3456 to "12.34"
    ///
    /// ```
    func asNumberString() -> String {
        String(format: "%.2f", self)
    }
    
    /// Converts a Double into string representation
    /// ```
    ///
    ///Convert 12.3456 to "12.34%"
    ///
    /// ```
    func asPercentString() -> String {
        asNumberString() + "%"
    }
}
