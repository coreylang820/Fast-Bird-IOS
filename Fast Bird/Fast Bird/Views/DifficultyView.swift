//
//  DifficultyView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI

struct DifficultyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let bgImage = ResourceManager.shared.uiImage(named: .selectLvlBg) {
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
                    Spacer()
                    
                    // Select level image (above frame)
                    if let selectImage = ResourceManager.shared.uiImage(named: .selectLvl) {
                        let imageWidth = geometry.size.width * 0.86
                        let imageHeight = imageWidth * (608.0 / 822.0)
                        Image(uiImage: selectImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .offset(y: -40)
                    }
                    
                    // Frame with levels (86% width)
                    let frameWidth = geometry.size.width * 0.86
                    let frameHeight = frameWidth * (811.0 / 891.0)
                    
                    ZStack {
                        // Frame background
                        if let frameImage = ResourceManager.shared.uiImage(named: .frameSquare) {
                            Image(uiImage: frameImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameHeight)
                        }
                        
                        // Buttons inside frame - ограничены размерами рамки
                        VStack(spacing: 20) {
                            Spacer()
                            
                            // Hard button (увеличено, 1126:446 ratio)
                            Button(action: {
                                selectedLevel = 3
                            }) {
                                if let hardImage = ResourceManager.shared.uiImage(named: .hard) {
                                    Image(uiImage: hardImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: frameWidth * 0.95)
                                        .aspectRatio(1126.0 / 446.0, contentMode: .fit)
                                }
                            }
                            
                            // Medium button
                            Button(action: {
                                selectedLevel = 2
                            }) {
                                if let mediumImage = ResourceManager.shared.uiImage(named: .medium) {
                                    Image(uiImage: mediumImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: frameWidth * 0.95)
                                        .aspectRatio(1126.0 / 446.0, contentMode: .fit)
                                }
                            }
                            
                            // Easy button
                            Button(action: {
                                selectedLevel = 1
                            }) {
                                if let easyImage = ResourceManager.shared.uiImage(named: .easy) {
                                    Image(uiImage: easyImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: frameWidth * 0.95)
                                        .aspectRatio(1126.0 / 446.0, contentMode: .fit)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 50)
                        .padding(.horizontal, 20)
                        .frame(width: frameWidth, height: frameHeight)
                        .clipped()
                    }
                    .frame(width: frameWidth, height: frameHeight)
                    
                    // Back button (37% width, 425:168 ratio, 17dp margin)
                    Button(action: {
                        dismiss()
                    }) {
                        if let backImage = ResourceManager.shared.uiImage(named: .btnBack) {
                            Image(uiImage: backImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.37)
                        }
                    }
                    .padding(.top, 17)
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.all)
        .fullScreenCover(item: $selectedLevel) { level in
            GameView(level: level, onGameDismiss: {
                // Закрываем DifficultyView при возврате из игры
                dismiss()
            })
        }
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}

