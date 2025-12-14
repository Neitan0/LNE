import SwiftUI
import WebKit


// ⚠️ Assumindo que Series, Level, Question e Answer foram migrados para structs Codable

@Observable
class QuizViewModel {
    
    var series: [Series] = []
    var currentLevels: [Level] = [] // Níveis da série selecionada
    var questions: [Question] = []
    
    // Dentro da classe QuizViewModel (@Observable)
    var progressPercentageText: String {
        guard totalQuestionsCount > 0 else { return "0%" }
        let percentage = (CGFloat(currentIndex) / CGFloat(totalQuestionsCount)) * 100
        
        // ⭐️ SOLUÇÃO 2: Usar String(format:) ⭐️
        // %.0f garante que o número terá 0 casas decimais.
        return String(format: "%.0f%%", percentage)
        
        // Nota: Para exibir o caractere '%' em String(format:), você precisa de '%%'.
    }
    
    private let repository: SupabaseRepositoryProtocol
    
    // --- DADOS CARREGADOS ---
    var isLoading = false
    var errorMessage: String?
    
    // --- ESTADO DO QUIZ ---
    var correctQuestions = 0
//    var currentIndex = 0
    var currentIndex: Int = 0 {
        didSet {
            // Este código é executado SEMPRE que 'currentIndex' muda.
            
            // Proteção: Garante que o novo índice está dentro dos limites do array 'questions'
            if currentIndex < questions.count {
                // Se o índice for válido, define a nova questão atual
                currentQuestion = questions[currentIndex]
            } else {
                // Se o índice estiver fora do limite (o quiz terminou)
                currentQuestion = nil
            }
        }
    }
    var ButtoesDisable = false
    var isFlashing: Bool = false
    var showExplanation: Bool = false
    var incorrectAnswersSelected = Set<String>()
    var flashingAnswerText = Set<String>()
    
    // --- TRADUÇÃO/UTILIDADE ---
    var textToTranslate = ""
    var showTranslateIcon = false
    
    
    
    init(repository: SupabaseRepositoryProtocol = SupabaseRepository()) {
        self.repository = repository
    }
    
    
    var currentQuestion: Question? = nil
    
    var totalQuestionsCount: Int = 0
    
        @MainActor
        func fetchSeriesData() async {
            isLoading = true
            errorMessage = nil
            do {
                self.series = try await repository.fetchSeries()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }

        // B. Busca Nível 2: Levels (Chamada na tela SeriesSelect/LevelSelect)
        @MainActor
        func fetchLevelsData(forSeriesID seriesID: Int) async {
            isLoading = true
            errorMessage = nil
            do {
                self.currentLevels = try await repository.fetchLevels(forSeriesID: seriesID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
        
        // C. Busca Nível 3: Quiz Data (Chamada na tela LevelSelect/QuizView)
        @MainActor
        func fetchQuizData(forLevelID levelID: Int) async {
            isLoading = true
            errorMessage = nil
            do {
                let fetchedQuestions = try await repository.fetchQuizData(forLevelID: levelID)
                self.questions = fetchedQuestions
                
                // Inicializa o estado do quiz com as questões carregadas
                self.loadQuestions(from: fetchedQuestions)
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    // Dentro da classe QuizViewModel

    @MainActor // Garante que a atualização do estado (publicado) ocorra na thread principal
    func loadQuestions(from levelQuestions: [Question]) {
        
        // 1. Define o Array de Questões
        // A VM armazena a lista de questões que serão usadas neste quiz.
        self.questions = levelQuestions
        
        // 2. Inicializa os Contadores
        // Define o número total de questões para o cálculo do progresso.
        self.totalQuestionsCount = levelQuestions.count
        
        // 3. Reseta o Índice
        // Volta o índice para o início (primeira questão).
        self.currentIndex = 0
        
        // 4. Define a Primeira Questão
        // Atualiza a propriedade 'currentQuestion' para a primeira questão do array.
        self.currentQuestion = levelQuestions.first
        
        // 5. Limpa Estados do Quiz
        // Reseta todo o estado de jogo para começar do zero.
        self.correctQuestions = 0
        self.incorrectAnswersSelected = []
        self.showExplanation = false
//        self.quizCompleted = false // Se você tiver esta flag
    }
    
    
    // ⭐️ FUNÇÃO DE NAVEGAÇÃO/RESPOSTA ATUALIZADA ⭐️
    func NextQuestion(answer: Answer) {
        
        // Proteção: Desabilita cliques enquanto a animação estiver rodando
        guard !ButtoesDisable else { return }

        if answer.is_correct {
            flashingAnswerText.insert(answer.answer) // Usando answer.answer para coincidir com seu Set<String>
            ButtoesDisable = true
            isFlashing = true
            
            // Lógica de avanço após acerto
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.correctQuestions += 1
                self.currentIndex += 1 // Avança para a próxima questão na lista plana
                self.flashingAnswerText.removeAll()
                self.isFlashing = false
                self.ButtoesDisable = false
                self.showExplanation = false // Limpa a explicação
                self.incorrectAnswersSelected.removeAll() // Limpa erros anteriores
            }
            print("Acertou")
            
        } else if !incorrectAnswersSelected.contains(answer.answer) {
            // Lógica para erro
            incorrectAnswersSelected.insert(answer.answer)
            print("Errou. Erros atuais: \(incorrectAnswersSelected.count)")

            if incorrectAnswersSelected.count >= 3 {
                // Lógica de Game Over/Avanço forçado
                ButtoesDisable = true
                isFlashing = true
                
                // Avança após a falha
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.currentIndex += 1 // Avança para a próxima questão
                    self.isFlashing = false
                    self.ButtoesDisable = false
                    self.incorrectAnswersSelected.removeAll()
                    self.showExplanation = false // Limpa a explicação
                }
            }
        } else {
            print("Clicou de novo na mesma errada, ignorado")
        }
    }
}

