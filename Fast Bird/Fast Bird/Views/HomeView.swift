//
//  HomeView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject private var musicPlayer = MusicPlayer.shared
    @StateObject private var settings = SettingsManager.shared
    @State private var showDifficulty = false
    @State private var showSettings = false
    @State private var showStatistics = false
    @State private var showPrivacy = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image (centerCrop) - растягиваем на весь экран
                if let bgImage = ResourceManager.shared.uiImage(named: .mmBg) {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea(.all)
                } else {
                    Color(red: 0.2, green: 0.3, blue: 0.5)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea(.all)
                }
                
                // Privacy button (top left, 46dp, 24dp left, 47dp top)
                VStack {
                    HStack {
                        Button(action: {
                            showPrivacy = true
                        }) {
                            if let privacyImage = ResourceManager.shared.uiImage(named: .btnPrivacySquare) {
                                Image(uiImage: privacyImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 46, height: 46)
                            }
                        }
                        .padding(.leading, 24)
                        .padding(.top, max(geometry.safeAreaInsets.top, 44) + 47)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                // Main content - изображения
                VStack(spacing: 0) {
                    // Отступ сверху для основного контента (учитываем статус-бар)
                    Spacer()
                        .frame(height: max(geometry.safeAreaInsets.top, 44) + 20)
                    
                    // Happy hen (70% width, 1:1 ratio, at top)
                    if let henImage = ResourceManager.shared.uiImage(named: .happyHen) {
                        let henSize = geometry.size.width * 0.7
                        Image(uiImage: henImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: henSize, height: henSize)
                    }
                    
                    // Fast bird (30% height, 1:1 ratio, -80dp margin from hen)
                    if let birdImage = ResourceManager.shared.uiImage(named: .fastBird) {
                        let birdSize = geometry.size.height * 0.3
                        Image(uiImage: birdImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: birdSize, height: birdSize)
                            .offset(y: -80)
                    }
                    
                    Spacer()
                }
                
                // Buttons - отдельный слой с фиксированным позиционированием под fast bird
                VStack {
                    Spacer()
                        .frame(height: max(geometry.safeAreaInsets.top, 44) + 20 + geometry.size.width * 0.7 + geometry.size.height * 0.3 - 80 + 10)
                    
                    VStack(spacing: 8) {
                        // Play button (40% width, 551:218 ratio)
                        Button(action: {
                            showDifficulty = true
                        }) {
                            if let playImage = ResourceManager.shared.uiImage(named: .btnPlay) {
                                Image(uiImage: playImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.4)
                                    .aspectRatio(551.0 / 218.0, contentMode: .fit)
                            } else {
                                Text("PLAY")
                                    .font(.custom("Bungee-Regular", size: 32))
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width * 0.4, height: (geometry.size.width * 0.4) * (218.0 / 551.0))
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(PlainButtonStyle())
                        
                        // Settings button (40% width, 551:218 ratio)
                        Button(action: {
                            showSettings = true
                        }) {
                            if let settingsImage = ResourceManager.shared.uiImage(named: .btnSettings) {
                                Image(uiImage: settingsImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.4)
                                    .aspectRatio(551.0 / 218.0, contentMode: .fit)
                            } else {
                                Text("SETTINGS")
                                    .font(.custom("Bungee-Regular", size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width * 0.4, height: (geometry.size.width * 0.4) * (218.0 / 551.0))
                                    .background(Color.gray)
                                    .cornerRadius(15)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(PlainButtonStyle())
                        
                        // Statistics button (40% width, 551:218 ratio)
                        Button(action: {
                            showStatistics = true
                        }) {
                            if let statImage = ResourceManager.shared.uiImage(named: .btnStat) {
                                Image(uiImage: statImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.4)
                                    .aspectRatio(551.0 / 218.0, contentMode: .fit)
                            } else {
                                Text("STATISTICS")
                                    .font(.custom("Bungee-Regular", size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width * 0.4, height: (geometry.size.width * 0.4) * (218.0 / 551.0))
                                    .background(Color.gray)
                                    .cornerRadius(15)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(PlainButtonStyle())
                        
                        // Exit button (30% width, 551:218 ratio)
                        Button(action: {
                            exit(0)
                        }) {
                            if let exitImage = ResourceManager.shared.uiImage(named: .btnExit) {
                                Image(uiImage: exitImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.3)
                                    .aspectRatio(551.0 / 218.0, contentMode: .fit)
                            } else {
                                Text("EXIT")
                                    .font(.custom("Bungee-Regular", size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width * 0.3, height: (geometry.size.width * 0.3) * (218.0 / 551.0))
                                    .background(Color.red)
                                    .cornerRadius(15)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                }
                
                // Fire at bottom (1080:872 ratio) - отдельный слой, но не перекрывает кнопки
                VStack {
                    Spacer()
                    
                    if let fireImage = ResourceManager.shared.uiImage(named: .fire) {
                        Image(uiImage: fireImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.width * (872.0 / 1080.0))
                            .clipped()
                            .allowsHitTesting(false) // Fire не должен перехватывать клики
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            if settings.soundEnabled {
                musicPlayer.startBackgroundMusic()
            }
        }
        .onChange(of: settings.soundEnabled) { oldValue, newValue in
            if newValue {
                musicPlayer.startBackgroundMusic()
            } else {
                musicPlayer.stopBackgroundMusic()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // Пауза музыки при сворачивании приложения
            musicPlayer.pauseBackgroundMusic()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            // Возобновление музыки при возврате в приложение
            if settings.soundEnabled {
                musicPlayer.resumeBackgroundMusic()
            }
        }
        .sheet(isPresented: $showDifficulty) {
            DifficultyView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showStatistics) {
            StatisticsView()
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyView(mode: .view, onAccept: {
                showPrivacy = false
            }, onBack: {
                showPrivacy = false
            })
        }
    }
}

