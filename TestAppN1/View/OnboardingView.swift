//
//  OnboardingView.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import SwiftUI
import UserNotifications

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

struct OnboardingView: View {
    @Binding var isFinished: Bool
    @AppStorage("onboardingLastPage") private var lastPage: Int = 0
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @State private var selection: Int = 0

    private var pages: [OnboardingPage] {
        [
            OnboardingPage(title: "ЛитКвиз", subtitle: "Проверьте знания авторов, книг и цитат", systemImage: "book.fill"),
            OnboardingPage(title: "Режимы и уровни", subtitle: "Выбирайте категорию и сложность — соревнуйтесь с собой", systemImage: "rosette"),
            OnboardingPage(title: "Достижения", subtitle: "Открывайте бэджи и следите за прогрессом", systemImage: "seal.fill"),
            OnboardingPage(title: "Персонализация", subtitle: "Выберите тему и включите напоминания о квизах", systemImage: "gearshape.fill")
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if selection > 0 {
                    Button("Назад") { withAnimation { selection -= 1 } }
                } else {
                    Color.clear.frame(width: 1, height: 1)
                }
                Spacer()

                Button("Пропустить") { finish() }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            TabView(selection: $selection) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    VStack(spacing: 16) {
                        Image(systemName: page.systemImage)
                            .font(.system(size: 72))
                            .foregroundColor(.accentColor)
                        Text(page.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(page.subtitle)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        if index == pages.count - 1 {
                            VStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Toggle("Тёмная тема", isOn: $useDarkMode)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )

                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 10) {
                                        Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash")
                                            .foregroundColor(.accentColor)
                                        Text(notificationsEnabled ? "Уведомления включены" : "Уведомления выключены")
                                        Spacer()
                                        Button(notificationsEnabled ? "Изм." : "Включить") {
                                            requestNotifications()
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onChange(of: selection) { newValue in
                lastPage = newValue
            }
            .onAppear {
                selection = lastPage
            }

            HStack(spacing: 12) {
                Spacer()
                if selection < pages.count - 1 {
                    Button("Далее") { withAnimation { selection += 1 } }
                        .buttonStyle(.borderedProminent)
                } else {
                    Button("Начать") { finish() }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }

    private func finish() {
        isFinished = true
        UserDefaults.standard.set(true, forKey: "onboardingFinished")
    }

    private func requestNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    DispatchQueue.main.async {
                        notificationsEnabled = granted
                        if granted { scheduleDailyReminder() }
                    }
                }
            case .denied:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    DispatchQueue.main.async { UIApplication.shared.open(url) }
                }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    notificationsEnabled = true
                    scheduleDailyReminder()
                }
            @unknown default:
                DispatchQueue.main.async { notificationsEnabled = false }
            }
        }
    }

    private func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_quiz_reminder"]) // reschedule

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Ежедневный квиз"
        content.body = "Загляните в ЛитКвиз и проверьте себя сегодня!"
        content.sound = .default

        let request = UNNotificationRequest(identifier: "daily_quiz_reminder", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
}

#Preview {
    OnboardingView(isFinished: .constant(false))
}


