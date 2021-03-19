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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // Lazy because file path should be accessed only when it is needed.
    lazy var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    
    var movieArray = [BasicMovie]()
    
    // MARK: -
    // MARK: - View Life Cycle
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
        
        //1) Create a model class
        //2) That model class takes movie array as initialiser
        // let movieModel = MovieModel(items: [MovieDetail])
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingIndicator.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadingIndicator.isHidden = true
        favoriteTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                movieArray = try decoder.decode([BasicMovie].self, from: data)
            }catch {
                print("Error decoding data \(error)")
            }
        }
        
        tableView.reloadData()
    }
    // MARK: -
    // MARK: - Priavte Methods
    // MARK: -
    
    private func loadMovieDetails(forMovie movie: BasicMovie) {
        // Get refefence of the storyboard first
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        // Get reference for the target View Controller in the storyboard
        if let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailViewController.basicMovie = movie
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    // MARK: -
    // MARK: - Table view data source
    // MARK: -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieArray.count
        // movieModel.totalNumberOfItems
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let movie = movieArray[indexPath.row]// It will give one movie object
        cell.movieLabel?.text = movie.title // movie.name, movie.poster
        cell.posterImage.sd_setImage(with: URL(string: movie.image), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///same as list view
        loadMovieDetails(forMovie: movieArray[indexPath.row])
    }


}
