//
//  WebQuizTests.swift
//  WebQuizTests
//
//  Created by Natanael nogueira on 06/07/25.
//

import Testing
import Supabase
import Foundation

// Tabela 'series'
struct Series: Codable {
    let id: Int
    let created_at: Date? // Pode ser String ou Date
    let name: String
    var levels: [Level]?
}

// Tabela 'levels'
struct Level: Codable {
    let id: Int
    let created_at: Date?
    let level_number: Int
    let serie_id: Int // Chave estrangeira
    
    // Relacionamento: Nível pertence a uma Série
    var series: Series? // Para carregar a série (Join)
    var questions: [Question]?
}

// Tabela 'questions'
struct Question: Codable {
    let id: Int
    let created_at: Date?
    let question: String
    let explanation: String?
    let level_id: Int
    
    // Relacionamento: Questão pertence a um Nível
    var levels: Level? // Para carregar o nível (Join)
    
    // Relacionamento: Resposta pertence a uma Questão
    var answers: [Answer]? // Para carregar as respostas (Join)
}

// Tabela 'answers'
struct Answer: Codable {
    let id: Int
    let question_id: Int // Chave estrangeira
    let answer: String
    let is_correct: Bool
}

struct WebQuizTests {
    let SupaClient = SupabaseClient(supabaseURL: URL(string: "https://wwcvjftpyascuyzqtlnp.supabase.co")!, supabaseKey: "sb_publishable_EkATLv3QFXg-APhwAxUwkg_Qa6B5eRY")
    
    @Test func fetchAnswersTest() async throws {
        do {
            let repostas: [Answer] = try await SupaClient.from("answers").select("*").execute().value
            print(repostas.first!.answer)
        } catch {
            print(error)
        }
    }

    @Test func fetchAllDataDeepJoin() async throws {
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
        
        // 4. Use os dados (tudo está carregado em 'allSeries'):
        print("Total de Séries carregadas: \(allSeries.count)")
        
        if let firstSeries = allSeries.first,
           let firstLevel = firstSeries.levels?.first,
           let firstQuestion = firstLevel.questions?.first {
            
            print("\nPrimeira Série: \(firstSeries.name)")
            print("Primeiro Nível: \(firstLevel.level_number)")
            print("Primeira Questão: \(firstQuestion.question)")
            print("Total de Respostas para esta Questão: \(firstQuestion.answers?.count ?? 0)")
        }
    }

}


class SupabaseClients {
    
    
    let SupaClient = SupabaseClient(supabaseURL: URL(string: "https://xyzcompany.supabase.co")!, supabaseKey: "sb_publishable_EkATLv3QFXg-APhwAxUwkg_Qa6B5eRY")
    
    
    
   @Test func fetchAnswers() async {
        do {
           let repostas = try await SupaClient.from("answers").select("*").execute()
            print(repostas)
        } catch {
            print(error)
        }
    }
    
}
