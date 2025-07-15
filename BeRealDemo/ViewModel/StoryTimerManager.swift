//
//  StoryTimerManager.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation
import Combine

@MainActor
final class StoryTimerManager: ObservableObject {
  
  @Published var progress: CGFloat = 0
  private var timer: Timer?
  private let storyDuration: TimeInterval
  private let onComplete: () -> Void
  
  init(storyDuration: TimeInterval = 5, onComplete: @escaping () -> Void) {
    self.storyDuration = storyDuration
    self.onComplete = onComplete
  }
  
  func start() {
    stop()
    progress = 0
    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      Task { @MainActor in 
      self.progress += 0.01 / CGFloat(self.storyDuration)
        if self.progress >= 1 {
          self.stop()
          self.onComplete()
        }
      }
    }
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
  }
}
