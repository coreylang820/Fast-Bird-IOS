//
//  SplashView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI

struct SplashView: View {
    @State private var foxScale: CGFloat = 1.0
    @State private var loadingScale: CGFloat = 1.0
    @State private var animationStarted = false
    
    var onComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let bgImage = ResourceManager.shared.uiImage(named: .loadBg) {
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
                
                // Load bird (27% height, 1:1 ratio, 60% from top)
                if let birdImage = ResourceManager.shared.uiImage(named: .loadBird) {
                    let birdHeight = geometry.size.height * 0.27
                    Image(uiImage: birdImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: birdHeight, height: birdHeight)
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height * 0.4
                        )
                }
                
                // Fast bird (40% height, 1:1 ratio, at 60% guideline)
                if let fastBirdImage = ResourceManager.shared.uiImage(named: .fastBird) {
                    let fastBirdHeight = geometry.size.height * 0.4
                    Image(uiImage: fastBirdImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: fastBirdHeight, height: fastBirdHeight)
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height * 0.6
                        )
                }
                
                // Fox (below 55% guideline, centered)
                if let foxImage = ResourceManager.shared.uiImage(named: .fox) {
                    Image(uiImage: foxImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(foxScale)
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.3)
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height * 0.75
                        )
                }
                
                // Loading text (11% height, 616:205 ratio, 50dp from bottom)
                if let loadingImage = ResourceManager.shared.uiImage(named: .loading) {
                    let loadingHeight = geometry.size.height * 0.11
                    let loadingWidth = loadingHeight * (616.0 / 205.0)
                    Image(uiImage: loadingImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: loadingWidth, height: loadingHeight)
                        .scaleEffect(loadingScale)
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height - loadingHeight / 2 - 50
                        )
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            startAnimations()
            // Navigate after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onComplete()
            }
        }
    }
    
    private func startAnimations() {
        guard !animationStarted else { return }
        animationStarted = true
        
        // Fox pulsing animation
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            foxScale = 1.3
        }
        
        // Loading pulsing animation
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            loadingScale = 1.17
        }
    }
}

