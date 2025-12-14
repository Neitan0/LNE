//
//  LevelSelect.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 13/12/25.
//

import SwiftUI

struct LevelSelect: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var quizVM: QuizViewModel
    var selectedSeries: Int

    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)

    var body: some View {
        VStack(spacing: 30) {

            Text("Escolha o nível")
                .font(.title3)
                .bold()
                .padding()
                .foregroundStyle(.black)
                .background(Color.white)
                .cornerRadius(16)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)

            // 🔹 Grid 3x3 (Levels)
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(quizVM.currentLevels.prefix(9)) { level in
                    Button {
                        navigationPath.append(
                            Destination.QuizView(Level: level.id)
                        )
                    } label: {
                        Text("\(level.level_number)")
                            .font(.title3)
                            .padding()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.black)
                            .background(Color.white)
                            .cornerRadius(16)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)

                    }
                }
            }
            .padding(.horizontal)
            if true {
                HStack {
                    Button {
                        print(
                            "voce clicou no numero: \(quizVM.currentLevels.last?.level_number ?? 0) "
                        )
                    } label: {
                        Text("\(quizVM.currentLevels.last?.level_number ?? 0)")
                            .font(.title3)
                            .padding()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.black)
                            .background(Color.white)
                            .cornerRadius(16)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }

                }
            }

            Spacer()
        }
        .task {
               await quizVM.fetchLevelsData(forSeriesID: selectedSeries)
        }
        .padding()
        .foregroundStyle(.white)
        .background {
            Image("background")
        }
    }
}

//#Preview {
//    LevelSelect(quizVM: QuizViewModel(), selectedSeries: Series(id: 1, created_at: Date(), name: "Nono Ano", levels: <#T##[Level]?#>))
//}
//
//
//#Preview {
//    // MARK: - Mock Answers
//    let answers = [
//        Answer(id: 1, question_id: 1, answer: "Resposta A", is_correct: false),
//        Answer(id: 2, question_id: 1, answer: "Resposta B", is_correct: true),
//        Answer(id: 3, question_id: 1, answer: "Resposta C", is_correct: false),
//        Answer(id: 4, question_id: 1, answer: "Resposta D", is_correct: false)
//    ]
//
//    // MARK: - Mock Questions
//    let questions = [
//        Question(
//            id: 1,
//            created_at: Date(),
//            question: "Quanto é 2 + 2?",
//            explanation: "Soma básica",
//            level_id: 1,
//            levels: nil,
//            answers: answers
//        )
//    ]
//
//    // MARK: - Mock Levels
//    let levels = (1...10).map { number in
//        Level(
//            id: number,
//            created_at: Date(),
//            level_number: number,
//            serie_id: 1,
//            series: nil,
//            questions: questions
//        )
//    }
//
//    // MARK: - Mock Series
//    let series = Series(
//        id: 1,
//        created_at: Date(),
//        name: "Nono Ano",
//        levels: levels
//    )
//
//    // MARK: - Preview View
//    LevelSelect(
//        navigationPath: <#Binding<NavigationPath>#>, quizVM: QuizViewModel(),
//        selectedSeries: series
//    )
//}
