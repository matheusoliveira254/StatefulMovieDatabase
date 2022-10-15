//
//  NetworkingController.swift
//  StatefulMovieDatabase
//
//  Created by Matheus Oliveira on 10/13/22.
//

import UIKit

class NetworkingController {
    //Keys and components to form the url
    private static let baseURL = "https://api.themoviedb.org/3/search/movie"
    private static let kTvShowComponent = "tv"
    private static let kApiKeyKey = "api_key"
    private static let apiKey = "bfb9225fcd93091f6a7e19e6e22a3b59"
    private static let movieNameQuery = "query"
    
    //func that will perform the task of putting together the url and checking for the data
    static func fetchMovie(with searchedMovie: String, completion: @escaping (Result<TopLevelDictionary, ResultError>) -> Void) {
        //checking to see if a url can be created from baseURL
        guard let url = URL(string: baseURL) else {return}
        //query items
        let apiQuery = URLQueryItem(name: kApiKeyKey, value: apiKey)
        let movieQuery = URLQueryItem(name: movieNameQuery, value: searchedMovie)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        //combining the query items with the url
        urlComponents?.queryItems = [apiQuery, movieQuery]
        // assigning the value of the url in url components to final url
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL(url))); return}
        print(finalURL)
        //checking for data, response or an error and handling the error.
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error {
                print("There was a problem fetching the data from \(finalURL)")
                completion(.failure(.thrownError(error)))
                return
            }
            //checking if data came back from the url finalURL
            guard let movieData = data else {print("❌Something went wrong with the data!"); completion(.failure(.noData)); return}
            
            do {
                //trying to decode the data that was passed from the url as TopLevelDictionary in the model
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: movieData)
                //completing the fun with success
                completion(.success(topLevelDictionary))
            } catch {
                print("❌Unable to decode!")
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }//end of the func
    
    static func fetchImage(with posterPath: String, completion: @escaping (Result<UIImage, ResultError>) -> Void) {
        //checking to see if a url
        guard let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500") else {return}
        //appending whatever searched by the user as a path component to the base url for images
        let imageURL = imageBaseURL.appendingPathComponent(posterPath)
        //checking for data, response or an error from that imageURL
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            //handling the error
            if let error {
                completion(.failure(.unableToDecode))
            }
            //making sure the data was received from that url
            guard let data = data else {completion(.failure(.noData)); return}
            //checking to see if the a UIImage can be created from the data received and completing with either success or failure
            guard let movieImage = UIImage(data: data) else {completion(.failure(.noData)); return}
            completion(.success(movieImage))
        }.resume()
        
    }//End of Image func
}//End of the class

//https://api.themoviedb.org/3/search/movie?api_key=bfb9225fcd93091f6a7e19e6e22a3b59&query=jaws
