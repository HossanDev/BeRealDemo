//
//  NetworkServiceProtocol.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation

 protocol NetworkServiceProtocol {
    func request(from urlString: String) async throws -> Data
}
