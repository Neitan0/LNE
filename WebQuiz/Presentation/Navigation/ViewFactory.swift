//
//  ViewFactory.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 18/12/25.
//

import SwiftUI

enum ViewFactory {
    
    @MainActor
    @ViewBuilder 
    static func makeView(for destination: Destination, quizVM: QuizViewModel, navigationPath: Binding<NavigationPath>) -> some View {
        switch destination {
        case .ChoseDifficulty:
            ChoseDifficultyView(quizVM: quizVM, navigationPath: navigationPath)
            
        case .LevelSelection(let serieID):
            LevelSelect(navigationPath: navigationPath, quizVM: quizVM, selectedSeries: serieID)
            
        case .QuizView(let levelID):
            QuizView(quizVM: quizVM, levelID: levelID)
        }
    }
}
