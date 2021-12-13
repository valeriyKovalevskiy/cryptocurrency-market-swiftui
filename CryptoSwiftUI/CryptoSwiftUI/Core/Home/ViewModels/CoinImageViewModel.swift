//
//  CoinImageViewModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()

    init(
        coin: CoinModel
    ) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.isLoading = true
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { _ in
                self.isLoading = false
            } receiveValue: { [weak self] in
                self?.image = $0
            }
            .store(in: &cancellables)
    }
}
