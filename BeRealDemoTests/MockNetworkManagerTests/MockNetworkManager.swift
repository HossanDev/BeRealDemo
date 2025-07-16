//
//  MockNetworkManager.swift
//  BeRealDemoTests
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation
@testable import BeRealDemo

class MockNetworkManager: NetworkServiceProtocol {
  func request(from urlString: String) async throws -> Data {
    guard let fileName = URL(string: urlString)?.lastPathComponent else {
      throw NetworkError.invalidURL(urlString)
    }
    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
      throw NetworkError.invalidURL(fileName)
    }
    
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      throw NetworkError.invalidResponse
    }
  }
}
