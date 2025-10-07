//
//  ContentView.swift
//  TestAppN1
//
//  Created by Dmitrii Nazarov on 07.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }

            QuizView()
                .tabItem {
                    Label("Квиз", systemImage: "questionmark.circle.fill")
                }

            AchievementsView()
                .tabItem {
                    Label("Награды", systemImage: "rosette")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
