//
//  HomeView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 11.12.21.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject private var viewModel: HomeViewModel
  @State private var showPortfolio: Bool = false
  @State private var showSettingsView: Bool = false
  @State private var showPortfolioView: Bool = false
  @State private var selectedCoin: CoinModel?
  @State private var showDetailView: Bool = false
  
  var body: some View {
    ZStack {
      // backgroud layer
      Color.theme.background
        .ignoresSafeArea()
        .sheet(isPresented: $showPortfolioView) {
          PortfolioView()
            .environmentObject(viewModel)
        }
      // content layer
      VStack {
        homeHeader
        HomeStatsView(showPortfolio: $showPortfolio)
        SearchBarView(searchText: $viewModel.searchText)
        columnTitles
          .font(.caption)
          .foregroundColor(Color.theme.secondaryText)
          .padding(.horizontal)
        
        if !showPortfolio {
          allCoinsList
            .transition(.move(edge: .leading))
        }
        if showPortfolio {
          ZStack(alignment: .top) {
            if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
              portfolioEmptyText
            } else {
              portfolioCoinsList
            }
          }
          .transition(.move(edge: .trailing))
        }
        Spacer(minLength: 0)
      }
      .sheet(isPresented: $showSettingsView) {
        SettingsView()
          .environmentObject(viewModel)
      }
    }
    .background(
      NavigationLink(
        isActive: $showDetailView,
        destination: { DetailLoadingView(coin: $selectedCoin) },
        label: { EmptyView() }
      )
    )
  }
}

extension HomeView {
  
  private var homeHeader: some View {
    HStack {
      CircleButtonView(iconName: showPortfolio ? "plus" : "info")
        .animation(.none)
        .onTapGesture {
          showPortfolio
          ? showPortfolioView.toggle()
          : showSettingsView.toggle()
        }
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
      Spacer()
      Text(showPortfolio ? "Portfolio" : "Live Prices")
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(Color.theme.accent)
        .animation(.none)
      Spacer()
      CircleButtonView(iconName: "chevron.right")
        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }
  
  private var allCoinsList: some View {
    List {
      ForEach(viewModel.allCoins) { coin in
        CoinRowView(
          coin: coin,
          showHoldingsColumn: false
        )
          .listRowInsets(
            .init(
              top: 10,
              leading: 0,
              bottom: 10,
              trailing: 10
            )
          )
          .onTapGesture { segue(coin: coin) }
          .listRowBackground(Color.theme.background)
      }
    }
    .listStyle(PlainListStyle())
  }
  
  private func segue(coin: CoinModel) {
    selectedCoin = coin
    showDetailView.toggle()
  }

  private var portfolioCoinsList: some View {
    List {
      ForEach(viewModel.portfolioCoins) { coin in
        CoinRowView(
          coin: coin,
          showHoldingsColumn: true
        )
          .listRowInsets(
            .init(
              top: 10,
              leading: 0,
              bottom: 10,
              trailing: 10
            )
          )
          .listRowBackground(Color.theme.background)
      }
    }
    .listStyle(PlainListStyle())
  }
  
  private var portfolioEmptyText: some View {
    Text("You haven't added any coins to your portfolio yet. Click the plus button to get started! ????")
      .font(.callout)
      .foregroundColor(Color.theme.accent)
      .fontWeight(.medium)
      .multilineTextAlignment(.center)
      .padding(50)
  }
  
  private var columnTitles: some View {
    HStack {
      HStack(spacing: 4) {
        Text("Coin")
        Image(systemName: "chevron.down")
          .rotationEffect(
            Angle(degrees: viewModel.sortOption == .rank ? 0 : 180)
          )
          .opacity(
            viewModel.sortOption == .rank ||
            viewModel.sortOption == .rankReversed
            ? 1
            : 0
          )
      }
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .rank
          ? .rankReversed
          : .rank
        }
      }
      Spacer()
      if showPortfolio {
        HStack(spacing: 4) {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .rotationEffect(
              Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180)
            )
            .opacity(
              viewModel.sortOption == .holdings ||
              viewModel.sortOption == .holdingsReversed
              ? 1
              : 0
            )
        }
        .onTapGesture {
          withAnimation(.default) {
            viewModel.sortOption = viewModel.sortOption == .holdings
            ? .holdingsReversed
            : .holdings
          }
        }
      }
      HStack(spacing: 4) {
        Text("Price")
        Image(systemName: "chevron.down")
          .rotationEffect(
            Angle(degrees: viewModel.sortOption == .price ? 0 : 180)
          )
          .opacity(
            viewModel.sortOption == .price ||
            viewModel.sortOption == .priceReversed
            ? 1
            : 0
          )
      }
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .price
          ? .priceReversed
          : .price
        }
      }
      .frame(
        width: UIScreen.main.bounds.width / 3.5,
        alignment: .trailing
      )
      
      Button(
        action: {
          withAnimation(.linear(duration: 2.0)) {
            viewModel.reloadData()
          }
        },
        label: {
          Image(systemName: "goforward")
        }
      )
        .rotationEffect(
          Angle(degrees: viewModel.isLoading ? 360 : 0),
          anchor: .center
        )
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeViewModel)
  }
}
