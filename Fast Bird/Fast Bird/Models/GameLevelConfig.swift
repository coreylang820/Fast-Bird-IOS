//
//  GameLevelConfig.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import Foundation

struct GameLevelConfig {
    let lives: Int
    let scorePerDodge: Int
    let durationSeconds: TimeInterval
    
    static func forLevel(_ level: Int) -> GameLevelConfig {
        switch level {
        case 1:
            return GameLevelConfig(lives: 3, scorePerDodge: 10, durationSeconds: 30.0)
        case 2:
            return GameLevelConfig(lives: 2, scorePerDodge: 15, durationSeconds: 46.0)
        case 3:
            return GameLevelConfig(lives: 1, scorePerDodge: 20, durationSeconds: 60.0)
        default:
            return GameLevelConfig(lives: 3, scorePerDodge: 10, durationSeconds: 30.0)
        }
    }
}

