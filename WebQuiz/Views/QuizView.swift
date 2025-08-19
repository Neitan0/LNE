//
//  QuizView.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//

import SwiftUI

struct QuizView: View {
    let quizVM: QuizViewModel
    var Escolaridade: String
    @State var DataQuestions: QuizData = .empty
    var body: some View {
        ZStack {
            VStack {
                
                if quizVM.currentIndex < DataQuestions.questions.count {
                    VStack(alignment: .trailing) {
                        HStack(spacing: 15) {
                            ForEach(0..<3) { index in
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(index < (3 - quizVM.incorrectAnswersSelected.count) ? .red : .gray)
                            }
                        }
                        .padding()
                        ZStack {
                            ProgressBar(progress: CGFloat(quizVM.currentIndex) / CGFloat(DataQuestions.questions.count))
                            Text("\((CGFloat(quizVM.currentIndex) / CGFloat(DataQuestions.questions.count) * 100).formatted())%")
                            
                        }
                    }
                    .padding(.bottom,30)
                    let question = DataQuestions.questions[quizVM.currentIndex]
                    VStack(spacing: 20) {
                        HStack {
                            Text(question.question)
                                .font(.title3)
                                .padding()
                                .foregroundStyle(.black)
                                .background(Color.white)
                                .cornerRadius(16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .withTranslateIcon {
                                    quizVM.textToTranslate = question.question
                                }
                            Button{
                                withAnimation {
                                    quizVM.showExplanation.toggle()
                                }
                            } label: {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.title)
                                    .background(
                                        Circle()
                                            .foregroundStyle(.black)
                                            .frame(width: 20, height: 20)
                                    )
                            }
                        }
                        VStack {
                            ForEach(question.answers, id: \.text) { answer in
                                HStack(alignment: .center) {
                                    //BUTTON DAS RESPOSTAS
                                    ButtonsQuiz(quizVM: quizVM, answer: answer)
                                }
                            }
                            .onChange(of: quizVM.currentIndex) { _ in
                                quizVM.incorrectAnswersSelected.removeAll()
                                quizVM.showExplanation = false
                            }
                        }
                    }
                    if quizVM.showExplanation {
                        HStack {
                            Text(question.explanation)
                                .padding()
                                .font(.caption)
                                .foregroundStyle(.black)
                                .background(Color.yellow)
                                .cornerRadius(16)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: 300)
                                .fixedSize(horizontal: false, vertical: true)
                                .withTranslateIcon {
                                    quizVM.textToTranslate = question.explanation
                                }
                        }
                        .padding(.top,50)
                        .padding(.trailing,30)

                    }
                } else {
                    Spacer()
                    VStack {
                        Text("Quiz concluído!")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                        Text("Quantidade de acertos: \(quizVM.correctQuestions) de \(DataQuestions.questions.count)")
                            .font(.title3)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    .foregroundStyle(.black)
                    .padding()
                    Spacer()
                }
                Spacer()
                
            }
            .animation(.easeInOut)
            .foregroundStyle(.white)
            .background{
                Image("background")
            }
            .onAppear {
                DataQuestions = quizVM.loadQuizData(Escolaridade: Escolaridade) ?? .empty
                quizVM.currentIndex = 0
                quizVM.correctQuestions = 0
            }
        }
    }
    
}

#Preview {
    QuizView(quizVM: QuizViewModel(), Escolaridade: "NonoAno")
//    ContentView()
}

