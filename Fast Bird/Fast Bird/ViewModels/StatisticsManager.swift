//
//  StatisticsManager.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import Foundation
import SwiftData

class StatisticsManager {
    static let shared = StatisticsManager()
    
    private init() {}
    
    func saveGameStatistics(modelContext: ModelContext, score: Int, level: Int, isWin: Bool) {
        let statistics = GameStatistics(score: score, level: level, isWin: isWin)
        modelContext.insert(statistics)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving statistics: \(error)")
        }
    }
    
    func getStatisticsList(modelContext: ModelContext) -> [GameStatistics] {
        let descriptor = FetchDescriptor<GameStatistics>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching statistics: \(error)")
            return []
        }
    }
    
    func getHighScore(modelContext: ModelContext) -> Int {
        let statistics = getStatisticsList(modelContext: modelContext)
        return statistics.map { $0.score }.max() ?? 0
    }
    
    func getWinRate(modelContext: ModelContext) -> Int {
        let statistics = getStatisticsList(modelContext: modelContext)
        guard !statistics.isEmpty else { return 0 }
        
        let wins = statistics.filter { $0.isWin }.count
        return Int((Double(wins) / Double(statistics.count)) * 100)
    }
    
    func getAverageScore(modelContext: ModelContext) -> Int {
        let statistics = getStatisticsList(modelContext: modelContext)
        guard !statistics.isEmpty else { return 0 }
        
        let totalScore = statistics.reduce(0) { $0 + $1.score }
        return totalScore / statistics.count
    }
    
    func getGamesCount(modelContext: ModelContext) -> Int {
        return getStatisticsList(modelContext: modelContext).count
    }
}

