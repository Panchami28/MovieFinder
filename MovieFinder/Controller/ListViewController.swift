//
//  ListViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit
import SDWebImage

class ListViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: -
    // MARK: Variables
    // MARK: -

    var basicMovieModel: BasicMovieModel?

    // MARK: -
    // MARK: Variables
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private func loadMovieDetails(forMovie movie: BasicMovie) {
        // Get refefence of the storyboard first
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        // Get reference for the target View Controller in the storyboard
        if let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailViewController.basicMovie = movie
//            print("PanchamiDebug: \(#file), \(#function) Movie Identifier is:\(detailViewController.movieID)")
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    private func showAlert() {
        let alertViewControler = UIAlertController(title: "Error", message: "Something Went Wrong.Please try again later", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertViewControler.addAction(alertAction)
        present(alertViewControler, animated: true, completion: nil)
    }

}
// MARK: -
// MARK: Tableview DataSource and Delegates
// MARK: -
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basicMovieModel?.numberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        if let movie = basicMovieModel?.item(atIndex: indexPath.row) {
            cell.posterImage.sd_setImage(with: URL(string: movie.image), placeholderImage: UIImage(named: "placeholder"))
            cell.movieLabel?.text = movie.title
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = basicMovieModel?.item(atIndex: indexPath.row) {
            loadMovieDetails(forMovie: movie)
        }
    }
}
// MARK: -
// MARK: Searchbar Delegate
// MARK: -
extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadingIndicator.isHidden = false
        MovieDataApiManager.shared.getSearchData(searchBar.text ?? "") {[weak self] (movieList, error) in
            if error == nil {
                guard let movieList = movieList else {
                    self?.loadingIndicator.isHidden = true
                    return
                }
                self?.basicMovieModel = BasicMovieModel(movieList: movieList)
                self?.loadingIndicator.isHidden = true
                self?.tableView.reloadData()
            } else {
                //errorHandling
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        // This will dismiss the keyboard
        searchBar.resignFirstResponder()
        basicMovieModel = nil
        tableView.reloadData()
    }
}
