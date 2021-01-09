//
//  Movie.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 29/12/2020.
//

import Foundation

struct Movie: Codable {
    var originalTitle: String?
}

struct MovieListResponse: Codable {
    var results: [Movie]?
}
