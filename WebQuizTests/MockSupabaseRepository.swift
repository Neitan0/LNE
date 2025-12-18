//
//  MockSupabaseRepository.swift
//  WebQuizTests
//
//  Created by Natanael Nogueira on 15/12/25.
//

import Foundation
@testable import WebQuiz

class MockSupabaseRepository: SupabaseRepositoryProtocol {
    
    let mockSeries = [
        Series(id: 1, created_at: nil, name: "Nono Ano"),
        Series(id: 2, created_at: nil, name: "Primeiro Ano")
    ]
    let mockLevels = [
        Level(id: 101, created_at: nil, level_number: 1, serie_id: 1),
        Level(id: 102, created_at: nil, level_number: 2, serie_id: 1),
        Level(id: 103, created_at: nil, level_number: 1, serie_id: 2),
        Level(id: 104, created_at: nil, level_number: 2, serie_id: 2),

    ]
    let mockQuestions = [
        Question(id: 201, created_at: nil, question: "qual a formula da agua?", explanation: nil, level_id: 101),
        Question(id: 202, created_at: nil, question: "qual a formula do gelo?", explanation: nil, level_id: 102),
        Question(id: 203, created_at: nil, question: "qual a formula da agua2?", explanation: nil, level_id: 103),
        Question(id: 203, created_at: nil, question: "qual a formula da aaaaaa?", explanation: nil, level_id: 104),
    ]
    
    var shouldThrowError = false
    
    
    func fetchSeries() async throws -> [WebQuiz.Series] {
        if shouldThrowError {
            // Se shouldThrowError for true, lança o erro
            throw NSError(domain: "MockError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Falha de rede simulada"])
        }
        // Retorna o dado de sucesso
        return mockSeries
    }
    
    func fetchLevels(forSeriesID seriesID: Int) async throws -> [WebQuiz.Level] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 500, userInfo: nil) }
        return mockLevels.filter { $0.serie_id == seriesID }
    }
    
    func fetchQuizData(forLevelID levelID: Int) async throws -> [WebQuiz.Question] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 500, userInfo: nil) }
        return mockQuestions
    }
    
    

}
