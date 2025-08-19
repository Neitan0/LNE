//
//  TranslateIcon.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 05/08/25.
//

import SwiftUI

struct TranslateIconModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        HStack {
            Button(action: action) {
                Image(systemName: "translate")
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .frame(width: 35, height: 35)
                    .background(Circle().fill(.ultraThinMaterial))
                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
            }
            content
        }
    }
}

extension View {
    func withTranslateIcon(action: @escaping () -> Void) -> some View {
        self.modifier(TranslateIconModifier(action: action))
    }
}


#Preview {
    Text("Texto com botão de tradução")
        .withTranslateIcon {
            print("Traduzir!")
        }
}
