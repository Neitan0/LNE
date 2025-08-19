//
//  ButtonsQuiz.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 11/08/25.
//

import SwiftUI

struct ButtonsQuiz: View {
    var quizVM: QuizViewModel
    var answer: Answer
    
    private var state: AnswerState {
        if quizVM.incorrectAnswersSelected.contains(answer.text) {
            return .incorrect
        } else if quizVM.isFlashing && answer.isCorrect {
            return .correct
        } else {
            return .normal
        }
    }
    
    var body: some View {
        Button {
            quizVM.NextQuestion(answer: answer)
            // Define cor e anima
        } label: {
            Text(answer.text)
                .font(.caption)
                .padding()
                .frame(width: 250,alignment: .leading)
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
                .padding(.trailing,30)
                .withTranslateIcon {
                    quizVM.textToTranslate = answer.text
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

#Preview {
    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: true))
    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: false))
    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: false))
    ButtonsQuiz(quizVM: QuizViewModel(), answer: Answer(text: "Teste", isCorrect: false))
}
