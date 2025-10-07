//
//  TestAppN1App.swift
//  TestAppN1
//
//  Created by Dmitrii Nazarov on 07.10.2025.
//

import SwiftUI

@main
struct TestAppN1App: App {
    @State private var showSplash: Bool = true
    @AppStorage("onboardingFinished") private var onboardingFinished: Bool = false
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false
    @AppStorage("textSize") private var textSize: Double = 16
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showSplash = false
                        }
                    }
                } else if !onboardingFinished {
                    OnboardingView(isFinished: $onboardingFinished)
                } else {
                    ContentView()
                }
            }
            .preferredColorScheme(useDarkMode ? .dark : nil)
            .environment(\.font, .system(size: CGFloat(textSize)))
        }
    }
}
