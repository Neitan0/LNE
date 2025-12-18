//
//  ContentView.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//

import SwiftUI


struct ContentView: View {
    @State private var navigationPath = NavigationPath()
    @State private var isVLibrasExpanded = false
    @State var quizVM: QuizViewModel
    var body: some View {
        ZStack {
            if isVLibrasExpanded == true {
                VLibrasWebView(textToTranslate: $quizVM.textToTranslate)
                    .frame(width: 210,height: 350)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                    .position(CGPoint(x: UIScreen.main.bounds.width * 0.70, y: UIScreen.main.bounds.height * 0.70))
                    .allowsHitTesting(false)
            }
            NavigationStack(path: $navigationPath) {
                VStack {
                   
                    VStack(spacing: 30) {
                        HStack {
                            Button{
                                quizVM.textToTranslate = "LNE"
                            } label: {
                                Image(systemName: "translate")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                                    .frame(width: 35, height: 35)
                                    .background(
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                            }
                            Text("LNE")
                                .bold()
                                .font(.system(size: 50))
                        }
                        .padding(.trailing, 30)
                        HStack {
                            Text("Laboratorio de novas experiências")
                                .bold()
                                .withTranslateIcon {
                                    quizVM.textToTranslate = "Laboratório de novas experiências"
                                }
                        }
                        .padding(.trailing, 30)
                    }
                    .padding(10)
                    HStack {
                        Button{
                            navigationPath.append(Destination.ChoseDifficulty)
                        } label: {
                            Text("COMEÇAR")
                                .padding(8)
                                .background(Color.green)
                                .cornerRadius(10)
                                .withTranslateIcon {
                                    quizVM.textToTranslate = "COMEÇAR"
                                }
                        }
                    }
                    .padding()
                    .padding(.trailing, 30)
                }
                .position(x: UIScreen.main.bounds.width / 2 , y: 250)
                .foregroundStyle(.white)
                .background{
                    Image("background")
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                .toolbar {
                    Button{
                        isVLibrasExpanded.toggle()
                    } label: {
                        Image("librasSymbol")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .bold()
                            .padding()
//                            .background(Circle().fill(.ultraThinMaterial).frame(width: 35, height: 35))
//                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1).frame(width: 35, height: 35))
                            .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                    }
                }
                .navigationDestination(for: Destination.self) { destination in
                    ViewFactory.makeView(for: destination, quizVM: quizVM, navigationPath: $navigationPath)
                }
                
                
            }
            
        }
        
    }
}

//#Preview {
//    ContentView()
//}
