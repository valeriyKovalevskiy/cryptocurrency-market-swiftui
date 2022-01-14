//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 12.12.21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
  @Published var statistics = [StatisticModel]()
  @Published var allCoins = [CoinModel]()
  @Published var portfolioCoins = [CoinModel]()
  @Published var searchText = ""
  @Published var isLoading = false
  @Published var sortOption = SortOptionType.holdings

  private let coinDataService: CoinDataService
  private let marketDataService: MarketDataService
  private let portfolioDataService: PortfolioDataService
  private var cancellables = Set<AnyCancellable>()
  
  enum SortOptionType {
    case rank
    case rankReversed
    case holdings
    case holdingsReversed
    case price
    case priceReversed
  }

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
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] in
        self?.allCoins = $0
      }
      .store(in: &cancellables)
    
    // updates portfolioCoins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] coins in
        guard let self = self else { return }
        
        self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
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
  
  private func filterAndSortCoins(
    text: String,
    coins: [CoinModel],
    sort: SortOptionType
  ) -> [CoinModel] {
    var updatedCoins = filterCoins(text: text, coins: coins)
    sortCoins(sort: sort, coins: &updatedCoins)
    
    return updatedCoins
  }

  private func sortCoins(sort: SortOptionType, coins: inout [CoinModel]) {
    switch sort {
    case .rank, .holdings:
      coins.sort { $0.rank < $1.rank }
    case .rankReversed, .holdingsReversed:
      coins.sort { $0.rank > $1.rank }
    case .price:
      coins.sort { $0.currentPrice > $1.currentPrice }
    case .priceReversed:
      coins.sort { $0.currentPrice < $1.currentPrice }
    }
  }

  private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
    // will only sort by holdings or reversed holdings if needed
    switch sortOption {
    case .holdings:
      return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
    case .holdingsReversed:
      return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
    default:
      return coins
    }
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
