//
//  FavoriteTableViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 08/03/21.
//

import UIKit
import Foundation

class FavoriteTableViewController: UITableViewController {

    @IBOutlet var favoriteTableView: UITableView!
    
    var movieModel: FavouritesMovieModelProtocol?
    
    // MARK: -
    // MARK: - View Life Cycle
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        favoriteTableView.register(UINib(nibName: "BasicMovieCell", bundle: nil), forCellReuseIdentifier: "BasicMovieCell")
        setupModel()
        tableView.reloadData()
    }

    private func setupModel() {
        movieModel = FavouritesMovieModel()
    }

    // MARK: -
    // MARK: - Private Methods
    // MARK: -

    private func loadMovieDetails(forMovie movie: BasicMovie) {
        // Get refefence of the storyboard first
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        // Get reference for the target View Controller in the storyboard
        if let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? MovieDetailViewController {
            detailViewController.basicMovie = movie
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    private func deleteRow(atIndexPath indexPath: IndexPath) {
        movieModel?.removeMovie(atIndexPath: indexPath)
    }
    
    // MARK: -
    // MARK: - Table view data source
    // MARK: -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieModel?.numberOfMovies() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicMovieCell", for: indexPath) as! BasicMovieCell
        if let movie = movieModel?.item(atIndexPath: indexPath) {
            cell.movieLabel?.text = movie.title
            cell.posterImage.sd_setImage(with: URL(string: movie.image), placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = movieModel?.item(atIndexPath: indexPath) {
            loadMovieDetails(forMovie: movie)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteRow(atIndexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }

}
