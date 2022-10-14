//
//  UIIMageViewExtension.swift
//  StatefulMovieDatabase
//
//  Created by Matheus Oliveira on 10/14/22.
//

import UIKit

extension UIImageView {
    
    //Func created to create an image from a URL
    func loadImageFrom(imageURL: String?) {
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        guard let imageURL = imageURL else {return}
        guard let url = URL(string: baseImageURL + imageURL) else {return}
        
        URLSession.shared.dataTask(with: url) { imageData, _, error in
            if let error {
                DispatchQueue.main.async {
                    self.image = UIImage(named: "ticket")
                    print("Error Displaying Image!!")
                }
            }
            
            if let data = imageData {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
