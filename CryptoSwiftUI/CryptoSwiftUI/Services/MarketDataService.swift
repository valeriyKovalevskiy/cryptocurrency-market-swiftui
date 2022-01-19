//
//  MarketDataService.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 27.12.21.
//

import Foundation
import Combine

protocol MarketDataServiceType {
  func getData()
}

final class MarketDataService: MarketDataServiceType {
  private var cancellables = Set<AnyCancellable>()
  var dataSubscription: AnyCancellable?
  @Published var marketData: MarketDataModel = .init(totalMarketCap: [:], totalVolume: [:], marketCapPercentage: [:], marketCapChangePercentage24HUsd: 0.0)
  init() {
    getData()
  }
  func getData() {
    let url = URL(string: "https://api.coingecko.com/api/v3/global")!
    
    dataSubscription = NetworkingManager.download(url: url)
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .compactMap { $0.data }
      .sink(
        receiveCompletion: NetworkingManager.handleCompletion,
        receiveValue: { [weak self] model in
          self?.marketData = model
          self?.dataSubscription?.cancel()
        }
      )
  }
}
