//
//  Factory.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 22/12/25.
//

import Foundation
import Supabase

enum QuizViewModelFactory {
    @MainActor
    static func makeQuizViewModel() -> QuizViewModel {
        
        let client = SupabaseClient(
            supabaseURL: URL(string: "https://wwcvjftpyascuyzqtlnp.supabase.co")!,
            supabaseKey: "sb_publishable_EkATLv3QFXg-APhwAxUwkg_Qa6B5eRY"
        )
        
        let repository = SupabaseRepository(client: client)
        
        return QuizViewModel(repository: repository)
    }
}
