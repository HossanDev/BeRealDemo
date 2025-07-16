//
//  MockStoryRepository.swift
//  BeRealDemoTests
//
//  Created by MohammadHossan on 16/07/2025.
//

import Foundation
@testable import BeRealDemo

class MockStoryRepository: StoryRepositoryProtocol {
  func fetchStory(from urlString: String) async throws -> BeRealDemo.Story {
    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: "MockData", withExtension: "json") else {
      throw NetworkError.invalidURL("MockData")
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(Story.self, from: data)
  }
}
