//
//  StoryViewerView.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import SwiftUI

struct StoryViewerView: View {
  
  let storyList: [Result]
  var onDismiss: () -> Void
  @State var currentIndex: Int
  @StateObject private var timerManager: StoryTimerManager
  
  @State private var showingReactions = false
  @State private var selectedReaction: String? = nil
  
  init(storyList: [Result], currentIndex: Int, onDismiss: @escaping () -> Void) {
    self.storyList = storyList
    self._currentIndex = State(initialValue: currentIndex)
    self.onDismiss = onDismiss
    
    _timerManager = StateObject(wrappedValue: StoryTimerManager {
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: .storyTimerCompleted, object: nil)
      }
    })
  }
  
  var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        topSection
        bottomSection
          .padding(.top, 20)
      }
      .frame(width: geo.size.width, height: geo.size.height)
      .background(Color.black)
      .edgesIgnoringSafeArea(.all)
      .onAppear {
        timerManager.start()
        NotificationCenter.default.addObserver(forName: .storyTimerCompleted, object: nil, queue: .main) { _ in
          dismissViewer()
        }
      }
      .onDisappear {
        timerManager.stop()
        NotificationCenter.default.removeObserver(self, name: .storyTimerCompleted, object: nil)
      }
      .onChange(of: currentIndex) { _, _ in
        timerManager.start()
        withAnimation {
          showingReactions = false
        }
      }
      .gesture(
        LongPressGesture(minimumDuration: 1.0)
          .onEnded { _ in
            withAnimation {
              showingReactions = true
            }
          }
      )
      .overlay {
        if showingReactions {
          VStack {
            Spacer()
            ReactionView { reaction in
              selectedReaction = reaction
              print("User reacted with: \(reaction)")
              withAnimation {
                showingReactions = false
              }
            }
            .padding(.bottom, 110)
            .transition(.move(edge: .bottom).combined(with: .opacity))
          }
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation {
              showingReactions = false
            }
          }
          .zIndex(2)
        }
      }
    }
    .background(Color.black)
  }
  
  // MARK: - Top Section
  private var topSection: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 60)
      
      ProgressView(value: min(max(timerManager.progress, 0), 1))
        .progressViewStyle(LinearProgressViewStyle(tint: .white))
        .frame(height: 4)
        .padding(.horizontal)
      
      HStack {
        let name = storyList[currentIndex].name
        Text("\(name.first) \(name.last)")
          .font(.headline)
          .foregroundColor(.white)
          .padding(.leading)
        
        Spacer()
        
        Button(action: {
          dismissViewer()
        }) {
          Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .padding(.trailing)
        }
      }
      .padding(.vertical, 8)
      .background(Color.black.opacity(0.4))
    }
  }
  
  // MARK: - Bottom Section
  private var bottomSection: some View {
    ZStack {
      if let url = URL(string: storyList[currentIndex].picture.large) {
        StoryAsyncImageView(
          url: url,
          imageWidth: UIScreen.main.bounds.width,
          imageHeight: nil,
          applyTrailingPadding: false
        )
        .frame(maxWidth: .infinity)
      } else {
        Color.gray
      }
      
      HStack {
        Color.clear
          .contentShape(Rectangle())
          .onTapGesture {
            previousStory()
          }
        Color.clear
          .contentShape(Rectangle())
          .onTapGesture {
            nextStory()
          }
      }
    }
  }
  
  // MARK: - Story Navigation
  private func nextStory() {
    timerManager.stop()
    if currentIndex < storyList.count - 1 {
      currentIndex += 1
    } else {
      dismissViewer()
    }
  }
  
  private func previousStory() {
    timerManager.stop()
    if currentIndex > 0 {
      currentIndex -= 1
    }
  }
  
  private func dismissViewer() {
    timerManager.stop()
    DispatchQueue.main.async {
      onDismiss()
    }
  }
}

// Notification for timer completion
extension Notification.Name {
  static let storyTimerCompleted = Notification.Name("storyTimerCompleted")
}

#Preview {
  StoryViewerView(storyList: Result.mockStoryList, currentIndex: 0, onDismiss: {})
}
