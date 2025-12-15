//
//  MusicPlayer.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import AVFoundation
import Combine

class MusicPlayer: ObservableObject {
    static let shared = MusicPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    private var isMusicStarted = false
    
    private init() {}
    
    func startBackgroundMusic() {
        if isMusicStarted && audioPlayer != nil {
            // Music already started, just resume if paused
            if !audioPlayer!.isPlaying {
                audioPlayer!.play()
                isPlaying = true
            }
            return
        }
        
        guard let url = ResourceManager.shared.musicURL else {
            print("Music file not found")
            return
        }
        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.play()
            isPlaying = true
            isMusicStarted = true
        } catch {
            print("Error playing music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        isMusicStarted = false
    }
    
    func pauseBackgroundMusic() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resumeBackgroundMusic() {
        if !audioPlayer!.isPlaying && isMusicStarted {
            audioPlayer?.play()
            isPlaying = true
        }
    }
    
    func release() {
        stopBackgroundMusic()
    }
}

