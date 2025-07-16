//
//  StoryViewModelTests.swift
//  BeRealDemoTests
//
//  Created by MohammadHossan on 16/07/2025.
//

import XCTest
@testable import BeRealDemo

@MainActor
final class StoryListViewModelTests: XCTestCase {
  
  var mockRepository: MockStoryRepository?
  var viewModel: StoryListViewModel?
  
  override func setUp() {
    mockRepository = MockStoryRepository()
    viewModel = StoryListViewModel(repository: mockRepository ?? MockStoryRepository())
  }
  
  override func tearDown() {
    mockRepository = nil
    viewModel = nil
  }
  
  func test_getStoryList_success_updatesStoryListAndViewState() async {
    // MARK: - Given
    guard let viewModel else {
      XCTFail("ViewModel is nil")
      return
    }
    
    // MARK: - When
    await viewModel.getStoryList()
    
    // MARK: - Then
    XCTAssertEqual(viewModel.viewState, .loaded, "View state should be loaded on success")
    XCTAssertFalse(viewModel.storyList.isEmpty, "Story list should not be empty after successful fetch")
    XCTAssertEqual(viewModel.storyList.first?.name.first, "Elina")
  }
  
  func test_getStoryList_failure_setsErrorState() async {
    // MARK: - Given
    viewModel = StoryListViewModel(repository: FailingRepository())
    
    guard let viewModel else {
      XCTFail("ViewModel is nil")
      return
    }
    
    // MARK: - When
    await viewModel.getStoryList()
    
    // MARK: - Then
    XCTAssertEqual(viewModel.viewState, .error, "View state should be error on failure")
    XCTAssertTrue(viewModel.storyList.isEmpty, "Story list should be empty on failure")
  }
  
  func test_loadMoreStory_appendsDataAndUpdatesViewState() async {
    // MARK: - Given
    guard let viewModel else {
      XCTFail("ViewModel is nil")
      return
    }
    
    await viewModel.getStoryList()
    let originalCount = viewModel.storyList.count
    
    // MARK: - When
    await viewModel.loadMoreStory()
    
    // MARK: - Then
    XCTAssertEqual(viewModel.viewState, .loaded, "View state should be loaded after loading more")
    XCTAssertEqual(viewModel.storyList.count, originalCount * 2, "Story list should have appended more results")
  }
  
  func test_imageURL_returnsCorrectURL() {
    // MARK: - Given
    guard let viewModel else {
      XCTFail("ViewModel is nil")
      return
    }
    let result = Result(
      name: Name(title: "Mr", first: "John", last: "Doe"),
      id: ID(name: "ID", value: "123"),
      picture: Picture(
        large: "https://example.com/large.jpg",
        medium: "https://example.com/medium.jpg",
        thumbnail: "https://example.com/thumb.jpg"
      )
    )
    
    // MARK: - When
    let url = viewModel.imageURL(for: result)
    
    // MARK: - Then
    XCTAssertEqual(url?.absoluteString, "https://example.com/large.jpg")
  }
  
  func test_shouldLoadMore_returnsTrueForLastItem() async {
    // MARK: - Given
    guard let viewModel else {
      XCTFail("ViewModel is nil")
      return
    }
    await viewModel.getStoryList()
    
    guard let last = viewModel.storyList.last else {
      XCTFail("Expected story list to have items")
      return
    }
    
    // MARK: - When
    let shouldLoad = viewModel.shouldLoadMore(result: last)
    
    // MARK: - Then
    XCTAssertTrue(shouldLoad, "shouldLoadMore should be true for the last item")
  }
  
  func test_shouldLoadMore_returnsFalseForNonLastItem() async {
    // MARK: - Given
    guard let viewModel else {
      XCTFail("ViewModel is nil")
      return
    }
    await viewModel.getStoryList()
    
    guard viewModel.storyList.count > 1 else {
      XCTFail("Expected story list to have more than one item")
      return
    }
    let first = viewModel.storyList[0]
    
    // MARK: - When
    let shouldLoad = viewModel.shouldLoadMore(result: first)
    
    // MARK: - Then
    XCTAssertFalse(shouldLoad, "shouldLoadMore should be false for a non-last item")
  }
}
