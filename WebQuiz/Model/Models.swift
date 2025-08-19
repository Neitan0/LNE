//
//  NavigationPathModel.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//

import Foundation

enum AnswerState {
    case normal
    case correct
    case incorrect
}

enum Destination: Hashable {
    case ChoseDifficulty
    case QuizView(Escolaridade: String)
}


struct QuizData: Decodable {
    let questions: [Question]
}

struct Question: Decodable, Identifiable {
    var id = UUID()
    let question: String
    let answers: [Answer]
    let explanation: String

    private enum CodingKeys: String, CodingKey {
        case question, answers, explanation
        // id não entra aqui!
    }
}
struct Answer: Decodable {
    let text: String
    let isCorrect: Bool
}


extension QuizData {
    static let empty = QuizData(questions: [])
}
