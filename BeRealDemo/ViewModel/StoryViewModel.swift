//
//  StoryViewModel.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation

enum ViewState {
  case loading
  case error
  case loaded
  case loadingMore
}

protocol StoryListViewModelAction: ObservableObject {
  func getStoryList() async
  func loadMoreStory() async
}

@MainActor
final class StoryListViewModel: StoryListViewModelAction {
  
  @Published private(set) var viewState: ViewState = .loading
  @Published var storyList: [Result] = []
  private let repository: StoryRepositoryProtocol
  
  init(repository: StoryRepositoryProtocol) {
    self.repository = repository
  }
  
  func getStoryList() async {
    viewState = .loading
    do {
      let story = try await repository.fetchStory(from: Endpoint.baseURL)
      storyList = story.results
      viewState = .loaded
    } catch {
      viewState = .error
    }
  }
  
  func loadMoreStory() async {
    viewState = .loadingMore
    do {
      let story = try await repository.fetchStory(from: Endpoint.baseURL)
      storyList.append(contentsOf: story.results)
      viewState = .loaded
    } catch {
      viewState = .error
    }
  }
}

extension StoryListViewModel {
  
  func imageURL(for result: Result) -> URL? {
    URL(string: result.picture.large)
  }
  
  func shouldLoadMore(result: Result) -> Bool {
    guard let last = storyList.last else { return false }
    return last == result
  }
}
