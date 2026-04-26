//
//  StorageManager.swift
//  HealthTracker
//
//  Created by David Emery on 4/26/26.
//

import Foundation
import Combine

class StorageManager{
    static let shared = StorageManager()
    private init() {}
    
    //Mark: - Keys
    private enum Keys{
        static let diaryEntries = "diary_entries"
        static let userGoals = "user_goals"
    }
    
    // MARK: - private props
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Functions
    func saveEntries(_ entries: [DiaryEntry]){
        if let encodedDiaryEntries = try? encoder.encode(entries){
            defaults.set(encodedDiaryEntries, forKey: Keys.diaryEntries)
        }
    }
    
    func loadEntries() -> [DiaryEntry]{
        guard let encodedDiaryEntries = defaults.data(forKey: Keys.diaryEntries),
              let diaryEntries = try? decoder.decode([DiaryEntry].self, from: encodedDiaryEntries) else {
            return []
        }
        return diaryEntries
    }
    
    func addEntry(_ entry: DiaryEntry){
        var entries = loadEntries()
        entries.append(entry)
        saveEntries(entries)
    }
}
