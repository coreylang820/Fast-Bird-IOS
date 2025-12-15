//
//  GameView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: GameViewModel
    @State private var showWinView = false
    @State private var showLoseView = false
    @State private var birdBaseY: CGFloat = 0
    
    let level: Int
    let onGameDismiss: (() -> Void)?
    
    init(level: Int, onGameDismiss: (() -> Void)? = nil) {
        self.level = level
        self.onGameDismiss = onGameDismiss
        _viewModel = StateObject(wrappedValue: GameViewModel(level: level))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let bgImage = ResourceManager.shared.uiImage(named: .gameBackground) {
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
                
                // Pause button (45dp, 23dp left, 47dp top)
                Button(action: {
                    viewModel.togglePause()
                }) {
                    if let pauseImage = ResourceManager.shared.uiImage(named: .btnPause) {
                        Image(uiImage: pauseImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                    }
                }
                .position(
                    x: 23 + 45 / 2,
                    y: max(geometry.safeAreaInsets.top, 44) + 47 + 45 / 2
                )
                
                // Score display (40% width, 499:294 ratio) - по центру экрана, вертикально по середине кнопки пауза
                let pauseButtonCenterY = max(geometry.safeAreaInsets.top, 44) + 47 + 45 / 2
                let scoreBgWidth = geometry.size.width * 0.4
                let scoreBgHeight = scoreBgWidth * (294.0 / 499.0)
                
                // Рамка с количеством очков
                ZStack {
                    if let scoreBg = ResourceManager.shared.uiImage(named: .scoreBg) {
                        Image(uiImage: scoreBg)
                            .resizable()
                            .scaledToFit()
                            .frame(width: scoreBgWidth)
                    }
                    
                    Text("\(viewModel.score)")
                        .font(.custom("Bungee-Regular", size: 40))
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: "0153B6"), radius: 8, x: 3, y: 8)
                }
                .position(
                    x: geometry.size.width / 2,
                    y: pauseButtonCenterY
                )
                
                // Текст "SCORE" под рамкой
                Text("SCORE")
                    .font(.custom("Bungee-Regular", size: 20))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .shadow(color: Color(hex: "0153B6"), radius: 6, x: 5, y: 5)
                    .position(
                        x: geometry.size.width / 2,
                        y: pauseButtonCenterY + scoreBgHeight / 2 + 10
                    )
                
                // Lives (left side, below pause button)
                let pauseButtonBottomY = max(geometry.safeAreaInsets.top, 44) + 47 + 45
                let visibleLivesCount = viewModel.livesVisible.filter { $0 }.count
                let livesHeight = CGFloat(visibleLivesCount) * 45.0 + CGFloat(max(0, visibleLivesCount - 1)) * 8.0
                VStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        if viewModel.livesVisible[index] {
                            if let heartImage = ResourceManager.shared.uiImage(named: .heart) {
                                Image(uiImage: heartImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                            }
                        }
                    }
                }
                .position(
                    x: 23 + 45 / 2,
                    y: pauseButtonBottomY + 8 + livesHeight / 2
                )
                
                // Bird (24% width, 405:444 ratio, 10% from bottom)
                if let birdImage = ResourceManager.shared.uiImage(named: .gameBird) {
                    Image(uiImage: birdImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.24)
                        .position(viewModel.birdPosition)
                        .opacity(viewModel.isBirdBlinking ? 0.3 : 1.0)
                }
                
                // Fox (24% width, 405:444 ratio)
                if let foxImage = ResourceManager.shared.uiImage(named: .gameFox) {
                    Image(uiImage: foxImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.24)
                        .scaleEffect(x: viewModel.foxScaleX, y: 1.0)
                        .position(viewModel.foxPosition)
                        .opacity(viewModel.foxAlpha)
                }
            }
        }
        .ignoresSafeArea(.all)
        .onTapGesture {
            if viewModel.gameState == .playing && !viewModel.isPaused {
                viewModel.jumpBird()
            }
        }
        .onAppear {
            // Initialize game
            DispatchQueue.main.async {
                let screenHeight = UIScreen.main.bounds.height
                // Курица на 10% от низа экрана (90% высоты)
                birdBaseY = screenHeight * 0.9
                viewModel.initializeGame(
                    screenWidth: UIScreen.main.bounds.width,
                    screenHeight: screenHeight,
                    birdBaseY: birdBaseY
                )
                viewModel.onGameWin = { score, level in
                    showWinView = true
                }
                viewModel.onGameLose = { score, level in
                    showLoseView = true
                }
                viewModel.startGame()
            }
        }
        .fullScreenCover(isPresented: $showWinView) {
            WinView(
                score: viewModel.score,
                level: level,
                onBackToMenu: {
                    // Закрываем WinView, затем GameView и DifficultyView, чтобы вернуться в главное меню
                    dismiss() // Закрываем GameView
                    onGameDismiss?() // Закрываем DifficultyView
                },
                onRestart: {
                    // Перезапуск игры на том же уровне
                    viewModel.restartGame()
                }
            )
        }
        .fullScreenCover(isPresented: $showLoseView) {
            LoseView(
                score: viewModel.score,
                level: level,
                onBackToMenu: {
                    dismiss() // Закрываем GameView
                    onGameDismiss?() // Закрываем DifficultyView
                },
                onRestart: {
                    // Перезапуск игры на том же уровне
                    viewModel.restartGame()
                }
            )
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

