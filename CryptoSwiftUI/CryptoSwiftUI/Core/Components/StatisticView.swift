//
//  StatisticView.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 27.12.21.
//

import SwiftUI

struct StatisticView: View {
    let model: StatisticModel
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            Text(model.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            
            Text(model.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(
                            degrees: (model.percentageChange ?? 0) >= 0 ? 0 : 180
                        )
                    )
                Text(model.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((model.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(model.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(model: dev.staticticModel1)
                .preferredColorScheme(.dark)
            StatisticView(model: dev.staticticModel2)
            StatisticView(model: dev.staticticModel3)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
