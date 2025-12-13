//
//  LevelSelect.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 13/12/25.
//

import SwiftUI

struct LevelSelect: View {
    // ⭐️ 1. Injetar a QuizViewModel (para acesso ao estado) e a Série (para os níveis) ⭐️
    @Bindable var quizVM: QuizViewModel
    var selectedSeries: Series

    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)

    var body: some View {
        VStack(spacing: 30) {

            // Título usando o nome da série
            Text(selectedSeries.name)
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
            Text("Escolha o nível")
                .font(.title)
                .bold()

            // 🔹 Grid 3x3 (Levels)
            LazyVGrid(columns: columns, spacing: 20) {
                
                if let levels = selectedSeries.levels {
                    ForEach(levels) { level in
                        Button {
                            print("Clicou no nível: \(level.level_number)")
                        } label: {
                            LevelButton(level: level)
                        }
                    }
                }

            }
            .padding(.horizontal)

            // 🔹 Nível 10 centralizado (Exemplo)
            // Para isso funcionar, 'firstNineCompleted' precisa ser uma propriedade da VM
            // que monitora o progresso do usuário para esta série.
//            if quizVM.firstNineCompleted {
//                HStack {
//                    // Crie um botão para o nível 10
//                    Text("Nível 10")
//                }
//            }

            Spacer()
        }
        .padding()
        .foregroundStyle(.white)
        .background {
            Image("background")
        }
    }
}

// ⭐️ Componente auxiliar para o visual do botão (Melhora a clareza) ⭐️
struct LevelButton: View {
    var level: Level
    
    var body: some View {
        Text("\(level.level_number)") // Usando a propriedade 'level_name' do seu modelo
            .font(.headline)
            .frame(width: 80, height: 80)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}





//#Preview {
//    LevelSelect(quizVM: QuizViewModel(), selectedSeries: Series(id: 1, created_at: Date(), name: "Nono Ano", levels: <#T##[Level]?#>))
//}

