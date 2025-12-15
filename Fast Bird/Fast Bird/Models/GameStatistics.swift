//
//  GameStatistics.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import Foundation
import SwiftData

@Model
final class GameStatistics {
    var id: UUID
    var score: Int
    var level: Int
    var isWin: Bool
    var date: Date
    var timestamp: TimeInterval
    
    init(score: Int, level: Int, isWin: Bool, date: Date = Date(), timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.id = UUID()
        self.score = score
        self.level = level
        self.isWin = isWin
        self.date = date
        self.timestamp = timestamp
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

