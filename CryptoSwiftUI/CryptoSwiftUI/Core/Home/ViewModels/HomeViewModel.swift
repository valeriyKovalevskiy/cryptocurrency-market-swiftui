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
  @Published var isLoading: Bool = false
  
  private let coinDataService: CoinDataService
  private let marketDataService: MarketDataService
  private let portfolioDataService: PortfolioDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(
    coinDataService: CoinDataService = CoinDataService(),
    marketDataService: MarketDataService = MarketDataService(),
    portfolioDataService: PortfolioDataService = PortfolioDataService()
    
  ) {
    self.coinDataService = coinDataService
    self.marketDataService = marketDataService
    self.portfolioDataService = portfolioDataService
    addSubscribers()
  }
  
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    coinDataService.getCoins()
    marketDataService.getData()
    HapticManager.notification(type: .success)
  }
  
  private func addSubscribers() {
    // updates allCoins
    $searchText
      .combineLatest(coinDataService.$allCoins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] in
        self?.allCoins = $0
      }
      .store(in: &cancellables)
    
    // updates portfolioCoins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] coins in
        self?.portfolioCoins = coins
      }
      .store(in: &cancellables)
    
    // updates marketData
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapGlobalMarketData)
      .sink { [weak self] in
        self?.statistics = $0
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
  
  private func mapAllCoinsToPortfolioCoins(
    allCoins: [CoinModel],
    portfolioEntities: [PortfolioEntity]
  ) -> [CoinModel] {
    allCoins
      .compactMap { coin -> CoinModel? in
        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
          return nil
        }
        
        return coin.updateHoldings(amount: entity.amount)
      }
  }
  
  private func mapGlobalMarketData(
    data: MarketDataModel,
    portfolioCoins: [CoinModel]
  ) -> [StatisticModel] {
    let portfolioValue = portfolioCoins
      .map { $0.currentHoldingsValue }
      .reduce(0, +)
    
    let previousValue = portfolioCoins
      .map { coin -> Double in
        let currentValue = coin.currentHoldingsValue
        let percentChange = coin.priceChangePercentage24H ?? 0.0 / 100
        return currentValue / ( 1 + percentChange)
      }
      .reduce(0, +)
    let percentageChange = (portfolioValue - previousValue) / previousValue
    
    return [
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
        value: portfolioValue.asCurrencyWith2Decimals(),
        percentageChange: percentageChange
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
