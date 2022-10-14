//
//  MovieTableViewCell.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    func fetchImage(for movie: Movie) {
        guard let posterPath = movie.posterPath else {return}
        UIImageView.loadImageFrom(posterPath)
    }
    
    func updateView(with movie: Movie) {
        //TODO: - Update the Strings with the real values
        var configuration = defaultContentConfiguration()
        configuration.text = movie.title
        configuration.secondaryText = movie.overview
        configuration.secondaryTextProperties.numberOfLines = 4
        configuration.imageProperties.maximumSize = CGSize(width: 150, height: 150)
        contentConfiguration = configuration
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        // Called when the image is set
        super.updateConfiguration(using: state)
        guard var configuration = contentConfiguration as? UIListContentConfiguration else { return }
        configuration.image = self.image
        contentConfiguration = configuration
    }
}

// MARK: - Functions

