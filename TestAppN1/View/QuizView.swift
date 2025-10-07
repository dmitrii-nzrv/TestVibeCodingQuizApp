//
//  QuizView.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var showStart: Bool = true
    @State private var selectedCategory: QuizCategory = .mixed
    @State private var selectedDifficulty: QuizDifficulty = .medium
    @ObservedObject private var achievements = AchievementsManager.shared
    @Environment(\.horizontalSizeClass) private var hSizeClass

    // Optional initial parameters for auto-start scenarios (e.g., from Home)
    var initialCategory: QuizCategory? = nil
    var initialDifficulty: QuizDifficulty? = nil
    var autoStart: Bool = false

    var body: some View {
        NavigationView {
            Group {
                if showStart {
                    startScreen
                } else if viewModel.isFinished {
                    VStack(spacing: 12) {
                        Image(systemName: "rosette")
                            .font(.system(size: 48))
                            .foregroundColor(.accentColor)
                        Text("Результат: \(viewModel.score) / \(viewModel.questions.count)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Button("Пройти снова") { viewModel.restart() }
                            .buttonStyle(.borderedProminent)
                        Button("К выбору режима") {
                            showStart = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .onAppear {
                        let cat: QuizResultCategory
                        switch selectedCategory {
                        case .authors: cat = .authors
                        case .books: cat = .books
                        case .quotes: cat = .quotes
                        case .mixed: cat = .mixed
                        }
                        let summary = QuizResultSummary(category: cat, score: viewModel.score, total: viewModel.questions.count)
                        achievements.evaluateAndUnlock(for: summary)
                    }
                } else if let q = viewModel.currentQuestion {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Progress and header
                            ProgressView(value: viewProgress)
                                .tint(.accentColor)
                                .scaleEffect(x: 1, y: 1.6, anchor: .center)
                            HStack(alignment: .center) {
                                Label(selectedCategory.rawValue, systemImage: iconName(for: selectedCategory))
                                Spacer()
                                Label("\(viewModel.remainingSeconds)s", systemImage: "timer")
                                    .foregroundColor(.secondary)
                                Button(viewModel.isPaused ? "Продолжить" : "Пауза") {
                                    viewModel.togglePause()
                                }
                                .buttonStyle(.bordered)
                            }

                            // Prompt card (larger)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Вопрос \(viewModel.currentIndex + 1) из \(viewModel.questions.count)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text(q.prompt)
                                    .font(.title2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))

                            // Options big buttons
                            VStack(spacing: 12) {
                                ForEach(Array(q.options.enumerated()), id: \.offset) { idx, option in
                                    Button(action: { viewModel.selectOption(idx) }) {
                                        HStack(spacing: 12) {
                                            Text(option)
                                                .font(.system(size: 18, weight: .regular))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            if let sel = viewModel.selectedIndex, sel == idx {
                                                Image(systemName: idx == q.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                    .foregroundColor(idx == q.correctIndex ? .green : .red)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 56)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color(.tertiarySystemBackground))
                                        )
                                    }
                                    .disabled(viewModel.selectedIndex != nil)
                                }
                            }

                            Spacer(minLength: 24)
                        }
                        .padding(16)
                    }
                    .animation(.easeInOut, value: viewModel.currentIndex)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Квиз")
            .onAppear {
                if autoStart, let cat = initialCategory, let diff = initialDifficulty, showStart {
                    selectedCategory = cat
                    selectedDifficulty = diff
                    showStart = false
                    viewModel.start(category: cat, difficulty: diff)
                }
            }
        }
    }

    private var viewProgress: Double {
        guard viewModel.questions.count > 0 else { return 0 }
        return Double(viewModel.currentIndex) / Double(viewModel.questions.count)
    }

    private func iconName(for cat: QuizCategory) -> String {
        switch cat {
        case .authors: return "person.text.rectangle"
        case .books: return "books.vertical.fill"
        case .quotes: return "quote.bubble.fill"
        case .mixed: return "sparkles"
        }
    }

    private var startScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Режим квиза")
                    .font(.title2)
                    .fontWeight(.bold)

                // Category grid (cards)
                // Две колонки как "коллекция", единый стиль шрифта
                let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(QuizCategory.allCases) { cat in
                        Button {
                            selectedCategory = cat
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: iconName(for: cat))
                                    .font(.system(size: 24))
                                    .foregroundColor(.accentColor)
                                Text(cat.rawValue)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, minHeight: 96, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(cat == selectedCategory ? Color.accentColor.opacity(0.15) : Color(.secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(cat == selectedCategory ? Color.accentColor : Color.clear, lineWidth: 1)
                            )
                        }
                    }
                }

                // Difficulty (bigger segmented look)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Сложность")
                        .font(.headline)
                    Picker("Сложность", selection: $selectedDifficulty) {
                        ForEach(QuizDifficulty.allCases) { diff in
                            Text(diff.rawValue).tag(diff)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Start button large
                Button {
                    showStart = false
                    viewModel.start(category: selectedCategory, difficulty: selectedDifficulty)
                } label: {
                    HStack {
                        Spacer()
                        Text("Начать")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.accentColor.opacity(0.2)))
                }

                Spacer(minLength: 16)
            }
            .padding(16)
        }
    }
}

#Preview {
    QuizView()
}


