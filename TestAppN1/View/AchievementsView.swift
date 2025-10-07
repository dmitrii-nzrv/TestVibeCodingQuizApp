//
//  AchievementsView.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject private var manager = AchievementsManager.shared

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Открыты")) {
                    ForEach(AchievementsCatalog.all.filter { manager.unlocked.contains($0.id) }) { def in
                        row(for: def, unlocked: true)
                    }
                }

                Section(header: Text("Заблокированы")) {
                    ForEach(AchievementsCatalog.all.filter { !manager.unlocked.contains($0.id) }) { def in
                        row(for: def, unlocked: false)
                    }
                }

                Section(footer: Text("Серия подряд: \(manager.streakCount)")) { EmptyView() }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Достижения")
        }
    }

    private func row(for def: AchievementDefinition, unlocked: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: unlocked ? "seal.fill" : "seal")
                .foregroundColor(unlocked ? .accentColor : .gray)
            VStack(alignment: .leading, spacing: 4) {
                Text(def.title)
                    .fontWeight(.bold)
                Text(def.description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    AchievementsView()
}


