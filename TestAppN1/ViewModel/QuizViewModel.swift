//
//  QuizViewModel.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import Foundation

final class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var isFinished: Bool = false
    @Published var selectedIndex: Int? = nil
    @Published var remainingSeconds: Int = 0
    @Published var activeDifficulty: QuizDifficulty = .medium
    @Published var isPaused: Bool = false

    private var timer: Timer?

    func start(category: QuizCategory, difficulty: QuizDifficulty) {
        activeDifficulty = difficulty
        questions = QuizBank.questions(category: category, difficulty: difficulty)
        currentIndex = 0
        score = 0
        isFinished = false
        selectedIndex = nil
        startTimer()
    }

    var currentQuestion: QuizQuestion? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }

    func selectOption(_ index: Int) {
        guard selectedIndex == nil, !isPaused else { return }
        selectedIndex = index
        if index == currentQuestion?.correctIndex { score += 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.next()
        }
    }

    func next() {
        selectedIndex = nil
        resetTimer()
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            startTimer()
        } else {
            isFinished = true
            stopTimer()
        }
    }

    func restart() {
        start(category: .mixed, difficulty: activeDifficulty)
    }

    private func startTimer() {
        stopTimer()
        remainingSeconds = activeDifficulty.timePerQuestionSeconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if isPaused { return }
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                self.selectOption(-1) // авто-переход, без очков
            }
        }
    }

    private func resetTimer() {
        remainingSeconds = activeDifficulty.timePerQuestionSeconds
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func togglePause() {
        isPaused.toggle()
    }
}


