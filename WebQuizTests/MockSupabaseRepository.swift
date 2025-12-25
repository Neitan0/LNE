//
//  MockSupabaseRepository.swift
//  WebQuizTests
//
//  Created by Natanael Nogueira on 15/12/25.
//

import Foundation
@testable import WebQuiz

class MockQuizRepository: QuizRepositoryProtocol {
    var mockedQuestions: [Question] = []
    var mockedSeries: [Series] = []
    var mockedLevels: [Level] = []
    var shouldReturnError = false
    
    
    
    func fetchSeries() async throws -> [Series] {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 0)
        }
        return mockedSeries
    }
    
    func fetchLevels(forSeriesID seriesID: Int) async throws -> [Level] {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 0)
        }
        return mockedLevels
    }

    func fetchQuizData(forLevelID levelID: Int) async throws -> [Question] {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 0)
        }
        return mockedQuestions
    }
}
