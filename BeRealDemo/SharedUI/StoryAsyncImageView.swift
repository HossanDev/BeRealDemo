//
//  StoryAsyncImageView.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import SwiftUI

struct StoryAsyncImageView: View {
  let url: URL
  var imageWidth: CGFloat? = nil
  var imageHeight: CGFloat? = nil
  var applyTrailingPadding: Bool = false
  
  var body: some View {
    CacheAsyncImage(url: url) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: imageWidth, height: imageHeight)
          .clipped()
      case .failure:
        Image(systemName: "camera")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: imageWidth, height: imageHeight)
          .clipped()
      case .empty:
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .red))
          .frame(width: imageWidth, height: imageHeight)
      @unknown default:
        Image(systemName: "camera")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: imageWidth, height: imageHeight)
          .clipped()
      }
    }
  }
}

