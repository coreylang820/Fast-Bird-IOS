//
//  GameViewModel.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var remainingTime: TimeInterval = 0
    @Published var gameState: GameState = .notStarted
    @Published var isPaused: Bool = false
    @Published var birdPosition: CGPoint = .zero
    @Published var foxPosition: CGPoint = .zero
    @Published var foxAlpha: Double = 0
    @Published var foxScaleX: CGFloat = 1
    @Published var isFoxActive: Bool = false
    @Published var isBirdJumping: Bool = false
    @Published var isBirdFalling: Bool = false
    @Published var isBirdBlinking: Bool = false
    @Published var livesVisible: [Bool] = [true, true, true]
    
    private var level: Int = 1
    private var levelConfig: GameLevelConfig!
    private var birdBaseY: CGFloat = 0
    private var hasCollisionOccurred: Bool = false
    private var pointsAwarded: Bool = false
    private var gameTimer: Timer?
    private var foxSpawnTimer: Timer?
    private var foxMoveTimer: Timer?
    private var birdJumpTimer: Timer?
    private var foxStartX: CGFloat = 0
    private var foxEndX: CGFloat = 0
    private var foxMoveStartTime: Date?
    private var foxMoveDuration: TimeInterval = 5.0
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    var onGameWin: ((Int, Int) -> Void)?
    var onGameLose: ((Int, Int) -> Void)?
    
    init(level: Int) {
        self.level = level
        self.levelConfig = GameLevelConfig.forLevel(level)
        self.lives = levelConfig.lives
        self.remainingTime = levelConfig.durationSeconds
        updateLivesDisplay()
    }
    
    func initializeGame(screenWidth: CGFloat, screenHeight: CGFloat, birdBaseY: CGFloat) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.birdBaseY = birdBaseY
        self.birdPosition = CGPoint(x: screenWidth / 2, y: birdBaseY)
        
        // Hide fox initially
        self.foxPosition = CGPoint(x: -100, y: birdBaseY)
        self.foxAlpha = 0
    }
    
    func startGame() {
        guard gameState == .notStarted else { return }
        
        gameState = .playing
        isPaused = false
        
        startGameTimer()
        startFoxSpawning()
    }
    
    func restartGame() {
        cleanup()
        gameState = .notStarted
        score = 0
        lives = levelConfig.lives
        remainingTime = levelConfig.durationSeconds
        hasCollisionOccurred = false
        pointsAwarded = false
        isFoxActive = false
        foxAlpha = 0
        isBirdJumping = false
        isBirdFalling = false
        updateLivesDisplay()
        birdPosition = CGPoint(x: screenWidth / 2, y: birdBaseY)
        foxPosition = CGPoint(x: -100, y: birdBaseY)
        startGame()
    }
    
    func jumpBird() {
        guard gameState == .playing && !isPaused && !isBirdJumping else { return }
        
        isBirdJumping = true
        isBirdFalling = false
        
        let jumpHeight = screenHeight * 0.35
        let currentY = birdPosition.y
        let targetY = currentY - jumpHeight
        
        // Jump up animation
        let jumpUpDuration: TimeInterval = 0.3
        let startTime = Date()
        
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / jumpUpDuration, 1.0)
            
            // Ease in-out interpolation
            let easedProgress = progress < 0.5
                ? 2 * progress * progress
                : 1 - pow(-2 * progress + 2, 2) / 2
            
            let newY = currentY - (jumpHeight * CGFloat(easedProgress))
            self.birdPosition = CGPoint(x: self.birdPosition.x, y: newY)
            
            if progress >= 1.0 {
                timer.invalidate()
                self.isBirdFalling = true
                self.startBirdFall(targetY: targetY, startY: currentY)
            }
        }
        
        // Check collision during jump
        checkCollision()
    }
    
    private func startBirdFall(targetY: CGFloat, startY: CGFloat) {
        let fallDuration: TimeInterval = 1.0
        let startTime = Date()
        
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / fallDuration, 1.0)
            
            // Ease in-out interpolation
            let easedProgress = progress < 0.5
                ? 2 * progress * progress
                : 1 - pow(-2 * progress + 2, 2) / 2
            
            let newY = targetY + (self.birdBaseY - targetY) * CGFloat(easedProgress)
            self.birdPosition = CGPoint(x: self.birdPosition.x, y: newY)
            
            // Check collision during fall
            self.checkCollision()
            
            if progress >= 1.0 {
                timer.invalidate()
                self.isBirdJumping = false
                self.isBirdFalling = false
                self.birdPosition = CGPoint(x: self.birdPosition.x, y: self.birdBaseY)
            }
        }
    }
    
    private func startGameTimer() {
        gameTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self, self.gameState == .playing && !self.isPaused else {
                timer.invalidate()
                return
            }
            
            self.remainingTime -= 0.1
            
            if self.remainingTime <= 0 {
                self.remainingTime = 0
                timer.invalidate()
                if self.lives > 0 {
                    self.endGameWin()
                }
            }
        }
    }
    
    private func startFoxSpawning() {
        foxSpawnTimer?.invalidate()
        
        // Initial delay before first spawn
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.spawnFox()
            self?.scheduleNextFoxSpawn()
        }
    }
    
    private func scheduleNextFoxSpawn() {
        guard gameState == .playing && !isPaused else { return }
        
        let delay = Double.random(in: 1.5...3.0)
        foxSpawnTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            guard let self = self, self.gameState == .playing && !self.isPaused else { return }
            if !self.isFoxActive {
                self.spawnFox()
            }
            self.scheduleNextFoxSpawn()
        }
    }
    
    private func spawnFox() {
        guard !isFoxActive && gameState == .playing && !isPaused else { return }
        
        isFoxActive = true
        hasCollisionOccurred = false
        pointsAwarded = false
        
        // Random side (true = from right, false = from left)
        let fromRight = Bool.random()
        
        let foxWidth: CGFloat = 100 // Approximate fox width
        foxStartX = fromRight ? screenWidth : -foxWidth
        foxEndX = fromRight ? -foxWidth : screenWidth
        
        foxPosition = CGPoint(x: foxStartX, y: birdBaseY)
        foxAlpha = 1.0
        foxScaleX = fromRight ? -1 : 1
        
        // Start fox movement
        foxMoveStartTime = Date()
        foxMoveDuration = 5.0
        
        foxMoveTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] timer in
            guard let self = self, self.gameState == .playing && !self.isPaused else {
                timer.invalidate()
                return
            }
            
            guard let startTime = self.foxMoveStartTime else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / self.foxMoveDuration, 1.0)
            
            // Ease in-out interpolation
            let easedProgress = progress < 0.5
                ? 2 * progress * progress
                : 1 - pow(-2 * progress + 2, 2) / 2
            
            let newX = self.foxStartX + (self.foxEndX - self.foxStartX) * CGFloat(easedProgress)
            self.foxPosition = CGPoint(x: newX, y: self.birdBaseY)
            
            // Check collision
            if !self.hasCollisionOccurred {
                self.checkCollision()
            }
            
            if progress >= 1.0 {
                timer.invalidate()
                if self.gameState == .playing {
                    self.isFoxActive = false
                    self.foxAlpha = 0
                    self.foxMoveTimer = nil
                }
            }
        }
    }
    
    private func checkCollision() {
        guard isFoxActive && gameState == .playing && !isPaused && !hasCollisionOccurred else { return }
        
        // Collision detection with expanded bird rect
        let birdRect = CGRect(
            x: birdPosition.x - 30,
            y: birdPosition.y - 30,
            width: 60,
            height: 60
        )
        
        let foxRect = CGRect(
            x: foxPosition.x - 50,
            y: foxPosition.y - 50,
            width: 100,
            height: 100
        )
        
        if birdRect.intersects(foxRect) {
            // If collision happens during bird falling - successful dodge
            if isBirdFalling {
                handleSuccessfulDodgeFromCollision()
            } else {
                handleCollision()
            }
        }
    }
    
    private func handleSuccessfulDodgeFromCollision() {
        guard !hasCollisionOccurred && !pointsAwarded else { return }
        
        hasCollisionOccurred = true
        pointsAwarded = true
        
        // Award points for successful dodge
        score += levelConfig.scorePerDodge
        
        // Stop fox animation
        foxMoveTimer?.invalidate()
        foxMoveTimer = nil
        isFoxActive = false
        foxAlpha = 0
    }
    
    private func handleCollision() {
        guard gameState == .playing && !isPaused && !hasCollisionOccurred else { return }
        
        hasCollisionOccurred = true
        isFoxActive = false
        foxMoveTimer?.invalidate()
        foxMoveTimer = nil
        foxAlpha = 0
        
        // Vibration
        if SettingsManager.shared.vibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        lives -= 1
        updateLivesDisplay()
        
        // Animate heart fall
        if lives >= 0 && lives < livesVisible.count {
            animateHeartFall(index: lives)
        }
        
        // Animate bird blink
        animateBirdBlink()
        
        // Check game over
        if lives <= 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.endGameLose()
            }
        }
    }
    
    func updateLivesDisplay() {
        for i in 0..<livesVisible.count {
            livesVisible[i] = i < lives
        }
    }
    
    private func animateHeartFall(index: Int) {
        // Animation handled in view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if index < self.livesVisible.count {
                self.livesVisible[index] = false
            }
        }
    }
    
    private func animateBirdBlink() {
        isBirdBlinking = true
        
        // Blink animation: 3 blinks over 1 second
        var blinkCount = 0
        let totalBlinks = 3
        let blinkDuration: TimeInterval = 1.0 / Double(totalBlinks * 2) // Each blink is on/off
        
        Timer.scheduledTimer(withTimeInterval: blinkDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            blinkCount += 1
            self.isBirdBlinking = (blinkCount % 2 == 1) // Alternate between visible and invisible
            
            if blinkCount >= totalBlinks * 2 {
                timer.invalidate()
                self.isBirdBlinking = false
            }
        }
    }
    
    func togglePause() {
        guard gameState == .playing else { return }
        
        isPaused.toggle()
        
        if isPaused {
            gameTimer?.invalidate()
            foxMoveTimer?.invalidate()
            foxSpawnTimer?.invalidate()
            birdJumpTimer?.invalidate()
        } else {
            startGameTimer()
            startFoxSpawning()
            // Resume fox movement if active
            if isFoxActive {
                spawnFox()
            }
        }
    }
    
    private func endGameWin() {
        guard gameState == .playing else { return }
        
        gameState = .won
        cleanup()
        onGameWin?(score, level)
    }
    
    private func endGameLose() {
        guard gameState == .playing else { return }
        
        gameState = .lost
        cleanup()
        onGameLose?(score, level)
    }
    
    private func cleanup() {
        gameTimer?.invalidate()
        gameTimer = nil
        foxSpawnTimer?.invalidate()
        foxSpawnTimer = nil
        foxMoveTimer?.invalidate()
        foxMoveTimer = nil
        birdJumpTimer?.invalidate()
        birdJumpTimer = nil
    }
    
    deinit {
        cleanup()
    }
}

