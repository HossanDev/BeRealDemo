//
//  Extension.swift
//  BeRealDemo
//
//  Created by MohammadHossan on 15/07/2025.
//

import Foundation
extension Result {
  static let sample1 = Result(
    name: Name(title: "Mr",
               first: "John",
               last: "Doe"),
    id: ID(name: "SSN",
           value: "123-45-6789"),
    picture: Picture(
      large: "https://randomuser.me/api/portraits/men/1.jpg",
      medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
      thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
    )
  )
  
  static let sample2 = Result(
    name: Name(title: "Ms",
               first: "Jane",
               last: "Smith"),
    id: ID(name: "SSN",
           value: "987-65-4321"),
    picture: Picture(
      large: "https://randomuser.me/api/portraits/women/2.jpg",
      medium: "https://randomuser.me/api/portraits/med/women/2.jpg",
      thumbnail: "https://randomuser.me/api/portraits/thumb/women/2.jpg"
    )
  )
  
  static let sample3 = Result(
    name: Name(title: "Mrs",
               first: "Emily",
               last: "Johnson"),
    id: ID(name: "SSN", value:
            "567-89-0123"),
    picture: Picture(
      large: "https://randomuser.me/api/portraits/women/3.jpg",
      medium: "https://randomuser.me/api/portraits/med/women/3.jpg",
      thumbnail: "https://randomuser.me/api/portraits/thumb/women/3.jpg"
    )
  )
  
  static let mockStoryList = [sample1, sample2, sample3]
}
