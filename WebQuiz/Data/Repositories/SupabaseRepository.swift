//
//  SupabaseClient.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 13/12/25.
//
import Foundation
import Supabase

class SupabaseRepository: QuizRepositoryProtocol {
    
    private let client: SupabaseClient

    init(client: SupabaseClient) {
        self.client = client
    }

    func fetchSeries() async throws -> [Series] {
        do {
            let response: [Series] = try await client
                .from("series")
                .select()
                .execute()
                .value
            
            guard !response.isEmpty else { throw RepositoryError.emptyData }
            return response
        } catch {
            throw RepositoryError.networkError(error.localizedDescription)
        }
    }

    func fetchLevels(forSeriesID seriesID: Int) async throws -> [Level] {
        do {
            return try await client
                .from("levels")
                .select()
                .eq("serie_id", value: seriesID)
                .order("level_number", ascending: true)
                .execute()
                .value
        } catch {
            throw RepositoryError.networkError(error.localizedDescription)
        }
    }

    func fetchQuizData(forLevelID levelID: Int) async throws -> [Question] {
        do {
            // 3. Tipagem Forte: Definimos explicitamente o que esperamos receber
            let questions: [Question] = try await client
                .from("questions")
                .select("*, answers(*)")
                .eq("level_id", value: levelID)
                .execute()
                .value
            return questions
        } catch {
            print("❌ Erro Supabase: \(error)")
            throw RepositoryError.networkError("Não foi possível carregar o quiz.")
        }
    }
}
