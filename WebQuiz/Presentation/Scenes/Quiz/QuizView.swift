//
//  QuizView.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//

import SwiftUI

struct QuizView: View {

    @Bindable var quizVM: QuizViewModel
    var levelID: Int

    var body: some View {
        ZStack {
            Image("background")
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 150)
                if quizVM.isLoading {
                    ProgressView("Carregando Quiz...")
                        .tint(.white)
                        .padding()
                } else if let error = quizVM.errorMessage {
                    errorStateView(error)
                } else if let question = quizVM.currentQuestion {
                    quizContentView(question)
                } else {
                    quizCompletionView
                }
                Spacer()
            }
        }
        .task {
            await quizVM.fetchQuizData(forLevelID: levelID)
        }
        .overlay(alignment: .bottomTrailing) {
            VLibrasWebView(textToTranslate: $quizVM.textToTranslate)
                .frame(width: 1, height: 1)  // Mantém invisível mas funcional
        }
    }
}

// MARK: - Subviews (Organização para evitar Views Gigantes)
extension QuizView {

    fileprivate func quizContentView(_ question: Question) -> some View {
        VStack(spacing: 20) {
            VStack(alignment: .trailing) {
                HStack(spacing: 15) {
                    ForEach(0..<3) { index in
                        Image(systemName: "heart.fill")
                            .foregroundStyle(
                                index
                                    < (3 - quizVM.incorrectAnswersSelected.count)
                                    ? .red : .gray
                            )
                    }
                }
                .padding(.bottom, 5)

                ZStack {
                    // Calculamos o progresso usando a contagem do array 'questions'
                    ProgressBar(
                        progress: quizVM.questions.isEmpty
                            ? 0
                            : CGFloat(quizVM.currentIndex)
                                / CGFloat(quizVM.questions.count)
                    )

                    Text(quizVM.progressPercentageText)
                        .font(.caption2).bold()
                }
            }
            .padding(.bottom, 20)

            // Questão
            HStack {
                Text(question.question)
                    .font(.title3)
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.white)
                    .cornerRadius(16)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 300)
                    .withTranslateIcon {
                        quizVM.textToTranslate = question.question
                    }

                Button {
                    withAnimation { quizVM.showExplanation.toggle() }
                } label: {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.yellow)
                        .font(.title)
                        .fixedSize()
                }
            }

            // Lista de Respostas
            VStack(spacing: 12) {
                ForEach(question.answers ?? [], id: \.id) { answer in
                    ButtonsQuiz(quizVM: quizVM, answer: answer)
                }
            }

            // Explicação Dinâmica
            if quizVM.showExplanation {
                explanationView(question.explanation)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    fileprivate func explanationView(_ text: String?) -> some View {
        let message = text ?? "Sem explicações disponíveis."

        return Text(message)
            .font(.caption)
            .foregroundStyle(.black)
            .padding()
            .frame(maxWidth: 280)
            .background(Color.yellow)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .multilineTextAlignment(.leading)
            .withTranslateIcon {
                quizVM.textToTranslate = message
            }
            .padding(.top, 10)
    }

    fileprivate var quizCompletionView: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Quiz concluído!")
                .font(.largeTitle).bold()
            Text(
                "Acertos: \(quizVM.correctQuestions) de \( quizVM.questions.count)"
            )
            .font(.title2)
            Spacer()
        }
    }

    fileprivate func errorStateView(_ error: String) -> some View {
        VStack {
            Text("Erro ao carregar dados").bold()
            Text(error).font(.caption)
            Button("Tentar Novamente") {
                Task { await quizVM.fetchQuizData(forLevelID: levelID) }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

//#Preview {
//    QuizView(
//        quizVM: QuizViewModel(repository: SupabaseRepository()),
//        levelID: 1
//    )
//}
