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
        supabaseURL: URL(string: "https://wwcvjftpyascuyzqtlnp.supabase.co")!,
        supabaseKey: "sb_publishable_EkATLv3QFXg-APhwAxUwkg_Qa6B5eRY"
    )

    var body: some Scene {
        WindowGroup {
            ContentView(quizVM: QuizViewModel(repository: SupabaseRepository(client: supabaseClient)))
        }
    }
}
