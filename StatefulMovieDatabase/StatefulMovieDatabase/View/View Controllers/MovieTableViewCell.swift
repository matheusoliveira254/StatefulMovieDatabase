//
//  MovieTableViewCell.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - Properties
    //image receiver and property observer, to
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    //func that updates the view with the info the url passed to the SOT
    func updateView(with movie: Movie) {
        fetchImage(for: movie)
        var configuration = defaultContentConfiguration()
        configuration.text = movie.title
        configuration.secondaryText = movie.overview
        configuration.secondaryTextProperties.numberOfLines = 4
        configuration.imageProperties.maximumSize = CGSize(width: 150, height: 150)
        contentConfiguration = configuration
    }
    //gets the posterPath that comes from the fetchMovie, passes into the fetchImage func which puts toguether with the base url for image and makes the network call. If successful returns a UIImage which is passed to the property image in the class.
    func fetchImage(for movie: Movie) {
        guard let posterPath = movie.posterPath else {return}
        NetworkingController.fetchImage(with: posterPath) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            case .failure(let error):
                print("There was an error with the image!", error.errorDescription!)
            }
        }
    }
    //updates the configuration
    override func updateConfiguration(using state: UICellConfigurationState) {
        // Called when the image is set
        super.updateConfiguration(using: state)
        guard var configuration = contentConfiguration as? UIListContentConfiguration else { return }
        configuration.image = self.image
        contentConfiguration = configuration
    }
}
