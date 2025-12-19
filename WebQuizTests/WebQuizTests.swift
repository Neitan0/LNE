//
//  WebQuizTests.swift
//  WebQuizTests
//
//  Created by Natanael nogueira on 06/07/25.
//

import XCTest
@testable import WebQuiz // Nome do seu projeto
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
    
    
}
