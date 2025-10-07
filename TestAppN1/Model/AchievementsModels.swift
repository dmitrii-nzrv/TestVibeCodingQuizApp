//
//  AchievementsModels.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import Foundation

enum AchievementID: String, CaseIterable, Identifiable {
    case firstQuiz
    case score80
    case fullScore
    case streak5
    case authorMaster
    
    var id: String { rawValue }
}

struct AchievementDefinition: Identifiable {
    let id: AchievementID
    let title: String
    let description: String
}

enum QuizResultCategory: String, Codable {
    case authors, books, quotes, mixed
}

struct QuizResultSummary: Codable {
    let category: QuizResultCategory
    let score: Int
    let total: Int
}

enum AchievementsCatalog {
    static let all: [AchievementDefinition] = [
        .init(id: .firstQuiz, title: "Первый шаг", description: "Завершите первый квиз"),
        .init(id: .score80, title: "Сильный результат", description: "Наберите 80% и выше"),
        .init(id: .fullScore, title: "Идеально", description: "Ответьте правильно на все вопросы"),
        .init(id: .streak5, title: "Серия из 5", description: "5 квизов подряд с результатом 60%+"),
        .init(id: .authorMaster, title: "Знаток авторов", description: "80%+ в категории Авторы")
    ]
}


