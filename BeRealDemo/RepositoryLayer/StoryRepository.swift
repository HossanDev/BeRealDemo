//
//  StoryRepository.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation

struct StoryRepository: StoryRepositoryProtocol {
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol = NetworkManager()) {
    self.networkService = networkService
  }
  
  func fetchStory(from urlString: String) async throws -> Story {
    try await fetch(from: urlString)
  }
  
  private func fetch<T: Decodable>(from urlString: String) async throws -> T {
    let data = try await networkService.request(from: urlString)
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingFailed(error)
    }
  }
}
