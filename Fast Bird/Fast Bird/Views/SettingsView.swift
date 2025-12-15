//
//  SettingsView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var settings = SettingsManager.shared
    @StateObject private var musicPlayer = MusicPlayer.shared
    @State private var showPrivacy = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let bgImage = ResourceManager.shared.uiImage(named: .gradient) {
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
                    
                    // Settings title (55% width, 591:196 ratio) - строго над рамкой
                    if let settingsImage = ResourceManager.shared.uiImage(named: .settings) {
                        Image(uiImage: settingsImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.55)
                            .padding(.bottom, 10) // Небольшой отступ от рамки
                    }
                    
                    // Frame (85% width, 891:811 ratio)
                    ZStack {
                        if let frameImage = ResourceManager.shared.uiImage(named: .frameSquare) {
                            Image(uiImage: frameImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.85)
                                .aspectRatio(891.0 / 811.0, contentMode: .fit)
                        }
                        
                        // Sound и Vibro по центру рамки
                        VStack(spacing: 40) {
                            Spacer()
                            
                            // Sound toggle
                            HStack(spacing: 16) {
                                Spacer()
                                
                                Text("SOUND")
                                    .font(.custom("Bungee-Regular", size: 20))
                                    .foregroundColor(.white)
                                    .shadow(color: .blue, radius: 6, x: 5, y: 3)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Button(action: {
                                        settings.soundEnabled = true
                                        musicPlayer.startBackgroundMusic()
                                    }) {
                                        if let thumbOn = ResourceManager.shared.uiImage(named: .thumbOn) {
                                            Image(uiImage: thumbOn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geometry.size.width * 0.09)
                                                .opacity(settings.soundEnabled ? 1 : 0.5)
                                        }
                                    }
                                    
                                    Button(action: {
                                        settings.soundEnabled = false
                                        musicPlayer.stopBackgroundMusic()
                                    }) {
                                        if let thumbOff = ResourceManager.shared.uiImage(named: .thumbOff) {
                                            Image(uiImage: thumbOff)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geometry.size.width * 0.09)
                                                .opacity(settings.soundEnabled ? 0.5 : 1)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 40)
                            
                            // Vibration toggle
                            HStack(spacing: 16) {
                                Spacer()
                                
                                Text("VIBRO")
                                    .font(.custom("Bungee-Regular", size: 20))
                                    .foregroundColor(.white)
                                    .shadow(color: .blue, radius: 6, x: 5, y: 3)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Button(action: {
                                        settings.vibrationEnabled = true
                                    }) {
                                        if let thumbOn = ResourceManager.shared.uiImage(named: .thumbOn) {
                                            Image(uiImage: thumbOn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geometry.size.width * 0.09)
                                                .opacity(settings.vibrationEnabled ? 1 : 0.5)
                                        }
                                    }
                                    
                                    Button(action: {
                                        settings.vibrationEnabled = false
                                    }) {
                                        if let thumbOff = ResourceManager.shared.uiImage(named: .thumbOff) {
                                            Image(uiImage: thumbOff)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geometry.size.width * 0.09)
                                                .opacity(settings.vibrationEnabled ? 0.5 : 1)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .frame(width: geometry.size.width * 0.85)
                        .frame(height: geometry.size.width * 0.85 * (811.0 / 891.0))
                    }
                    
                    // Bottom buttons - сразу под рамкой
                    HStack(spacing: 8) {
                        // Privacy button (35% width, 375:148 ratio)
                        Button(action: {
                            showPrivacy = true
                        }) {
                            if let privacyImage = ResourceManager.shared.uiImage(named: .btnPrivacy) {
                                Image(uiImage: privacyImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.35)
                                    .aspectRatio(375.0 / 148.0, contentMode: .fit)
                            }
                        }
                        
                        // Exit button (35% width, 375:148 ratio)
                        Button(action: {
                            dismiss()
                        }) {
                            if let exitImage = ResourceManager.shared.uiImage(named: .btnExit) {
                                Image(uiImage: exitImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.35)
                                    .aspectRatio(375.0 / 148.0, contentMode: .fit)
                            }
                        }
                    }
                    .padding(.top, 10) // Небольшой отступ от рамки
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showPrivacy) {
            PrivacyView(mode: .view, onAccept: {
                showPrivacy = false
            }, onBack: {
                showPrivacy = false
            })
        }
    }
}

