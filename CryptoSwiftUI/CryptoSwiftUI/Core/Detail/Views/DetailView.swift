//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 14.01.22.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: CoinModel?
  
  var body: some View {
    ZStack {
      if let coin = coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  
  @StateObject var viewModel: DetailViewModel
  let coin: CoinModel
  
  init(coin: CoinModel) {
    self.coin = coin
    _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    
    print("initializing detail view for \(coin.name)")
  }

  var body: some View {
    Text(coin.name)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
