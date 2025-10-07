//
//  HomeView.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var achievements = AchievementsManager.shared
    @State private var quickCategory: QuizCategory = .mixed
    @State private var quickDifficulty: QuizDifficulty = .medium

    var body: some View {
        NavigationView {
            ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    LinearGradient(colors: [Color.accentColor.opacity(0.15), Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 120)
                        .cornerRadius(16)
                    HStack(spacing: 12) {
                        Image(systemName: "books.vertical.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.accentColor)
                        VStack(alignment: .leading) {
                            Text("Добро пожаловать в ЛитКвиз")
                                .font(.system(size: 20, weight: .bold))
                            Text("Проверьте знания авторов, книг и цитат")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .multilineTextAlignment(.center)

                // Last result card
                if let last = achievements.lastResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Последний результат")
                            .font(.system(.headline, design: .default))
                        Text("\(last.score) из \(last.total)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Категория: \(last.category.rawValue)")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }

                // Daily goal
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Сегодняшняя цель")
                            .font(.headline)
                        Spacer()
                        Image(systemName: achievements.dailyGoalDone ? "checkmark.seal.fill" : "seal")
                            .foregroundColor(achievements.dailyGoalDone ? .green : .secondary)
                    }
                    Text(achievements.dailyGoalDone ? "Цель выполнена — +1 квиз" : "Пройдите 1 квиз сегодня")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                // Tips & shortcuts (useful content instead of themes)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Подсказки")
                        .font(.system(.headline, design: .default))
                    VStack(spacing: 8) {
                        tipRow(icon: "questionmark.circle", text: "Попробуйте смешанный квиз, чтобы охватить больше тем")
                        tipRow(icon: "rosette", text: "Зарабатывайте бэджи, набирая 80% и выше")
                        tipRow(icon: "bell", text: "Включите ежедневное напоминание в Настройках")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }

                Spacer()
            }
            .padding()
            }
            .navigationTitle("Главная")
        }
    }
}

// MARK: - Private helpers
private func themeCard(title: String, symbol: String) -> some View {
    VStack(spacing: 8) {
        Image(systemName: symbol)
            .font(.system(size: 28))
            .foregroundColor(.accentColor)
            .frame(width: 56, height: 56)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        Text(title)
            .font(.footnote)
            .foregroundColor(.primary)
    }
    .frame(width: 96)
}

private func tipRow(icon: String, text: String) -> some View {
    HStack(spacing: 10) {
        Image(systemName: icon)
            .foregroundColor(.accentColor)
        Text(text)
            .foregroundColor(.primary)
        Spacer()
    }
}

#Preview {
    HomeView()
}


