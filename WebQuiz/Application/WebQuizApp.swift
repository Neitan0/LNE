//
//  WebQuizApp.swift
//  WebQuiz
//
//  Created by Natanael nogueira on 06/07/25.
//
import SwiftUI
import Supabase

@main
struct WebQuizApp: App {
    let supabaseClient = SupabaseClient(
        supabaseURL: URL(string: "https://seu-projeto.supabase.co")!,
        supabaseKey: "SUA_KEY"
    )

    var body: some Scene {
        WindowGroup {
            ContentView(quizVM: QuizViewModel(repository: SupabaseRepository(client: supabaseClient)))
        }
    }
}
