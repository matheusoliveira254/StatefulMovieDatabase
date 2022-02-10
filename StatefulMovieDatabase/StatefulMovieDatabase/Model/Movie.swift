//
//  Movie.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import Foundation

struct TopLevelDictionary: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case rating = "vote_average"
        case overview
        case posterPath = "poster_path"
    }
    let title: String
    let rating: Double
    let overview: String
    let posterPath: String?
}

