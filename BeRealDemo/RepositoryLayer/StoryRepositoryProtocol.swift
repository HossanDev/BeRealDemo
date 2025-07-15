//
//  StoryRepositoryProtocol.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation

protocol StoryRepositoryProtocol {
   func fetchStory(from urlString: String) async throws -> Story
}

