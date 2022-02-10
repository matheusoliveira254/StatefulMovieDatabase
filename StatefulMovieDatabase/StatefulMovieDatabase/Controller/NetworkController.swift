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
    
    static func fetchMovieWith(searchTerm: String, completion: @escaping ([Movie]?) -> Void) {
        
        guard let url = baseURL else { completion(nil); return }
        
        let apiKey = URLQueryItem(name: "api_key", value: "1622677c9c625ef4e4e27c015befec5f")
        let searchKey = URLQueryItem(name: "query", value: searchTerm)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [apiKey, searchKey]
        
        guard let finalURL = urlComponents?.url else { completion(nil); return }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion([])
                return
            }
            
            guard let data = data,
                  let responseDataString = String(data: data, encoding: .utf8) else { print("No data return from network request"); completion([]); return }
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                
                guard let movieArray = jsonDictionary?["results"] as? [[String:Any]] else { print("Unable to serialize JSON. Response: \(responseDataString)"); completion([]); return }
                
                let movies = movieArray.compactMap({ Movie(dictionary: $0) })
                completion(movies)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    static func image(forURL url: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = URL(string: url) else {
            fatalError("Image URL optional is nil")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
