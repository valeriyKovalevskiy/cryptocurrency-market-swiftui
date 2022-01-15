//
//  CoinDetailDataService.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 15.01.22.
//

import Foundation
import Combine

final class CoinDetailDataService {
  var coinDetailSubscription: AnyCancellable?
  @Published var coinDetails: CoinDetailModel?
  private let coin: CoinModel
  
  init(coin: CoinModel) {
    self.coin = coin
    getCoinDetails()
  }
  
  func getCoinDetails() {
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")!
    
    coinDetailSubscription = NetworkingManager.download(url: url)
      .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
      .sink(
        receiveCompletion: NetworkingManager.handleCompletion,
        receiveValue: { [weak self] in
          self?.coinDetails = $0
          self?.coinDetailSubscription?.cancel()
        }
      )
  }
}

