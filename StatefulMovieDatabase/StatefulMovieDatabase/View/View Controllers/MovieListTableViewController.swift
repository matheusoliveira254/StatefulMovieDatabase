//
//  MovieListTableViewController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    //SOT which will holf whatever value comes back from the fetchMovie func inside the searchBarSearchButtonClicked func
    var movies: [Movie] = []
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting the current class as the delegate to the searchBar
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //setting the amount of rows to the nunber of items inside the SOT
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //setting the cell style as the custom cell we created, otherwise using a regular cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        //getting the indexPath of the current cell in the SOT
        let movie = movies[indexPath.row]
        //updating the cell info with the info on the specific indexPath
        cell.updateView(with: movie)
        return cell
    }
    
}

extension MovieListTableViewController: UISearchBarDelegate {
    //passing whatever the the user typed to movieName constant
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let movieName = searchBar.text else {
            print("No text entered.")
            return
        }
        //making the network call passing whatever movie name was searched by the user.
        NetworkingController.fetchMovie(with: movieName) { result in
            switch result {
            case .success(let movieToDisplay):
                self.movies = movieToDisplay.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.resignFirstResponder()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
}
