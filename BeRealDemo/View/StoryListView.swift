//
//  StoryListView.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import SwiftUI

struct StoryListView: View {
  // MARK: - Using State Object to make sure view model object will not destroyed or recreated.
  @StateObject var viewModel: StoryListViewModel
  @State private var isErrorOccured = true
  @State private var selectedResult: Result? = nil

  var body: some View {
    NavigationStack {
      VStack {
        switch viewModel.viewState {
        case .loading:
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded, .loadingMore:
          showStoryListView()
        case .error:
          showErrorView()
        }
      }
      .navigationTitle("Story")
      .navigationBarTitleDisplayMode(.inline)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .task {
        await viewModel.getStoryList()
      }
      .fullScreenCover(item: $selectedResult) { selected in
        if let index = viewModel.storyList.firstIndex(of: selected) {
          StoryViewerView(
            storyList: viewModel.storyList,
            currentIndex: index,
            onDismiss: {
              selectedResult = nil
            }
          )
        }
      }
    }
  }

  // MARK: - Using ViewBuilder to create the child view.
  @ViewBuilder
  func showErrorView() -> some View {
    ProgressView().alert(isPresented: $isErrorOccured) {
      Alert(
        title: Text("Error Occurred"),
        message: Text("Something went wrong"),
        dismissButton: .default(Text("Ok"))
      )
    }
  }

  @ViewBuilder
  func showStoryListView() -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(viewModel.storyList.indices, id: \.self) {
          let result = viewModel.storyList[$0]
          if let url = viewModel.imageURL(for: result) {
            StoryAsyncImageView(url: url)
              .frame(width: 100, height: 150)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(
                    LinearGradient(
                      colors: [.red, .orange, .yellow, .red],
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                  )
              )
              .padding(4)
              .onTapGesture {
                selectedResult = result
              }
              .onAppear {
                if viewModel.shouldLoadMore(result: result) {
                  Task {
                    await viewModel.loadMoreStory()
                  }
                }
              }

          } else {
            Image(systemName: "xmark.octagon.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 250, height: 250)
          }
        }

        if viewModel.viewState == .loadingMore {
          ProgressView()
            .frame(width: 50, height: 50)
        }
      }
    }
    .padding()
  }
}

#Preview {
  StoryListView(viewModel: StoryListViewModel(repository: StoryRepository(networkService: NetworkManager())))
}
