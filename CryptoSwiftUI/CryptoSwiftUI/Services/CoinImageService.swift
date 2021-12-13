//
//  CoinImageService.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageService {
    
    @Published var image: UIImage?
    
    private let coin: CoinModel
    private var imageSubscription: AnyCancellable?
    
    init(
        coin: CoinModel
    ) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap { UIImage(data: $0) }
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] image in
                    self?.image = image
                    self?.imageSubscription?.cancel()
                }
            )
    }
}
