//
//  QuizModels.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import Foundation

enum QuizCategory: String, CaseIterable, Identifiable {
    case authors = "Авторы"
    case books = "Произведения"
    case quotes = "Цитаты"
    case mixed = "Смешанный"

    var id: String { rawValue }
}

enum QuizDifficulty: String, CaseIterable, Identifiable {
    case easy = "Лёгкий"
    case medium = "Средний"
    case hard = "Сложный"

    var id: String { rawValue }
    var timePerQuestionSeconds: Int {
        switch self {
        case .easy: return 25
        case .medium: return 18
        case .hard: return 12
        }
    }
}

struct QuizQuestion: Identifiable, Equatable {
    let id = UUID()
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let category: QuizCategory
    let difficulty: QuizDifficulty
}



