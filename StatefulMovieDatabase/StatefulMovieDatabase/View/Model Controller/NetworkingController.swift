//
//  NetworkingController.swift
//  StatefulMovieDatabase
//
//  Created by Matheus Oliveira on 10/13/22.
//

import Foundation

class NetworkingController {
    
    private static let baseURL = "https://api.themoviedb.org/3/search"
    private static let kMovieComponent = "/movie"
    private static let kTvShowComponent = "tv"
    private static let kApiKeyKey = "api_key"
    private static let apiKey = "bfb9225fcd93091f6a7e19e6e22a3b59"
    private static let movieNameQuery = "query"
    
    static func fetchMovie(with searchedMovie: String, completion: @escaping (Result<[Movie], ResultError>) -> Void) {
        guard let url = URL(string: baseURL) else {return}
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.path = kMovieComponent
        let apiQuery = URLQueryItem(name: kApiKeyKey, value: apiKey)
        let movieQuery = URLQueryItem(name: movieNameQuery, value: searchedMovie)
        urlComponents?.queryItems = [apiQuery, movieQuery]
        
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL(url))); return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error {
                print("There was a problem fetching the data from \(finalURL)")
                completion(.failure(.thrownError(error)))
                return
            }
            guard let movieData = data else {print("❌Something went wrong with the data!"); completion(.failure(.noData)); return}
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: movieData)
                let movie = topLevelDictionary.results
            } catch {
                print("❌Unable to decode!")
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }//end of the func
}//End of the class

//https://api.themoviedb.org/3/search/movie?api_key=bfb9225fcd93091f6a7e19e6e22a3b59&query=jaws
