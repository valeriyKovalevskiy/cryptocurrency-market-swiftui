//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 12.12.21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
  @Published var statistics: [StatisticModel] = []
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  @Published var searchText: String = ""
  
  private let coinDataService: CoinDataService
  private let marketDataService: MarketDataService
  private var cancellables = Set<AnyCancellable>()
  private var allCoinsResponse: [CoinModel] = []
  
  init(
    coinDataService: CoinDataService = CoinDataService(),
    marketDataService: MarketDataService = MarketDataService()
    
  ) {
    self.coinDataService = coinDataService
    self.marketDataService = marketDataService
    addSubscribers()
  }
  
  
  func addSubscribers() {
    marketDataService.getData()
      .map(mapGlobalMarketData)
      .sink { [weak self] in
        self?.statistics = $0
      }
      .store(in: &cancellables)
    
    coinDataService.getCoins()
      .sink { [weak self] in
        self?.allCoins = $0
        self?.allCoinsResponse = $0
      }
      .store(in: &cancellables)
    
    $searchText
      .map { $0.isEmpty }
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink { [weak self] isEmpty in
        guard let self = self else { return }
        
        if isEmpty {
          self.allCoins = self.allCoinsResponse
        }
      }
      .store(in: &cancellables)
    
    $searchText
      .combineLatest($allCoins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] in
        self?.allCoins = $0
      }
      .store(in: &cancellables)
  }
  
  private func mapGlobalMarketData(data: MarketDataModel) -> [StatisticModel] {
    [
      StatisticModel(
        title: "Market Cap",
        value: data.marketCap,
        percentageChange: data.marketCapChangePercentage24HUsd
      ),
      StatisticModel(
        title: "24h Volume",
        value: data.volume
      ),
      StatisticModel(
        title: "BTC Dominance",
        value: data.btcDominance
      ),
      StatisticModel(
        title: "Portfolio Value",
        value: "$0.00",
        percentageChange: 0
      )
    ]
  }
  
  private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !text.isEmpty else {
      return coins
    }
    
    let lowercasedText = text.lowercased()
    return coins.filter { coin -> Bool in
      coin.name.lowercased().contains(lowercasedText) ||
      coin.symbol.lowercased().contains(lowercasedText) ||
      coin.id.lowercased().contains(lowercasedText)
    }
  }
}
