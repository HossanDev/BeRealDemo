//
//  StoryRepositoryTests.swift
//  BeRealDemoTests
//
//  Created by MohammadHossan on 15/07/2025.
//

import XCTest
@testable import BeRealDemo

final class StoryRepositoryTests: XCTestCase {
  
  var mockNetworkManager: MockNetworkManager?
  var storyRepository: StoryRepositoryProtocol?
  
  override func setUpWithError() throws {
    // Given: Setup mock network manager and repository before each test
    mockNetworkManager = MockNetworkManager()
    storyRepository = StoryRepository(networkService: mockNetworkManager ?? MockNetworkManager())
  }
  
  override func tearDownWithError() throws {
    // Cleanup after each test
    mockNetworkManager = nil
    storyRepository = nil
  }
  
  func test_Get_Story_In_Success_Case() async throws {
    // Given: A valid story repository with mock data
    guard let repo = storyRepository else {
      XCTFail("StoryRepository is nil")
      return
    }
    
    // When: Fetch story from "MockData" JSON file
    let story = try await repo.fetchStory(from: "MockData")
    
    // Then: Validate the returned story has expected info and user data
    XCTAssertEqual(story.results.count, 2, "Expected exactly 1 result in the story")
    XCTAssertEqual(story.info.results, 2, "Expected 10 results in info")
    XCTAssertEqual(story.info.page, 1, "Expected page number 1")
    XCTAssertEqual(story.info.version, "1.3", "Expected API version 1.3")
    XCTAssertEqual(story.info.seed, "foobar", "Expected seed value 'foobar'")
    
    let user = story.results[0]
    
    XCTAssertEqual(user.name.title, "Ms")
    XCTAssertEqual(user.name.first, "Elina")
    XCTAssertEqual(user.name.last, "Pasanen")
    
    XCTAssertEqual(user.id.name, "FI")
    XCTAssertEqual(user.id.value, "310123-123A")
    
    XCTAssertEqual(user.picture.large, "https://randomuser.me/api/portraits/women/5.jpg")
    XCTAssertEqual(user.picture.medium, "https://randomuser.me/api/portraits/med/women/5.jpg")
    XCTAssertEqual(user.picture.thumbnail, "https://randomuser.me/api/portraits/thumb/women/5.jpg")
  }
  
  func test_FetchStory_InvalidURL_ThrowsError() async {
    // Given: A repository set up with mock network manager
    guard let repo = storyRepository else {
      XCTFail("StoryRepository is nil")
      return
    }
    
    // When: Attempt to fetch from a non-existent JSON file
    do {
      _ = try await repo.fetchStory(from: "NonExistentFile")
      XCTFail("Expected fetchStory to throw for invalid URL but it succeeded")
    } catch {
      // Then: It should throw NetworkError.invalidURL with the correct file name
      if let networkError = error as? NetworkError {
        switch networkError {
        case .invalidURL(let urlString):
          XCTAssertEqual(urlString, "NonExistentFile")
        default:
          XCTFail("Expected invalidURL error but got \(networkError)")
        }
      } else {
        XCTFail("Expected NetworkError but got \(error)")
      }
    }
  }
  
  func test_FetchStory_EmptyResults_Success() async throws {
    // Given: A repository with mock data containing empty results array
    guard let repo = storyRepository else {
      XCTFail("StoryRepository is nil")
      return
    }
    
    // When: Fetch story from "EmptyResults" JSON file
    let story = try await repo.fetchStory(from: "EmptyResults")
    
    // Then: The results array should be empty, and info fields should match expected values
    XCTAssertTrue(story.results.isEmpty, "Expected results to be empty")
    XCTAssertEqual(story.info.results, 0, "Expected info.results to be 0")
    XCTAssertEqual(story.info.page, 1, "Expected page number to be 1")
    XCTAssertEqual(story.info.version, "1.3", "Expected version to be 1.3")
    XCTAssertEqual(story.info.seed, "foobar", "Expected seed to be 'foobar'")
  }
}
