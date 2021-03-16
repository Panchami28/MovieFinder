//
//  ListViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var movieDataApiManager = MovieDataApiManager()
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //var basicMovieModel: BasicMovieModel?
    

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
        //reset search bar url
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="moveToDetailPage" {
            let destinationVC=segue.destination as! DetailViewController
            
            destinationVC.name = movieDataApiManager.titleOfMovie
            destinationVC.movieId = movieDataApiManager.id
            destinationVC.poster=movieDataApiManager.movieImage
            destinationVC.plot=movieDataApiManager.plotDescription
            destinationVC.cast=movieDataApiManager.jsonArray
            destinationVC.review=movieDataApiManager.rating
            destinationVC.year=movieDataApiManager.year
            //destinationVC.movie = Movie(titrle asasadssjdsa)
        }
    }

}

// MARK: Tableview DataSource and Delegates
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // return basicMovieModel.numberOfItems ?? 0
//        var count: Int? = nil
        return movieDataApiManager.searchArray.count
//        return count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell=tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell

        //This should be done asynchronously
        if let url = URL(string:movieDataApiManager.searchArray[indexPath.row]["image"] ?? "") {
            
            if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
                cell.posterImage.image = UIImage(data: data)
            }
        }
        cell.movieLabel?.text=movieDataApiManager.searchArray[indexPath.row]["title"]
        cell.movieLabel?.numberOfLines=0
        
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieId = movieDataApiManager.searchArray[indexPath.row]["id"]! as? String {
            movieDataApiManager.getMovieData(movieId){(success) in
                if success == true {
                    self.performSegue(withIdentifier: "moveToDetailPage", sender: self)
                }
            }
        }
    }
}

// MARK: Searchbar Delegate
extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(movieDataApiManager.searchURLBase)
        loadingIndicator.isHidden = false
        movieDataApiManager.getSearchData(searchBar.text ?? "") { [weak self] (success) in
            print (success)
            if success == true {
                self?.loadingIndicator.isHidden = true
                self?.tableView.reloadData()
            } else {
                //Show an alert saying something went wrong
                let alertViewControler = UIAlertController(title: "Error", message: "Something Went Wrong.Please try again later", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertViewControler.addAction(alertAction)
                
                self?.present(alertViewControler, animated: true, completion: nil)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        movieDataApiManager.searchArray.removeAll()
        tableView.reloadData()
        //print(globalURL)
    }
}
