//
//  CoinDataService.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import Foundation
import Combine

protocol CoinDataServiceType {
  func getCoins()
}

final class CoinDataService: CoinDataServiceType {
//  private var cancellables = Set<AnyCancellable>()
  var coinSubscription: AnyCancellable?
  @Published var allCoins: [CoinModel] = []
  
  init() {
    getCoins()
  }
  
  func getCoins() {
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")!
    
    coinSubscription = NetworkingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: JSONDecoder())
      .sink(
        receiveCompletion: NetworkingManager.handleCompletion,
        receiveValue: { [weak self] in
          self?.allCoins = $0
          self?.coinSubscription?.cancel()
        }
      )
  }
}
