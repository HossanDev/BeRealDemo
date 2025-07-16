//
//  ReactionView.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import SwiftUI

struct ReactionView: View {
  var onReactionSelected: (String) -> Void
  private let reactions = ["❤️", "👍", "😂", "😮", "😢", "👏"]
  
  @State private var scales: [CGFloat]
  
  init(onReactionSelected: @escaping (String) -> Void) {
    self.onReactionSelected = onReactionSelected
    _scales = State(initialValue: Array(repeating: 1.0, count: reactions.count))
  }
  
  var body: some View {
    HStack(spacing: 24) {
      ForEach(reactions.indices, id: \.self) { index in
        Text(reactions[index])
          .font(.largeTitle)
          .scaleEffect(scales[index])
          .onTapGesture {
            onReactionSelected(reactions[index])
          }
          .onAppear {
            withAnimation(
              Animation.easeInOut(duration: 0.8)
                .repeatForever()
                .delay(Double(index) * 0.2)
            ) {
              scales[index] = 1.3
            }
            withAnimation(
              Animation.easeInOut(duration: 0.8)
                .repeatForever()
                .delay(Double(index) * 0.2 + 0.4)
            ) {
              scales[index] = 1.0
            }
          }
      }
    }
    .padding()
  }
}

#Preview {
  ReactionView { reaction in
    print("Selected reaction: \(reaction)")
  }
}
