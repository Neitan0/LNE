//
//  AppDestination.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 17/12/25.
//

import Foundation


enum Destination: Hashable {
    case ChoseDifficulty
    case QuizView(Level: Int)
    case LevelSelection(SerieID: Int)
}
