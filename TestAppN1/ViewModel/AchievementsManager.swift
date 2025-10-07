//
//  AchievementsManager.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import Foundation

final class AchievementsManager: ObservableObject {
    static let shared = AchievementsManager()

    @Published private(set) var unlocked: Set<AchievementID>
    @Published private(set) var streakCount: Int
    @Published private(set) var lastResult: QuizResultSummary?
    @Published private(set) var dailyGoalDone: Bool

    private init() {
        let saved = UserDefaults.standard.array(forKey: "achievements_unlocked") as? [String] ?? []
        unlocked = Set(saved.compactMap { AchievementID(rawValue: $0) })
        streakCount = UserDefaults.standard.integer(forKey: "achievements_streak")
        if let data = UserDefaults.standard.data(forKey: "achievements_last_result"),
           let decoded = try? JSONDecoder().decode(QuizResultSummary.self, from: data) {
            lastResult = decoded
        } else {
            lastResult = nil
        }

        // Daily goal
        let todayKey = Self.todayKey()
        let storedKey = UserDefaults.standard.string(forKey: "daily_goal_key")
        let storedDone = UserDefaults.standard.bool(forKey: "daily_goal_done")
        if storedKey == todayKey {
            dailyGoalDone = storedDone
        } else {
            dailyGoalDone = false
            UserDefaults.standard.set(todayKey, forKey: "daily_goal_key")
            UserDefaults.standard.set(false, forKey: "daily_goal_done")
        }
    }

    func evaluateAndUnlock(for result: QuizResultSummary) {
        let percent = result.total > 0 ? Double(result.score) / Double(result.total) : 0

        unlock(.firstQuiz)

        if percent >= 0.8 { unlock(.score80) }
        if result.score == result.total && result.total > 0 { unlock(.fullScore) }

        if percent >= 0.6 { streakCount += 1 } else { streakCount = 0 }
        if streakCount >= 5 { unlock(.streak5) }
        UserDefaults.standard.set(streakCount, forKey: "achievements_streak")

        if result.category == .authors && percent >= 0.8 { unlock(.authorMaster) }

        saveLastResult(result)
        markDailyGoalCompleted()
    }

    private func unlock(_ id: AchievementID) {
        guard !unlocked.contains(id) else { return }
        unlocked.insert(id)
        let arr = unlocked.map { $0.rawValue }
        UserDefaults.standard.set(arr, forKey: "achievements_unlocked")
        objectWillChange.send()
    }

    private func saveLastResult(_ result: QuizResultSummary) {
        lastResult = result
        if let data = try? JSONEncoder().encode(result) {
            UserDefaults.standard.set(data, forKey: "achievements_last_result")
        }
    }

    private func markDailyGoalCompleted() {
        let todayKey = Self.todayKey()
        dailyGoalDone = true
        UserDefaults.standard.set(todayKey, forKey: "daily_goal_key")
        UserDefaults.standard.set(true, forKey: "daily_goal_done")
    }

    private static func todayKey() -> String {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }

    // Public reset API for Settings
    func resetAll() {
        unlocked.removeAll()
        streakCount = 0
        lastResult = nil
        let todayKey = Self.todayKey()
        dailyGoalDone = false

        UserDefaults.standard.removeObject(forKey: "achievements_unlocked")
        UserDefaults.standard.set(0, forKey: "achievements_streak")
        UserDefaults.standard.removeObject(forKey: "achievements_last_result")
        UserDefaults.standard.set(todayKey, forKey: "daily_goal_key")
        UserDefaults.standard.set(false, forKey: "daily_goal_done")

        objectWillChange.send()
    }
}


