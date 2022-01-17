//
//  DetailViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 15.01.22.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
  @Published var overviewStatistics: [StatisticModel] = []
  @Published var additionalStatistics: [StatisticModel] = []
  @Published var coin: CoinModel
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coin = coin
    coinDetailService = CoinDetailDataService(coin: coin)
    addSubscribers()
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map(mapDataToStatisticsArrays)
      .sink { [weak self] arrays in
        self?.overviewStatistics = arrays.overview
        self?.additionalStatistics = arrays.additional
      }
      .store(in: &cancellables)
  }
  
  private func mapDataToStatisticsArrays(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
    (
      createOverviewArray(coinModel: coinModel),
      createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
    )
  }
  
  private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
    [
      StatisticModel(
        title: "Current Price",
        value: coinModel.currentPrice.asCurrencyWith6Decimals(),
        percentageChange: coinModel.priceChangePercentage24H
      ),
      StatisticModel(
        title: "Market Capitalization",
        value: "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? ""),
        percentageChange: coinModel.marketCapChangePercentage24H
      ),
      StatisticModel(
        title: "Rank",
        value: "\(coinModel.rank)"
      ),
      StatisticModel(
        title: "Volume",
        value: "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
      ),
    ]
  }
  
  private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
    let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
    return [
      StatisticModel(
        title: "24h High",
        value: coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
      ),
      StatisticModel(
        title: "24h Low",
        value: coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
      ),
      StatisticModel(
        title: "24h Price Change",
        value: coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A",
        percentageChange: coinModel.priceChangePercentage24H
      ),
      StatisticModel(
        title: "24h Market Cap Change",
        value: "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? ""),
        percentageChange: coinModel.marketCapChangePercentage24H
      ),
      StatisticModel(
        title: "Block time",
        value: blockTime == 0 ? "N/A" : "\(blockTime)"
      ),
      StatisticModel(
        title: "Hashing Algorithm",
        value: coinDetailModel?.hashingAlgorithm ?? "N/A"
      ),
    ]
  }
}
