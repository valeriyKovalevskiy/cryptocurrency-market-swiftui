//
//  ChartView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 17.01.22.
//

import SwiftUI

struct ChartView: View {
  
  private let data: [Double]
  private let lineColor: Color
  private let maxY: Double
  private let minY: Double
  private let startingDate: Date
  private let endingDate: Date
  @State private var percentage: CGFloat = 0
  
  init(coin: CoinModel) {
    data = coin.sparklineIn7D?.price ?? []
    maxY = data.max() ?? 0
    minY = data.min() ?? 0
    endingDate = Date(coinGeckoString: coin.lastUpdated)
    startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    
    let priceChange = (data.last ?? 0) - (data.first ?? 0)
    lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
  }
  
  var body: some View {
    VStack {
      chartView
        .frame(height: 200)
        .background(chartBackground)
      chartDateLabels
    }
    .padding(.horizontal, 4)
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      withAnimation(.linear(duration: 2)) {
        percentage = 1
      }
    }
    }
  }
}

extension ChartView {
  private var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        for index in data.indices {
          let yAxis = maxY - minY
          let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
          let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
          
          if index == 0 {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
          }
          path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
      }
      .trim(from: 0, to: percentage)
      .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor, radius: 10, x: 0, y: 10)
      .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
      .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
      .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
    }
  }
  
  private var chartBackground: some View {
    HStack {
      chartYAxis
      VStack {
        Divider()
        Spacer()
        Divider()
        Spacer()
        Divider()
      }
    }
  }
  
  private var chartYAxis: some View {
    VStack(alignment: .leading) {
      Text(maxY.formattedWithAbbreviations())
      Spacer()
      Text(((maxY + minY) / 2).formattedWithAbbreviations())
      Spacer()
      Text(minY.formattedWithAbbreviations())
    }
  }
  
  private var chartDateLabels: some View {
    HStack {
      Text(startingDate.asShortDateString())
      Spacer()
      Text(endingDate.asShortDateString())
    }
    
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(coin: dev.coin)
  }
}
