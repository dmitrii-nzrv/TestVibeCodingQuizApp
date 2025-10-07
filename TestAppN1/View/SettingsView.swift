//
//  SettingsView.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    @AppStorage("onboardingFinished") private var onboardingFinished: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Вид")) {
                    Toggle("Тёмная тема", isOn: $useDarkMode)
                }

                Section(header: Text("Уведомления")) {
                    Toggle(isOn: Binding<Bool>(
                        get: { notificationsEnabled },
                        set: { newValue in
                            if newValue {
                                enableNotifications()
                            } else {
                                disableNotifications()
                            }
                        }
                    )) {
                        HStack {
                            Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash")
                                .foregroundColor(.accentColor)
                            Text("Ежедневный квиз 20:00")
                        }
                    }
                    Button("Открыть настройки уведомлений") { openSystemSettings() }
                }

                Section(header: Text("Сброс")) {
                    Button(role: .destructive) { AchievementsManager.shared.resetAll() } label: {
                        Label("Сбросить достижения", systemImage: "trash")
                    }
                    Button {
                        onboardingFinished = false
                    } label: {
                        Label("Показать онбординг снова", systemImage: "sparkles")
                    }
                }

                Section(header: Text("О приложении")) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("ЛитКвиз v0.1")
                        Spacer()
                    }
                }
            }
            .navigationTitle("Настройки")
        }
        .preferredColorScheme(useDarkMode ? .dark : nil)
    }

    private func enableNotifications() {
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
                DispatchQueue.main.async { openSystemSettings() }
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

    private func disableNotifications() {
        notificationsEnabled = false
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_quiz_reminder"])
    }

    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_quiz_reminder"])
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
    SettingsView()
}



