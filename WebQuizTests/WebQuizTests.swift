//
//  WebQuizTests.swift
//  WebQuizTests
//
//  Created by Natanael nogueira on 06/07/25.
//

import Testing
import Foundation
@testable import WebQuiz

@Suite final class QuizViewModelUnitTests {

    let mockRepository: MockSupabaseRepository
    let viewModel: QuizViewModel

    init() {
        let mock = MockSupabaseRepository()
        self.mockRepository = mock
        self.viewModel = QuizViewModel(repository: mock)
    }

    
    @Test func testFetchSeriesSuccessUpdatesState() async throws {
        #expect(viewModel.isLoading == false)
        
        await viewModel.fetchSeriesData()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.series.count == 2, "Deveria carregar as 2 séries do Mock.")
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func testFetchSeriesFailureCapturesError() async {
        self.mockRepository.shouldThrowError = true
        
        await viewModel.fetchSeriesData()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil, "Deveria ter capturado o erro de rede simulado.")
        #expect(viewModel.series.isEmpty, "As séries devem estar vazias após a falha.")
    }

    
    @Test func testProgressPercentageCalculation() {
        viewModel.questions = [MockSupabaseRepository().mockQuestions[0], MockSupabaseRepository().mockQuestions[0]] // 2 questões
        viewModel.totalQuestionsCount = 2
        viewModel.currentIndex = 1
        
        let progress = viewModel.progressPercentageText
        
        #expect(progress == "50%", "O progresso deveria ser 50% com 1/2 questões completas.")
    }
    
    @Test func testNextQuestionOnCorrectAnswer() {
        let mockAnswer = Answer(id: 1, question_id: 1, answer: "Resposta Certa", is_correct: true)
        viewModel.currentIndex = 0
        viewModel.correctQuestions = 0
        
        viewModel.NextQuestion(answer: mockAnswer)
        
        #expect(viewModel.ButtoesDisable == true, "O botão deve ser desabilitado imediatamente.")
        
    }
}
