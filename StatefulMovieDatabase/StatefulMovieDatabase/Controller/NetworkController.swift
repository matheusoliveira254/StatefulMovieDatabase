//
//  NetworkController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import Foundation
import UIKit.UIImage

class NetworkController {
    static let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie?")
    
    static func fetchMovieWith(searchTerm: String, completion: @escaping (Result<TopLevelDictionary, NetworkError>) -> Void) {
        
        guard let url = baseURL else { return }
        
        let apiKey = URLQueryItem(name: "api_key", value: "1622677c9c625ef4e4e27c015befec5f")
        let searchKey = URLQueryItem(name: "query", value: searchTerm)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [apiKey, searchKey]
        
        guard let finalURL = urlComponents?.url else { completion(.failure(.badURL(urlComponents?.url))); return }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }
            guard let data = data else { completion(.failure(.couldNotUnwrap)); return}
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(.success(topLevelDictionary))
            } catch let error {
                completion(.failure(.errorDecoding(error)))
            }
        }.resume()
    }
    
    static func fetchImage(with posterPath: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let posterBaseURL = URL(string:"http://image.tmdb.org/t/p/w500") else {return}
        let imageURL = posterBaseURL.appendingPathComponent(posterPath)
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            
            if let error = error {
                completion(.failure(.errorDecoding(error)))
            }
            
            guard let data = data else {completion(.failure(.couldNotUnwrap)); return}
            
            guard let image = UIImage(data: data) else { completion(.failure(.couldNotUnwrap)); return}
            completion(.success(image))
        }.resume()
    }
}
