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
    private let fileManager: LocalFileManager
    private let folderName = "coin_images"
    private let imageName: String
    private var imageSubscription: AnyCancellable?
    
    
    init(
        coin: CoinModel,
        fileManager: LocalFileManager = LocalFileManager.instance
    ) {
        self.coin = coin
        self.fileManager = fileManager
        self.imageName = coin.id
        
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap { UIImage(data: $0) }
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] image in
                    guard let _self = self,
                          let image = image
                    else { return }
                    _self.image = image
                    _self.imageSubscription?.cancel()
                    _self.fileManager.saveImage(
                        image: image,
                        imageName: _self.imageName,
                        folderName: _self.folderName
                    )
                }
            )
    }
}
