//
//  QuizView.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//

import SwiftUI

struct QuizView: View {
    // ⭐️ Alteração 1: A View deve ser a dona da VM usando @State para Observable ⭐️
    // Se a VM for injetada, use @Bindable na assinatura. Aqui, assumimos que ela é a dona.
    @State var quizVM = QuizViewModel()
    
    var Escolaridade: String  // Mantido para possível filtragem futura
    
    // As propriedades @State DataQuestions e Escolaridade não são mais necessárias
    // Opcional: Remova o `DataQuestions` se não for mais usado
    
    var body: some View {
        ZStack {
            VStack {
                // ⭐️ Novo gerenciamento de estado: Carregando / Erro ⭐️
                if quizVM.isLoading {
                    ProgressView("Carregando Quiz...")
                        .padding()
                } else if let error = quizVM.errorMessage {
                    Text("Erro ao carregar dados: \(error)")
                        .foregroundStyle(.red)
                }
                // ⭐️ Acesso à Questão Atual ⭐️
                else if let question = quizVM.currentQuestion {
                    
                    // --- Display de Vidas e Progresso ---
                    VStack(alignment: .trailing) {
                        HStack(spacing: 15) {
                            ForEach(0..<3) { index in
                                Image(systemName: "heart.fill")
                                // Use incorrectAnswersSelected.count para as vidas
                                    .foregroundStyle(
                                        index
                                        < (3
                                           - quizVM
                                            .incorrectAnswersSelected.count)
                                        ? .red : .gray
                                    )
                            }
                        }
                        .padding()
                        ZStack {
                            ProgressBar(
                                progress: CGFloat(quizVM.currentIndex)
                                / CGFloat(quizVM.totalQuestionsCount)
                            )
                            Text(quizVM.progressPercentageText)  // <<-- ESTA É A ALTERAÇÃO!
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // --- Questão e Botão de Explicação ---
                    VStack(spacing: 20) {
                        HStack {
                            Text(question.question)  // Acesso direto à questão atual
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
                            Button {
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
                        
                        // --- Respostas ---
                        VStack {
                            // ⭐️ Itera sobre as respostas da questão atual ⭐️
                            ForEach(question.answers ?? [], id: \.id) {
                                answer in
                                HStack(alignment: .center) {
                                    // ⭐️ Alteração 2: Passa a VM e a resposta para o componente ⭐️
                                    ButtonsQuiz(quizVM: quizVM, answer: answer)
                                }
                            }
                            // O onChange não é mais necessário aqui.
                        }
                    }
                    
                    // --- Explicação ---
                    if quizVM.showExplanation {
                        HStack {
                            Text(question.explanation ?? "Sem explicações disponíveis.")
                                .padding()
                                .font(.caption)
                                .foregroundStyle(.black)
                                .background(Color.yellow)
                                .cornerRadius(16)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: 300)
                                .fixedSize(horizontal: false, vertical: true)
                                .withTranslateIcon {
                                    quizVM.textToTranslate = question.explanation ?? "Sem explicações disponíveis."
                                }
                        }
                        .padding(.top,50)
                        .padding(.trailing,30)
                    }
                    
                } else {
                    // --- Quiz Concluído ---
                    Spacer()
                    VStack {
                        Text("Quiz concluído!")
                        // ...
                        // Use quizVM.totalQuestionsCount
                        Text(
                            "Acertos: \(quizVM.correctQuestions) de \(quizVM.totalQuestionsCount)"
                        )
                        // ...
                    }
                    // ...
                    Spacer()
                }
                
                Spacer()
            }
            .animation(.easeInOut, value: quizVM.currentIndex)
            .foregroundStyle(.white)
            .background {
                Image("background")
            }
            // ⭐️ Alteração 3: Chama a busca de dados no .task ⭐️
            .task {
                await quizVM.fetchSeries()
            }
        }
    }
}
