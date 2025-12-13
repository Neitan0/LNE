//
//  SupabaseClient.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 13/12/25.
//

import Foundation
import Supabase


protocol SupabaseRepositoryProtocol {
    func fetchAllDataDeepJoin() async throws -> [Series]
}

class SupabaseRepository: SupabaseRepositoryProtocol {
    // Supabase client configuration using default Auth storage and options
    let SupaClient = SupabaseClient(
         supabaseURL: URL(string: "https://wwcvjftpyascuyzqtlnp.supabase.co")!,
         supabaseKey: "sb_publishable_EkATLv3QFXg-APhwAxUwkg_Qa6B5eRY"
     )

    func fetchAllDataDeepJoin() async throws -> [Series] {
        // 2. Crie a string de SELECT aninhada:
        // Começa na tabela 'series' (o tipo de retorno principal)
        let deepSelectQuery = SupaClient.from("series")
            .select("""
                *, 
                levels(
                    *, 
                    questions(
                        *, 
                        answers(*)
                    )
                )
            """)
            
        // 3. Execute e Decodifique no tipo principal: [Series]
        let allSeries: [Series] = try await deepSelectQuery
            .execute()
            .value
        
        
        return allSeries
//        // 4. Use os dados (tudo está carregado em 'allSeries'):
//        print("Total de Séries carregadas: \(allSeries.count)")
//        
//        if let firstSeries = allSeries.first,
//           let firstLevel = firstSeries.levels?.first,
//           let firstQuestion = firstLevel.questions?.first {
//            
//            print("\nPrimeira Série: \(firstSeries.name)")
//            print("Primeiro Nível: \(firstLevel.level_number)")
//            print("Primeira Questão: \(firstQuestion.question)")
//            print("Total de Respostas para esta Questão: \(firstQuestion.answers?.count ?? 0)")
//        }
    }
    
}
