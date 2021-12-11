//
//  CoinModel.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 11.12.21.
//

import Foundation

/*
 curl -X 'GET' \
   'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h' \
   -H 'accept: application/json'
 
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 
 {
     "id": "ethereum",
     "symbol": "eth",
     "name": "Ethereum",
     "image": "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
     "current_price": 4034.87,
     "market_cap": 478658101513,
     "market_cap_rank": 2,
     "fully_diluted_valuation": null,
     "total_volume": 21132909654,
     "high_24h": 4101.53,
     "low_24h": 3871.11,
     "price_change_24h": 33.11,
     "price_change_percentage_24h": 0.82749,
     "market_cap_change_24h": 1127968713,
     "market_cap_change_percentage_24h": 0.23621,
     "circulating_supply": 118698062.1865,
     "total_supply": null,
     "max_supply": null,
     "ath": 4878.26,
     "ath_change_percentage": -17.10478,
     "ath_date": "2021-11-10T14:24:19.604Z",
     "atl": 0.432979,
     "atl_change_percentage": 933858.8985,
     "atl_date": "2015-10-20T00:00:00.000Z",
     "roi": {
       "times": 109.9328477704246,
       "currency": "btc",
       "percentage": 10993.284777042461
     },
     "last_updated": "2021-12-11T18:33:24.081Z",
     "sparkline_in_7d": {
       "price": [
         4040.036532974066,
         4068.895142311511,
       ]
     },
     "price_change_percentage_24h_in_currency": 0.8274937823864623
   }
 */


struct CoinModel: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let atlDate: String?
    let athDate: String?
    let atl: Double?
    let ath: Double?
    let lastUpdated: String?
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Double?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let atlChangePercentage: Double?
    let athChangePercentage: Double?
    let priceChangePercentage24HInCurrency: Double?
    let sparklineIn7D: SparklineIn7D?
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case atlDate = "atl_date"
        case athDate = "ath_date"
        case atl
        case ath
        case lastUpdated = "last_updated"
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case atlChangePercentage = "atl_change_percentage"
        case athChangePercentage = "ath_change_percentage"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case sparklineIn7D = "sparkline_in_7d"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        CoinModel(
            id: id,
            symbol: symbol,
            name: name,
            image: image,
            atlDate: atlDate,
            athDate: athDate,
            atl: atl,
            ath: ath,
            lastUpdated: lastUpdated,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume,
            high24H: high24H,
            low24H: low24H,
            priceChange24H: priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H,
            marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            atlChangePercentage: atlChangePercentage,
            athChangePercentage: athChangePercentage,
            priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
            sparklineIn7D: sparklineIn7D,
            currentHoldings: amount
        )
    }
    
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}

