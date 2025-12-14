//
//  SupabaseClient.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 13/12/25.
//

import Foundation
import Supabase


protocol SupabaseRepositoryProtocol {
    func fetchSeries() async throws -> [Series]
    func fetchLevels(forSeriesID seriesID: Int) async throws -> [Level]
    func fetchQuizData(forLevelID levelID: Int) async throws -> [Question]
}

class SupabaseRepository: SupabaseRepositoryProtocol {
    
    // Supabase client configuration using default Auth storage and options
    let SupaClient = SupabaseClient(
         supabaseURL: URL(string: "https://wwcvjftpyascuyzqtlnp.supabase.co")!,
         supabaseKey: "sb_publishable_EkATLv3QFXg-APhwAxUwkg_Qa6B5eRY"
     )

    // 1. Fetch das SÉRIES (Tela principal)
        func fetchSeries() async throws -> [Series] {
            return try await SupaClient
                .from("series")
                .select() // Pega apenas a Series (id, name, created_at)
                .execute()
                .value
        }

        // 2. Fetch dos LEVELS (Tela LevelSelect)
        // Você precisa do ID da série para filtrar os níveis
        func fetchLevels(forSeriesID seriesID: Int) async throws -> [Level] {
            return try await SupaClient
                .from("levels")
                .select() // Pega Levels, filtrando pela Chave Estrangeira 'serie_id'
                .eq("serie_id", value: seriesID)
                .order("level_number", ascending: true) // Ordena para garantir a ordem (1, 2, 3...)
                .execute()
                .value
        }

        // 3. Fetch das QUESTÕES e RESPOSTAS (Tela QuizView)
        // Você precisa do ID do nível para pegar as questões e as respostas
        func fetchQuizData(forLevelID levelID: Int) async throws -> [Question] {
            // Junção específica: Pega Questões e, embutido, suas Respostas
            return try await SupaClient
                .from("questions")
                .select("*, answers(*)") // Junção para incluir as respostas
                .eq("level_id", value: levelID) // Filtra pela Chave Estrangeira 'level_id'
                .execute()
                .value
        }
    
}
