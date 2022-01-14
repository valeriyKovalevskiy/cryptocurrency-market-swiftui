//
//  HapticManager.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 14.01.22.
//

import Foundation
import SwiftUI

final class HapticManager {
  static let generator = UINotificationFeedbackGenerator()
  
  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}
