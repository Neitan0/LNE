//
//  ButtonsQuiz.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 11/08/25.
//

import SwiftUI
import SwiftUI

struct ButtonsQuiz: View {
    @Bindable var quizVM: QuizViewModel
    var answer: Answer
    
    private var state: AnswerState {
        if quizVM.incorrectAnswersSelected.contains(answer.answer) {
            return .incorrect
        } else if quizVM.isFlashing && answer.is_correct {
            return .correct
        } else {
            return .normal
        }
    }
    
    var body: some View {
        Button {
            // ✅ Agora chamamos a função pública da nova VM
            quizVM.handleAnswerSelection(answer)
        } label: {
            Text(answer.answer)
                .font(.caption)
                .padding()
                .frame(width: 250, alignment: .leading)
                .foregroundStyle(.black)
                .background(
                    state == .normal ? Color.white :
                    state == .correct ? Color.green : Color.red
                )
                .cornerRadius(16)
                .padding(.trailing, 30)
                // Usando o seu Modifier de tradução
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
        // ✅ Nome da variável atualizado
        .disabled(quizVM.isButtonsDisabled)
    }
}
