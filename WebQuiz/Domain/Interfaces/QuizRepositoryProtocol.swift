//
//  QuizRepositoryProtocol.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 17/12/25.
//

import Foundation

protocol QuizRepositoryProtocol {
    func fetchSeries() async throws -> [Series]
    func fetchLevels(forSeriesID seriesID: Int) async throws -> [Level]
    func fetchQuizData(forLevelID levelID: Int) async throws -> [Question]
}
