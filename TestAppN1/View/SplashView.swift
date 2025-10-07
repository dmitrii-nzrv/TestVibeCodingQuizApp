//
//  SplashView.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var rotate: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accentColor.opacity(0.2), Color(.systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "book.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.accentColor)
                    .scaleEffect(scale)
                    .opacity(opacity)
                Text("ЛитКвиз")
                    .font(.title)
                    .fontWeight(.bold)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                scale = 1.08
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.0).delay(1.2)) {
                rotate = 360
                scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onFinished()
            }
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}



