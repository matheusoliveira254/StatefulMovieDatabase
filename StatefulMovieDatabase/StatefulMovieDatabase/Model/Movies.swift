//
//  Movies.swift
//  StatefulMovieDatabase
//
//  Created by Matheus Oliveira on 10/13/22.
//

import Foundation

struct TopLevelDictionary: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case vote = "vote_average"
        case posterPath = "poster_path"
    }
    
    let title: String
    let vote: Double
    private let posterPath: String
}
