//
//  MarketDataService.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 27.12.21.
//

import Foundation
import Combine

protocol MarketDataServiceType {
  func getData() -> AnyPublisher<MarketDataModel, Never>
}

final class MarketDataService: MarketDataServiceType {
  private var cancellables = Set<AnyCancellable>()
  
  func getData() -> AnyPublisher<MarketDataModel, Never> {
    let url = URL(string: "https://api.coingecko.com/api/v3/global")!
    return Future<MarketDataModel, Never> { [unowned self] promise in
      NetworkingManager.download(url: url)
        .decode(type: GlobalData.self, decoder: JSONDecoder())
        .compactMap { $0.data }
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
