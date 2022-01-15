//
//  DetailViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 15.01.22.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    coinDetailService = CoinDetailDataService(coin: coin)
    addSubscribers()
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .sink { details in
        print(details)
      }
      .store(in: &cancellables)
  }
}
