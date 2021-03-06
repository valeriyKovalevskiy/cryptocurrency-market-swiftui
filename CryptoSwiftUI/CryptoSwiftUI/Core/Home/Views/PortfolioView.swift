//
//  PortfolioView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 12.01.22.
//

import SwiftUI

struct PortfolioView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject private var viewModel: HomeViewModel
  @State private var selectedCoin: CoinModel?
  @State private var quantityText: String = ""
  @State private var showCheckmark: Bool = false
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(
          alignment: .leading,
          spacing: 0) {
            SearchBarView(searchText: $viewModel.searchText)
            coinLogoList
            
            if selectedCoin != nil {
              portfolioInputSection
            }
          }
      }
      .background(
        Color.theme.background
          .ignoresSafeArea()
      )
      .navigationTitle("Edit Portfolio")
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton(presentationMode: _presentationMode)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavBarButton
        }
      })
      .onChange(of: viewModel.searchText) { newValue in
        if newValue.isEmpty {
          removeSelectedCoin()
        }
      }
    }
  }
}

extension PortfolioView {
  private var coinLogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 10) {
        ForEach(
          viewModel.searchText.isEmpty
            ? viewModel.portfolioCoins
            : viewModel.allCoins
        ) { coin in
          CoinLogoView(coin: coin)
            .frame(width: 75)
            .padding(4)
            .onTapGesture {
              withAnimation(.easeIn) {
                updateSelectedCoin(coin: coin)
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                  lineWidth: 1
                )
            )
        }
      }
      .padding(.vertical, 4)
      .frame(height: 120)
      .padding(.leading)
    }
  }

  private func updateSelectedCoin(coin: CoinModel) {
    selectedCoin = coin
    
    if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
       let amount = portfolioCoin.currentHoldings {
      quantityText = "\(amount)"
    } else {
      quantityText = ""
    }
  }

  private var portfolioInputSection: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
        Spacer()
        Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
      }
      Divider()
      HStack {
        Text("Amount holding:")
        Spacer()
        TextField("Ex: 1.4", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      Divider()
      HStack {
        Text("Current value:")
        Spacer()
        Text(getCurrentValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none)
    .padding()
    .font(.headline)
  }
  
  private var trailingNavBarButton: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckmark ? 1 : 0)
      Button(action: {
        saveButtonPressed()
      }, label: {
        Text("Save")
      })
        .opacity(
          (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1 : 0
        )
    }
    .font(.headline)
  }
  
  private func saveButtonPressed() {
    guard
      let coin = selectedCoin,
      let amount = Double(quantityText)
    else { return }
    
    // save to portfolio
    viewModel.updatePortfolio(coin: coin, amount: amount)
    
    // show checkmark
    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
    }
    
    // hide keyboard
    UIApplication.shared.endEditing()
    
    // hide checkmark
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation(.easeOut) {
        showCheckmark = false
      }
    }
  }
  
  private func removeSelectedCoin() {
    selectedCoin = nil
    viewModel.searchText = ""
  }
  
  private func getCurrentValue() -> Double {
    if let quantity = Double(quantityText) {
      return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    return 0
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeViewModel)
      .previewDevice("iPhone 13")
  }
}

