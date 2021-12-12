//
//  CryptoSwiftUIApp.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 11.12.21.
//

import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
        }
    }
}
