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
  @State private var showLaunchView: Bool = true
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    UITableView.appearance().backgroundColor = UIColor.clear
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        NavigationView {
          HomeView()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)  // force iPad use same navigation as iPhone
        .environmentObject(viewModel)
        
        ZStack {
          if showLaunchView {
            LaunchView(showLaunchView: $showLaunchView)
              .transition(.move(edge: .leading))
          }
        }
        .zIndex(2.0)
      }
    }
  }
}
