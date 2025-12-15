//
//  ResourceManager.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import AVFoundation
import ImageIO

class ResourceManager {
    static let shared = ResourceManager()
    
    // Image names for Fast Bird
    enum ImageName: String {
        case mmBg = "mm_bg"
        case happyHen = "happy_hen"
        case fastBird = "fast_bird"
        case fire = "fire"
        case btnPlay = "btn_play"
        case btnSettings = "btn_settings"
        case btnStat = "btn_stat"
        case btnExit = "btn_exit"
        case btnPrivacy = "btn_privacy"
        case btnPrivacySquare = "btn_privacy_square"
        case btnBack = "btn_back"
        case btnPause = "btn_pause"
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        case selectLvl = "select_lvl"
        case selectLvlBg = "select_lvl_bg"
        case gameBackground = "game_background"
        case gameBird = "game_bird"
        case gameFox = "game_fox"
        case winner = "winner"
        case winnerBackground = "winner_background"
        case winnerBird = "winner_bird"
        case loseBird = "lose_bird"
        case loseFox = "lose_fox"
        case loserBg = "loser_bg"
        case settings = "settings"
        case thumbOn = "thumb_on"
        case thumbOff = "thumb_off"
        case statBg = "stat_bg"
        case statTop = "stat_top"
        case statistics = "statistics"
        case loadBg = "load_bg"
        case loadBird = "load_bird"
        case loading = "loading"
        case buttonBackToMenu = "button_back_to_menu"
        case buttonRestart = "button_restart"
        case arrowBack = "arrow_back"
        case scoreBg = "score_bg"
        case heart = "heart"
        case frameSquare = "frame_square"
        case ppFrame = "pp_frame"
        case gradient = "gradient"
        case bonusesBg = "bonuses_bg"
        case btnApprove = "btn_approve"
        case btnBackWidth = "btn_back_width"
        case fox = "fox"
        case shesternya = "shesternya"
        case tryNow = "try_now"
    }
    
    func image(named name: ImageName) -> Image? {
        if let uiImage = uiImage(named: name) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    func uiImage(named name: ImageName) -> UIImage? {
        // First try to load from Assets (if added to Assets.xcassets)
        if let image = UIImage(named: name.rawValue) {
            return image
        }
        
        // Try to load WebP from Bundle Resources using ImageIO (iOS 14+)
        if let webpImage = loadWebPImage(named: name.rawValue) {
            return webpImage
        }
        
        // Try PNG
        if let path = Bundle.main.path(forResource: name.rawValue, ofType: "png", inDirectory: "Resources/Images") {
            if let data = NSData(contentsOfFile: path) {
                return UIImage(data: data as Data)
            }
        }
        
        // Try direct path - PNG
        if let path = Bundle.main.path(forResource: name.rawValue, ofType: "png") {
            if let data = NSData(contentsOfFile: path) {
                return UIImage(data: data as Data)
            }
        }
        
        return nil
    }
    
    /// Загружает WebP изображение используя ImageIO framework (поддерживается с iOS 14+)
    private func loadWebPImage(named name: String) -> UIImage? {
        // Пробуем разные пути
        let paths = [
            Bundle.main.path(forResource: name, ofType: "webp", inDirectory: "Resources/Images"),
            Bundle.main.path(forResource: name, ofType: "webp")
        ]
        
        for path in paths.compactMap({ $0 }) {
            let url = URL(fileURLWithPath: path) as CFURL
            
            // Используем ImageIO для загрузки WebP
            guard let imageSource = CGImageSourceCreateWithURL(url, nil) else { continue }
            
            // Проверяем тип изображения
            if let type = CGImageSourceGetType(imageSource) {
                let typeString = type as String
                // WebP поддерживается с iOS 14+
                if typeString.contains("webp") || typeString == "public.webp" {
                    // Создаем изображение из источника
                    let options: [CFString: Any] = [
                        kCGImageSourceShouldCache: true,
                        kCGImageSourceShouldAllowFloat: false
                    ]
                    
                    if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) {
                        return UIImage(cgImage: cgImage)
                    }
                }
            }
            
            // Fallback: пробуем обычный способ загрузки (может работать на iOS 14+)
            if let data = NSData(contentsOfFile: path) {
                if let image = UIImage(data: data as Data) {
                    return image
                }
            }
        }
        
        return nil
    }
    
    // Sound
    var musicURL: URL? {
        // Try different paths
        if let url = Bundle.main.url(forResource: "main_music", withExtension: "mp3", subdirectory: "Resources/Sounds") {
            return url
        }
        return Bundle.main.url(forResource: "main_music", withExtension: "mp3")
    }
}

