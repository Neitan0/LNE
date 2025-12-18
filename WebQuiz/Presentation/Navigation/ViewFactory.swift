//
//  ViewFactory.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 18/12/25.
//

import SwiftUI

enum ViewFactory {
    
    @MainActor
    static func makeView(for destination: Destination, quizVM: QuizViewModel, navigationPath: Binding<NavigationPath>) -> some View {
        switch destination {
        case .ChoseDifficulty:
            return AnyView(
                ChoseDifficultyView(quizVM: quizVM, navigationPath: navigationPath)
            )
            
        case .LevelSelection(let serieID):
            return AnyView(
                LevelSelect(navigationPath: navigationPath, quizVM: quizVM, selectedSeries: serieID)
            )
            
        case .QuizView(let levelID):
            return AnyView(
                QuizView(quizVM: quizVM, levelID: levelID)
            )
        }
    }
}
