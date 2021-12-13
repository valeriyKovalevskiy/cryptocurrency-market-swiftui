//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 12.12.21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
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
    }
}
