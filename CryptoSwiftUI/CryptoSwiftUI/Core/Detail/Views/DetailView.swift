//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 14.01.22.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: CoinModel?
  
  var body: some View {
    ZStack {
      if let coin = coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  
  @StateObject var viewModel: DetailViewModel
  let coin: CoinModel
  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  private let spacing: CGFloat = 30
  
  init(coin: CoinModel) {
    self.coin = coin
    _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    
    print("initializing detail view for \(coin.name)")
  }

  var body: some View {
      ScrollView {
        VStack(spacing: 20) {
          Text("")
            .frame(height: 150)
          overviewTitle
          Divider()
          overviewGrid
          additionalTitle
          Divider()
          additionalGrid
        }
        .padding()
      }
      .navigationTitle(viewModel.coin.name)
  }
}

extension DetailView {
  private var overviewTitle: some View {
    Text("Overview")
      .font(.title)
      .bold()
      .foregroundColor(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var overviewGrid: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      pinnedViews: [],
      content: {
        ForEach(viewModel.overviewStatistics) {
          StatisticView(model: $0)
        }
      })
  }
  
  private var additionalTitle: some View {
    Text("AdditionalDetails")
      .font(.title)
      .bold()
      .foregroundColor(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var additionalGrid: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      pinnedViews: [],
      content: {
        ForEach(viewModel.additionalStatistics) {
          StatisticView(model: $0)
        }
      })
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(coin: dev.coin)
    }
  }
}


