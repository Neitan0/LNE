import SwiftUI
import WebKit


@Observable
class QuizViewModel {
    var textToTranslate = ""
    var questions: [Question] = []
    
    var ButtoesDisable = false
    var isFlashing: Bool = false
    var showExplanation: Bool = false
    var incorrectAnswersSelected = Set<String>()
    var correctQuestions = 0
    var currentIndex = 0
    
    var showTranslateIcon = false
    
    var flashingAnswerText = Set<String>()
    
    func loadQuizData(Escolaridade: String) -> QuizData? {
        guard let url = Bundle.main.url(forResource: Escolaridade, withExtension: "json") else {
            print("Arquivo Questions.json não encontrado.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let quizData = try decoder.decode(QuizData.self, from: data)
            return quizData
        } catch {
            print("Erro ao carregar ou decodificar o arquivo Questions.json: \(error)")
            return nil
        }
    }
    
    func NextQuestion(answer: Answer) {
        if answer.isCorrect {
            flashingAnswerText.insert(answer.text)
            ButtoesDisable = true
            isFlashing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.correctQuestions += 1
                self.currentIndex += 1
                self.flashingAnswerText.removeAll()
                self.isFlashing = false
                self.ButtoesDisable = false
            }
            print("acertou")
            incorrectAnswersSelected.removeAll()
        } else if !incorrectAnswersSelected.contains(answer.text) {
            incorrectAnswersSelected.insert(answer.text)
            if incorrectAnswersSelected.count == 3 {
                ButtoesDisable = true
                isFlashing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.currentIndex += 1
                    self.isFlashing = false
                    self.ButtoesDisable = false
                }
                incorrectAnswersSelected.removeAll()
            }
        } else {
            print("clicou de novo na mesma errada, ignorado")
        }
    }
}
