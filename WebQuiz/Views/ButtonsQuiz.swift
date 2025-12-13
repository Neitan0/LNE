//
//  ButtonsQuiz.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 11/08/25.
//

import SwiftUI

struct ButtonsQuiz: View {
    // A VM está correta, usando @Observable
    @Bindable var quizVM: QuizViewModel // Use @Bindable se a View não for a dona e o componente precisar de escrita
    var answer: Answer
    
    // ⭐️ AJUSTES NO CÁLCULO DE ESTADO ⭐️
    private var state: AnswerState {
        // 1. Verificação de Incorreta: Usa a propriedade 'answer' do modelo
        if quizVM.incorrectAnswersSelected.contains(answer.answer) {
            return .incorrect
        // 2. Verificação de Correta (Flashing): Usa a propriedade 'is_correct' do modelo
        } else if quizVM.isFlashing && answer.is_correct {
            return .correct
        } else {
            return .normal
        }
    }
    
    var body: some View {
        Button {
            // O nome da função na VM é 'NextQuestion'
            quizVM.NextQuestion(answer: answer)
        } label: {
            Text(answer.answer) // ⭐️ Usa a propriedade 'answer' para o texto ⭐️
                .font(.caption)
                .padding()
                .frame(width: 250, alignment: .leading)
                .foregroundStyle(.black)
                .background(
                    {
                        switch state {
                        case .normal: return Color.white
                        case .correct: return Color.green
                        case .incorrect: return Color.red
                        }
                    }()
                )
                .cornerRadius(16)
                .padding(.trailing, 30)
                .withTranslateIcon {
                    quizVM.textToTranslate = answer.answer
                }
                .animation(
                    quizVM.isFlashing && state == .correct
                    ? .easeOut(duration: 0.15).repeatForever(autoreverses: true)
                    : .default,
                    value: quizVM.isFlashing
                )
        }
        .disabled(quizVM.ButtoesDisable)
    }
}

//#Preview {
//    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: true))
//    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: false))
//    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: false))
//    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: false))
//}
