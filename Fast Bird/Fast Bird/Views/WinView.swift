//
//  WinView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import SwiftData

struct WinView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let score: Int
    let level: Int
    let onBackToMenu: () -> Void
    let onRestart: () -> Void
    @State private var bestScore: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let bgImage = ResourceManager.shared.uiImage(named: .winnerBackground) {
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
                
                // Frame (86% width, 891:811 ratio) - по центру вертикально
                let frameWidth = geometry.size.width * 0.86
                let frameHeight = frameWidth * (811.0 / 891.0)
                let frameCenterY = geometry.size.height / 2
                let frameTopY = frameCenterY - frameHeight / 2
                
                // Winner bird - низ привязан к верху рамки, высота 0.3 от высоты экрана
                if let birdImage = ResourceManager.shared.uiImage(named: .winnerBird) {
                    let birdHeight = geometry.size.height * 0.3
                    let birdWidth = birdHeight // 1:1 ratio
                    Image(uiImage: birdImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: birdWidth, height: birdHeight)
                        .position(
                            x: geometry.size.width / 2,
                            y: frameTopY - birdHeight / 2 + 40 // Опускаем курицу ниже
                        )
                }
                
                // Frame
                ZStack {
                    if let frameImage = ResourceManager.shared.uiImage(named: .frameSquare) {
                        Image(uiImage: frameImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth, height: frameHeight)
                    }
                    
                    // Score и Best по центру рамки (Score над центром, Best под центром)
                    ZStack {
                        // Score - над центром (bottom привязан к центру)
                        Text("score \(score)")
                            .font(.custom("Bungee-Regular", size: 40))
                            .foregroundColor(.white)
                            .textCase(.uppercase)
                            .position(
                                x: frameWidth / 2,
                                y: frameHeight / 2 - 20
                            )
                        
                        // Best - под центром (top привязан к центру)
                        Text("best \(bestScore)")
                            .font(.custom("Bungee-Regular", size: 40))
                            .foregroundColor(.white)
                            .textCase(.uppercase)
                            .position(
                                x: frameWidth / 2,
                                y: frameHeight / 2 + 20
                            )
                    }
                    .frame(width: frameWidth, height: frameHeight)
                }
                .position(
                    x: geometry.size.width / 2,
                    y: frameCenterY
                )
                
                // Winner text (90% width, 958:317 ratio) - вертикально по центру верха рамки, на переднем плане
                if let winnerImage = ResourceManager.shared.uiImage(named: .winner) {
                    let winnerWidth = geometry.size.width * 0.9
                    let winnerHeight = winnerWidth * (317.0 / 958.0)
                    Image(uiImage: winnerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: winnerWidth, height: winnerHeight)
                        .position(
                            x: geometry.size.width / 2,
                            y: frameTopY
                        )
                }
                
                // Buttons - под рамкой, -50dp margin
                let frameBottomY = frameCenterY + frameHeight / 2
                HStack(spacing: 5) {
                    // Back to menu (29% width, 355:140 ratio)
                    Button(action: {
                        dismiss() // Сначала закрываем WinView
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onBackToMenu() // Потом закрываем GameView и DifficultyView
                        }
                    }) {
                        if let backImage = ResourceManager.shared.uiImage(named: .buttonBackToMenu) {
                            Image(uiImage: backImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.29)
                                .aspectRatio(355.0 / 140.0, contentMode: .fit)
                        }
                    }
                    
                    // Restart (29% width, 355:140 ratio)
                    Button(action: {
                        dismiss()
                        onRestart()
                    }) {
                        if let restartImage = ResourceManager.shared.uiImage(named: .buttonRestart) {
                            Image(uiImage: restartImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.29)
                                .aspectRatio(355.0 / 140.0, contentMode: .fit)
                        }
                    }
                }
                .position(
                    x: geometry.size.width / 2,
                    y: frameBottomY - 50
                )
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            bestScore = StatisticsManager.shared.getHighScore(modelContext: modelContext)
            StatisticsManager.shared.saveGameStatistics(
                modelContext: modelContext,
                score: score,
                level: level,
                isWin: true
            )
        }
    }
}

