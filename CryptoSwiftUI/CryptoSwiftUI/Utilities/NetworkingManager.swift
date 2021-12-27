//
//  NetworkingManager.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import Foundation
import Combine

final class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return " [😔] Bad response from URL: \(url)"
            case .unknown:
                return " [⚠️] Unknown error occured"
            }
        }
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .logRequest()
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap {
                try handleURLResponse(
                    output: $0,
                    url: url
                )
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(
        output: URLSession.DataTaskPublisher.Output,
        url: URL
    ) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            debugPrint(error.localizedDescription)
        }
    }
}
