//
//  CoinDataService.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import Foundation
import Combine

protocol CoinDataServiceType {
    func getCoins() -> AnyPublisher<[CoinModel], Never>
}

final class CoinDataService: CoinDataServiceType {
    private var cancellables = Set<AnyCancellable>()

    func getCoins() -> AnyPublisher<[CoinModel], Never> {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")!
        return Future<[CoinModel], Never> { [unowned self] promise in
            NetworkingManager.download(url: url)
                .decode(type: [CoinModel].self, decoder: JSONDecoder())
                .sink(
                    receiveCompletion: NetworkingManager.handleCompletion,
                    receiveValue: {
                        promise(.success($0))
                    }
                )
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}
