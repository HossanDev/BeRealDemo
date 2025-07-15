//
//  BeRealDemoApp.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import SwiftUI

@main
struct BeRealDemoApp: App {
    var body: some Scene {
        WindowGroup {
          StoryListView(viewModel: StoryListViewModel(repository: StoryRepository(networkService: NetworkManager())))
        }
    }
}
