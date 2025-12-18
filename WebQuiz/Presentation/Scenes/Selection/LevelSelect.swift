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

            // 🔹 Grid 3x3 (Levels)
            LazyVGrid(columns: columns, spacing: 20) {
                // Usamos as propriedades refatoradas da VM
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
                    }
                }
            }
            .padding(.horizontal)

            // Botão de último nível (Exemplo de lógica de segurança)
            if let lastLevel = quizVM.currentLevels.last, quizVM.currentLevels.count > 9 {
                HStack {
                    Button {
                        print("Você clicou no último nível: \(lastLevel.level_number)")
                    } label: {
                        Text("\(lastLevel.level_number)")
                            .font(.title3)
                            .padding()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.black)
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                }
            }

            Spacer()
        }
        // Chamada da função que refatoramos na VM
        .task {
            await quizVM.fetchLevelsData(forSeriesID: selectedSeries)
        }
        .padding()
        .background {
            Image("background")
                .ignoresSafeArea()
        }
    }
}
