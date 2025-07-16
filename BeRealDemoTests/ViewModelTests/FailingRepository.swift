//
//  FailingRepository.swift
//  BeRealDemoTests
//
//  Created by MohammadHossan on 16/07/2025.
//

import Foundation
@testable import BeRealDemo

class FailingRepository: StoryRepositoryProtocol {
  func fetchStory(from urlString: String) async throws -> BeRealDemo.Story {
    throw NetworkError.invalidURL(urlString)
  }
}
