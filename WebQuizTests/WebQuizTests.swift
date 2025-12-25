//
//  WebQuizTests.swift
//  WebQuizTests
//
//  Created by Natanael nogueira on 06/07/25.
//

import XCTest
@testable import WebQuiz


@MainActor
final class QuizViewModelTests: XCTestCase {
    var vm: QuizViewModel!
    var mockRepo: MockQuizRepository!

    override func setUp() {
        super.setUp()
        mockRepo = MockQuizRepository()
        vm = QuizViewModel(repository: mockRepo)
    }

    override func tearDown() {
        vm = nil
        mockRepo = nil
        super.tearDown()
    }
    
    func testFetchQuizData_ShouldSetQuestions() async {
        let question = Question(id: 1, created_at: Date(), question: "qual formula da agua", explanation: "", level_id: 1, answers: [])
        mockRepo.mockedQuestions = [question]
        
        await vm.fetchQuizData(forLevelID: 1)
        
        XCTAssertTrue(vm.questions.count == 1)
    }
    
    func testFetchQuizdata_withNoQuestions_ShouldKeepQuestionsEmpty() async {
        let question = Question(id: 1, created_at: Date(), question: "qual formula da agua", explanation: "", level_id: 1, answers: [])
        
        mockRepo.mockedQuestions = [question]
            
        mockRepo.shouldReturnError = true
        await vm.fetchQuizData(forLevelID: 1)
        
        XCTAssertTrue(vm.questions.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
        
    }

    func testHandleAnswerSelection_WhenCorrect_ShouldIncrementScore() async {
        
        let correctAnswer = Answer(id: 1, question_id: 1, answer: "Sim", is_correct: true)
        let question = Question(id: 1, created_at: Date(), question: "qual formula da agua", explanation: "", level_id: 1, answers: [correctAnswer])
        
        mockRepo.mockedQuestions = [question]
        await vm.fetchQuizData(forLevelID: 1)
        
        vm.handleAnswerSelection(correctAnswer)
        
        XCTAssertEqual(vm.correctQuestions, 1)
    }
    
    func testHandleAnswerSelection_WhenIncorrect_ShouldAddToIncorrectList() async {
        let wrongAnswer = Answer(id: 2, question_id: 1, answer: "Não", is_correct: false)
        let question = Question(id: 2, created_at: Date(), question: "qual formula da agua?", explanation: "", level_id: 1, answers: [wrongAnswer])
        
        mockRepo.mockedQuestions = [question]
        await vm.fetchQuizData(forLevelID: 1)
        
        vm.handleAnswerSelection(wrongAnswer)
        
        XCTAssertEqual(vm.correctQuestions, 0)
        XCTAssertTrue(vm.incorrectAnswersSelected.contains(wrongAnswer.answer))
    }
    
    func testHandleAnswerSelection_WhenButtondisabled() async {
        let wrongAnswer = Answer(id: 2, question_id: 1, answer: "Não", is_correct: false)
        let question = Question(id: 2, created_at: Date(), question: "qual formula da agua?", explanation: "", level_id: 1, answers: [wrongAnswer])
        
        mockRepo.mockedQuestions = [question]
        await vm.fetchQuizData(forLevelID: 1)
        
        vm.isButtonsDisabled = true
        vm.handleAnswerSelection(wrongAnswer)
        
        XCTAssertTrue(vm.isButtonsDisabled)
        XCTAssertFalse(vm.isFlashing)
        XCTAssertTrue(vm.incorrectAnswersSelected.isEmpty)
        
    }
    
    func testHandleAnswerSelection_WhenIncorrect_And_IncorretAnswerSelectedShould3Answers() async throws {
        let wrongAnswer = Answer(id: 2, question_id: 1, answer: "Não", is_correct: false)
        let q1 = Question(id: 1, created_at: Date(), question: "Q1", explanation: "", level_id: 1, answers: [wrongAnswer])
        let q2 = Question(id: 2, created_at: Date(), question: "Q2", explanation: "", level_id: 1, answers: [])
        
        mockRepo.mockedQuestions = [q1, q2]
        await vm.fetchQuizData(forLevelID: 1)
        vm.incorrectAnswersSelected = ["resposta errada1","resposta errada2"]
        vm.handleAnswerSelection(wrongAnswer)
        
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        XCTAssertEqual(vm.correctQuestions, 0)
        XCTAssertTrue(vm.incorrectAnswersSelected.isEmpty)
        XCTAssertFalse(vm.isButtonsDisabled)
        XCTAssertEqual(vm.currentIndex, 1)
        XCTAssertFalse(vm.showExplanation)
        XCTAssertFalse(vm.isFlashing)
    }
    
    func testFetchSeriesData_WhenSuccess_ShouldFillSeries() async {
            let Series = [Series(id: 1, created_at: Date(), name: "Nono Ano", levels: [])]
            mockRepo.mockedSeries = Series
            
            await vm.fetchSeriesData()
            
            XCTAssertEqual(vm.series.count, 1, "A lista de séries deveria ter exatamente 1 item")
            XCTAssertEqual(vm.series.first?.name, "Nono Ano")
            XCTAssertFalse(vm.isLoading, "O loading deveria ser false após o término")
            XCTAssertNil(vm.errorMessage, "O erro deveria ser nulo em caso de sucesso")
        }
    
    func testFetchSeriesData_WhenError_ShouldSetErrorMessage() async {
            mockRepo.shouldReturnError = true
            
            await vm.fetchSeriesData()
            
            XCTAssertTrue(vm.series.isEmpty)
            XCTAssertNotNil(vm.errorMessage)
            XCTAssertFalse(vm.isLoading)
        }
    
    func testfetchLevelsData_WhenSuccess_ShouldFillLevels() async {
        let Levels = [Level(id: 1, created_at: Date(), level_number: 1, serie_id: 1)]
        mockRepo.mockedLevels = Levels
        
        await vm.fetchLevelsData(forSeriesID: 1)
        
        XCTAssertEqual(vm.currentLevels.count, 1)
        XCTAssertEqual(vm.currentLevels.first?.level_number, 1)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
    }
    
    func testFetchLevelsData_WhenError_ShouldSetErrorMessage() async {
        mockRepo.shouldReturnError = true
        
        await vm.fetchLevelsData(forSeriesID: 1)
        
        XCTAssertTrue(vm.currentLevels.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }
    
    func testFetchLevelsData_ShouldSortLevelsByNumber() async {
        let level3 = Level(id: 3, created_at: Date(), level_number: 3, serie_id: 1)
        let level1 = Level(id: 1, created_at: Date(), level_number: 1, serie_id: 1)
        let level2 = Level(id: 2, created_at: Date(), level_number: 2, serie_id: 1)
        
        mockRepo.mockedLevels = [level3, level1, level2]
        
        await vm.fetchLevelsData(forSeriesID: 1)
        
        XCTAssertEqual(vm.currentLevels.count, 3)
        XCTAssertEqual(vm.currentLevels[0].level_number, 1)
        XCTAssertEqual(vm.currentLevels[1].level_number, 2)
        XCTAssertEqual(vm.currentLevels[2].level_number, 3)
    }
    
    func testProgressPercentageText_Calculations() async {
        XCTAssertEqual(vm.progressPercentageText, "0%", "Deveria ser 0% quando não há questões")

        let q = Question(id: 1, created_at: Date(), question: "", explanation: "", level_id: 1, answers: [])
        mockRepo.mockedQuestions = [q, q, q, q]
        await vm.fetchQuizData(forLevelID: 1)

        XCTAssertEqual(vm.progressPercentageText, "0%")

        vm.currentIndex = 2
        XCTAssertEqual(vm.progressPercentageText, "50%", "Deveria calcular 50% corretamente")
        
        vm.currentIndex = 4
        XCTAssertEqual(vm.progressPercentageText, "100%")
    }
    
    
}
