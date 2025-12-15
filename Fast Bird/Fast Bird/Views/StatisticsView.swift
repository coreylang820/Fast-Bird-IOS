//
//  StatisticsView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GameStatistics.timestamp, order: .reverse) private var statistics: [GameStatistics]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let bgImage = ResourceManager.shared.uiImage(named: .statBg) {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea(.all)
                } else {
                    Color(red: 0.2, green: 0.3, blue: 0.5)
                        .ignoresSafeArea(.all)
                }
                
                VStack(spacing: 0) {
                    // Stat top (50% width, 1:1 ratio, 19dp top)
                    if let topImage = ResourceManager.shared.uiImage(named: .statTop) {
                        let topSize = geometry.size.width * 0.5
                        Image(uiImage: topImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: topSize, height: topSize)
                            .padding(.top, 19)
                    }
                    
                    // Frame (84% width, 70% height, -49dp margin)
                    ZStack {
                        if let frameImage = ResourceManager.shared.uiImage(named: .ppFrame) {
                            Image(uiImage: frameImage)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        VStack(spacing: 20) {
                            // Statistics header (75% width, 772:256 ratio)
                            if let headerImage = ResourceManager.shared.uiImage(named: .statistics) {
                                Image(uiImage: headerImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.75)
                                    .padding(.top, 45)
                            }
                            
                            // Statistics list
                            ScrollView {
                                VStack(spacing: 10) {
                                    ForEach(Array(statistics.enumerated()), id: \.element.id) { index, stat in
                                        GeometryReader { itemGeometry in
                                            let totalWeight: CGFloat = 1 + 4 + 5.5 + 2 // 12.5 (номер увеличен, score уменьшен)
                                            let availableWidth = itemGeometry.size.width - 58 - 6 // минус padding и разделители (2+2+2)
                                            
                                            HStack(spacing: 0) {
                                                // Номер по порядку (weight=1) - немного увеличенный вес
                                                Text("\(index + 1)")
                                                    .font(.custom("Bungee-Regular", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(width: availableWidth * 1 / totalWeight)
                                                
                                                // Дата (weight=4)
                                                Text(stat.formattedDate())
                                                    .font(.custom("Bungee-Regular", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(width: availableWidth * 4 / totalWeight, alignment: .leading)
                                                    .multilineTextAlignment(.leading)
                                                
                                                // Разделитель (2dp)
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: 2)
                                                
                                                // Score (weight=5.5) - немного уменьшенный вес, текст "score:3211", uppercase
                                                Text("score:\(stat.score)")
                                                    .font(.custom("Bungee-Regular", size: 12))
                                                    .foregroundColor(.white)
                                                    .textCase(.uppercase)
                                                    .frame(width: availableWidth * 5.5 / totalWeight, alignment: .leading)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.leading, 4)
                                                
                                                // Разделитель (2dp)
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: 2)
                                                
                                                // Результат игры (weight=2, "win" или "lose", uppercase)
                                                Text(stat.isWin ? "win" : "lose")
                                                    .font(.custom("Bungee-Regular", size: 12))
                                                    .foregroundColor(.white)
                                                    .textCase(.uppercase)
                                                    .frame(width: availableWidth * 2 / totalWeight)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.leading, 4)
                                            }
                                            .padding(.horizontal, 29)
                                        }
                                        .frame(height: 30)
                                    }
                                }
                            }
                            .frame(height: geometry.size.height * 0.4)
                            
                            // Back button (35% width, 468:185 ratio)
                            Button(action: {
                                dismiss()
                            }) {
                                if let backImage = ResourceManager.shared.uiImage(named: .btnBackWidth) {
                                    Image(uiImage: backImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.35)
                                }
                            }
                            .padding(.bottom, 45)
                        }
                        .frame(width: geometry.size.width * 0.84)
                        .frame(height: geometry.size.height * 0.7)
                    }
                    .offset(y: -49)
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

