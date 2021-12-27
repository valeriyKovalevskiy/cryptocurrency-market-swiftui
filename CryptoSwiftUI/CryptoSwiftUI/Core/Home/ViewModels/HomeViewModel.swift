//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 12.12.21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticModel] = [
        StatisticModel(
            title: "Title",
            value: "Value",
            percentageChange: 1
        ),
        
        StatisticModel(
            title: "Title",
            value: "Value",
            percentageChange: 1
        ),
        
        StatisticModel(
            title: "Title",
            value: "Value",
            percentageChange: -8
        ),
        
        StatisticModel(
            title: "Title",
            value: "Value"
        )
    ]

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let dataService: CoinDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        dataService: CoinDataService = CoinDataService()
    ) {
        self.dataService = dataService
        addSubscribers()
    }
    
    
    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] in
                self?.allCoins = $0
            }
            .store(in: &cancellables)
      
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] in
                self?.allCoins = $0
            }
            .store(in: &cancellables)
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
