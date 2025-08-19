//
//  ChoseDifficultyView.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//

import SwiftUI

struct ChoseDifficultyView: View {
    var quizVM: QuizViewModel
    @Binding var navigationPath: NavigationPath
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Escolha seu nivel de escolaridade!")
                        .bold()
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 5, x: 5, y:5)
                        .withTranslateIcon {
                            quizVM.textToTranslate = "Escolha seu nivel de escolaridade!"
                        }
                }
            }
            .padding(.top,30)
            VStack(spacing: 25) {
                HStack {
                    Button{
                        navigationPath.append(Destination.QuizView(Escolaridade: "NonoAno"))
                    } label: {
                        Text("Nono Ano")
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black, radius: 5, x: 5, y:5)
                            .withTranslateIcon {
                                quizVM.textToTranslate = "Nono Ano"
                            }
                    }
                }
                
                HStack {
                    Button{
                        navigationPath.append(Destination.QuizView(Escolaridade: "PrimeiroAno"))
                    } label: {
                        Text("Primeiro Ano")
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black, radius: 5, x: 5, y:5)
                            .withTranslateIcon {
                                quizVM.textToTranslate = "Primeiro Ano"
                            }
                    }
                }
                
                HStack {
                    Button{
                        navigationPath.append(Destination.QuizView(Escolaridade: "SegundoAno"))
                    } label: {
                        Text("Segundo Ano")
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black, radius: 5, x: 5, y:5)
                            .withTranslateIcon {
                                quizVM.textToTranslate = "Segundo Ano"
                            }
                    }
                }
                HStack {
                    Button{
                        navigationPath.append(Destination.QuizView(Escolaridade: "TerceiroAno"))
                    } label: {
                        Text("Terceiro Ano")
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black, radius: 5, x: 5, y:5)
                            .withTranslateIcon {
                                quizVM.textToTranslate = "Terceiro Ano"
                            }
                    }
                }
            }
            
            .padding(.top,25)
            
            Spacer()
        }
        .position(x: UIScreen.main.bounds.width / 2.1, y: 370)
//        .navigationBarBackButtonHidden(true)
        .foregroundStyle(.black)
        .background{
            Image("background")
        }
    }
}

#Preview {
    ChoseDifficultyView(quizVM: QuizViewModel(), navigationPath: .constant(NavigationPath()))
}
