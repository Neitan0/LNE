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


//struct QuizData: Decodable {
//    let questions: [Question]
//}
//
//struct Question: Decodable, Identifiable {
//    var id = UUID()
//    let question: String
//    let answers: [Answer]
//    let explanation: String
//
//    private enum CodingKeys: String, CodingKey {
//        case question, answers, explanation
//        // id não entra aqui!
//    }
//}
//struct Answer: Decodable {
//    let text: String
//    let isCorrect: Bool
//}
//
//
//extension QuizData {
//    static let empty = QuizData(questions: [])
//}


import Foundation

// Tabela 'series'
struct Series: Codable, Identifiable {
    let id: Int
    let created_at: Date? // Pode ser String ou Date
    let name: String
    var levels: [Level]?
}

// Tabela 'levels'
struct Level: Codable {
    let id: Int
    let created_at: Date?
    let level_number: Int
    let serie_id: Int // Chave estrangeira
    
    // Relacionamento: Nível pertence a uma Série
    var series: Series? // Para carregar a série (Join)
    var questions: [Question]?
}

// Tabela 'questions'
struct Question: Codable {
    let id: Int
    let created_at: Date?
    let question: String
    let explanation: String?
    let level_id: Int
    
    // Relacionamento: Questão pertence a um Nível
    var levels: Level? // Para carregar o nível (Join)
    
    // Relacionamento: Resposta pertence a uma Questão
    var answers: [Answer]? // Para carregar as respostas (Join)
}

// Tabela 'answers'
struct Answer: Codable {
    let id: Int
    let question_id: Int // Chave estrangeira
    let answer: String
    let is_correct: Bool
}
