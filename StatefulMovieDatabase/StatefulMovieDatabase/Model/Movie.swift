//
//  Movies.swift
//  StatefulMovieDatabase
//
//  Created by Matheus Oliveira on 10/13/22.
//

import Foundation
//creates a dictionary to represent the topLevlDic from the JSON data that comes back from the network request. Results match the key we need inside the topLevelDic
struct TopLevelDictionary: Decodable {
    let results: [Movie]
}
//changes the word we use to acess some specific keys in our jason data for something swift can read. (from snakecase to cammelCase idealy)
struct Movie: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case vote = "vote_average"
        case posterPath = "poster_path"
        case overview
    }
//    defines the data type each key will bring from the JSONData
    let title: String
    let vote: Double
    let posterPath: String?
    let overview: String
}
