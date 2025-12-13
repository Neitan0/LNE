import SwiftUI
import WebKit


// ⚠️ Assumindo que Series, Level, Question e Answer foram migrados para structs Codable

@Observable
class QuizViewModel {
    
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
    var series: [Series] = [] // O array aninhado
    var isLoading = false
    var errorMessage: String?
    
    // --- ESTADO DO QUIZ ---
    var correctQuestions = 0
    var currentIndex = 0
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
        Task {await fetchSeries()}
        
    }
    
    // ⭐️ Propriedade Computada 1: ACHATA TODAS AS QUESTÕES ⭐️
    // Isso transforma a hierarquia em uma lista simples para fácil navegação por índice.
    var allQuestions: [Question] {
        return series.flatMap { $0.levels ?? [] }
                     .flatMap { $0.questions ?? [] }
    }
    
    // ⭐️ Propriedade Computada 2: QUESTÃO ATUAL ⭐️
    var currentQuestion: Question? {
        guard currentIndex >= 0, currentIndex < allQuestions.count else {
            return nil // Quiz concluído ou índice inválido
        }
        return allQuestions[currentIndex]
    }
    
    // ⭐️ Propriedade Computada 3: TOTAL DE QUESTÕES ⭐️
    var totalQuestionsCount: Int {
        return allQuestions.count
    }
    
    @MainActor
    func fetchSeries() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedSeries = try await repository.fetchAllDataDeepJoin()
            self.series = fetchedSeries
            // Opcional: Embaralhe as questões após o carregamento se desejar
            // self.allQuestions = self.allQuestions.shuffled()
        } catch {
            self.errorMessage = "Falha ao carregar dados: \(error.localizedDescription)"
            print(error)
        }
        isLoading = false
    }
    
    // ⚠️ Removendo: A função loadQuizData não é mais necessária, pois os dados vêm do Supabase
    // func loadQuizData(Escolaridade: String) -> QuizData? { ... }
    
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
