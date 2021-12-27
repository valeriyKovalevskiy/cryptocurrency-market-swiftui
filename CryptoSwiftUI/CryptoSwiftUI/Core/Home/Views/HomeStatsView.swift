//
//  HomeStatsView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 27.12.21.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { model in
                StatisticView(model: model)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeViewModel)
    }
}
