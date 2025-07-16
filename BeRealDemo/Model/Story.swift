//
//  Story.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

struct Story: Codable, Hashable {
    let results: [Result]
    let info: Info
}

// MARK: - Info
struct Info: Codable, Hashable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
struct Result: Codable, Hashable, Identifiable {
    let name: Name
    let id: ID
    let picture: Picture
}

// MARK: - ID
struct ID: Codable, Hashable {
    let name: String
    let value: String?
}


// MARK: - Name
struct Name: Codable, Hashable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable, Hashable {
    let large, medium, thumbnail: String
}
