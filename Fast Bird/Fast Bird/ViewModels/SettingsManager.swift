//
//  SettingsManager.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "sound_enabled")
        }
    }
    
    @Published var vibrationEnabled: Bool {
        didSet {
            UserDefaults.standard.set(vibrationEnabled, forKey: "vibration_enabled")
        }
    }
    
    @Published var isPrivacyAccepted: Bool {
        didSet {
            UserDefaults.standard.set(isPrivacyAccepted, forKey: "isPrivacyAccepted")
        }
    }
    
    private init() {
        self.soundEnabled = UserDefaults.standard.object(forKey: "sound_enabled") as? Bool ?? true
        self.vibrationEnabled = UserDefaults.standard.object(forKey: "vibration_enabled") as? Bool ?? true
        self.isPrivacyAccepted = UserDefaults.standard.bool(forKey: "isPrivacyAccepted")
    }
}

