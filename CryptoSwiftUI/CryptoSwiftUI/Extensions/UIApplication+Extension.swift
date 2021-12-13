//
//  UIApplication+Extension.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
