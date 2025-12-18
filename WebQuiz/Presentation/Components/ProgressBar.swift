//
//  ProgressBar.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/08/25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat// valor entre 0.0 e 1.0

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 20)
                    .foregroundColor(.gray.opacity(0.5))
                
                Capsule()
                    .frame(width: progress * 250, height: 20)
                    .foregroundColor(colorForProgress(progress))
                    .animation(.easeInOut, value: progress)
                
                
            }
            .frame(width: 250)
        }
//        .border(.black)
    }
    func colorForProgress(_ progress: CGFloat) -> Color {
        // Interpola entre vermelho (1.0, 0.0, 0.0) e verde (0.0, 1.0, 0.0)
        let red = 1.0 - progress
        let green = progress
        return Color(red: red, green: green, blue: 0.0)
    }
}


#Preview {
    ProgressBar(progress: 0.7)
}
