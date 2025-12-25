import SwiftUI

@Observable
@MainActor
class QuizViewModel {
    
    // --- DEPENDÊNCIAS ---
    private let repository: QuizRepositoryProtocol
    
    // --- DADOS CARREGADOS ---
    private(set) var series: [Series] = []         // Para ChoseDifficultyView
    private(set) var currentLevels: [Level] = []  // Para LevelSelect
    private(set) var questions: [Question] = []    // Para QuizView
    private(set) var currentQuestion: Question?
    
    // --- ESTADO DO QUIZ ---
    var currentIndex: Int = 0
    var correctQuestions: Int = 0
    var isButtonsDisabled = false
    var isFlashing = false
    var showExplanation = false
    var incorrectAnswersSelected = Set<String>()
    
    // --- UI/UX ---
    var isLoading = false
    var errorMessage: String?
    var textToTranslate = ""
    
    var progressPercentageText: String {
        guard !questions.isEmpty else { return "0%" }
        let percentage = (Double(currentIndex) / Double(questions.count)) * 100
        return String(format: "%.0f%%", percentage)
    }

    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }

    // --- CARREGAMENTO DE DADOS ---
    
    // 1. Carrega Séries (Anos escolares)
    func fetchSeriesData() async {
        isLoading = true
        errorMessage = nil
        do {
            self.series = try await repository.fetchSeries()
        } catch {
            self.errorMessage = "Erro ao carregar séries: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // 2. Carrega Níveis de uma Série específica
    func fetchLevelsData(forSeriesID seriesID: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedLevels = try await repository.fetchLevels(forSeriesID: seriesID)
            self.currentLevels = fetchedLevels.sorted { $0.level_number < $1.level_number }
        } catch {
            self.errorMessage = "Erro ao carregar níveis: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // 3. Carrega Questões de um Nível específico
    func fetchQuizData(forLevelID levelID: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedQuestions = try await repository.fetchQuizData(forLevelID: levelID)
            setupQuiz(with: fetchedQuestions)
        } catch {
            self.errorMessage = "Erro ao carregar questões: \(error.localizedDescription)"
        }
        isLoading = false
    }

    private func setupQuiz(with fetchedQuestions: [Question]) {
        self.questions = fetchedQuestions
        self.currentIndex = 0
        self.correctQuestions = 0
        self.currentQuestion = questions.first
        self.resetQuestionState()
    }

    // --- LÓGICA DO JOGO ---

    func handleAnswerSelection(_ answer: Answer) {
        guard !isButtonsDisabled else { return }

        if answer.is_correct {
            handleCorrectAnswer(answer)
        } else {
            handleIncorrectAnswer(answer)
        }
    }

    private func handleCorrectAnswer(_ answer: Answer) {
        isButtonsDisabled = true
        isFlashing = true
        correctQuestions += 1
        
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seg
            goToNextQuestion()
        }
    }

    private func handleIncorrectAnswer(_ answer: Answer) {
        if !incorrectAnswersSelected.contains(answer.answer) {
            incorrectAnswersSelected.insert(answer.answer)
            
            if incorrectAnswersSelected.count >= 3 {
                isButtonsDisabled = true
                Task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    goToNextQuestion()
                }
            }
        }
    }

    private func goToNextQuestion() {
        currentIndex += 1
        if currentIndex < questions.count {
            currentQuestion = questions[currentIndex]
            resetQuestionState()
        } else {
            currentQuestion = nil
        }
    }

    private func resetQuestionState() {
        isButtonsDisabled = false
        isFlashing = false
        showExplanation = false
        incorrectAnswersSelected.removeAll()
    }
}
