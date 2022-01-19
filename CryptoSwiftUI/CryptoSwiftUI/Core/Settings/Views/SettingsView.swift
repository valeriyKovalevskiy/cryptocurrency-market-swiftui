//
//  SettingsView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 18.01.22.
//

import SwiftUI

struct SettingsView: View {
  let defaultURL = URL(string: "https://www.google.com")!
  let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
  let cofeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
  let coingeckoURL = URL(string: "https://www.coingecko.com")!
  let personalURL = URL(string: "https://github.com/valeriyKovalevskiy")!
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    NavigationView {
      List {
        swiftfulThinkingSection
        coinGeckoSection
        developerSection
        applicationSection
      }
      .font(.headline)
      .accentColor(.blue)
      .listStyle(.grouped)
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton(presentationMode: _presentationMode)
        }
      }
    }
  }
}

extension SettingsView {
  private var swiftfulThinkingSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Arcitecture, Combine and CoreData")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(Color.theme.accent)
      }
      .padding(.vertical)
      Link("Subscribe on YouTube 🥳", destination: youtubeURL)
      Link("Support his coffee addiction ☕️", destination: cofeeURL)
    } header: {
      Text("Swiftful Thinking")
    }
  }
  
  private var coinGeckoSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(Color.theme.accent)
      }
      .padding(.vertical)
      
      Link("Visit CoinGecko 🦎", destination: coingeckoURL)
    } header: {
      Text("CoinGecko")
    }
  }
  
  private var developerSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("This app was developed by Valery Kavaleuski. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(Color.theme.accent)
      }
      .padding(.vertical)
      
      Link("Visit GitHub 🤙", destination: personalURL)
    } header: {
      Text("Developer")
    }
  }
  
  private var applicationSection: some View {
    Section {
      Link("Terms of Service", destination: defaultURL)
      Link("Privacy Policy", destination: defaultURL)
      Link("Company Website", destination: defaultURL)
      Link("Learn More", destination: defaultURL)
    } header: {
      Text("Application")
    }
  }

}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
