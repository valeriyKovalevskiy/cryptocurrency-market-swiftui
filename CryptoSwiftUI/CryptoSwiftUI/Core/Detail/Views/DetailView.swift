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
  @State private var showFullDescription = false

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
      VStack {
        ChartView(coin: viewModel.coin)
          .padding(.vertical)
        
        VStack(spacing: 20) {
          overviewTitle
          Divider()
          descriptionSection
          overviewGrid
          additionalTitle
          Divider()
          additionalGrid
          websiteSection
        }
        .padding()
      }
    }
    .navigationTitle(viewModel.coin.name)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        navigationBarTrailingItems
      }
    }
  }
}

extension DetailView {
  private var navigationBarTrailingItems: some View {
    HStack {
      Text(viewModel.coin.symbol.uppercased())
        .font(.headline)
        .foregroundColor(Color.theme.secondaryText)
      CoinImageView(coin: viewModel.coin)
        .frame(width: 25, height: 25)
    }
  }
  
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
  
  private var descriptionSection: some View {
    ZStack {
      if let coinDescription = viewModel.coinDescription,
         !coinDescription.isEmpty {
        VStack(alignment: .leading) {
          Text(coinDescription)
            .lineLimit(showFullDescription ? nil : 3)
            .font(.callout)
            .foregroundColor(Color.theme.secondaryText)
          
          Button(
            action: {
              withAnimation(.easeInOut) {
                showFullDescription.toggle()
              }
            },
            label: {
              Text(showFullDescription ? "Less" : "Read more...")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.vertical, 4)
            })
            .accentColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
  
  private var websiteSection: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let websiteString = viewModel.websiteURL,
         let url = URL(string: websiteString) {
        Link("Website", destination: url)
      }
      
      if let redditString = viewModel.redditURL,
         let url = URL(string: redditString) {
        Link("Reddit", destination: url)
      }
    }
    .accentColor(.blue)
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(.headline)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(coin: dev.coin)
    }
  }
}


