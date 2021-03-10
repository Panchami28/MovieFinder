//
//  ListViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    var networkCall=NetworkCalls()
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if flag==1 {
//            return movieArray.count
//        }
      
        return networkCall.searchArray.count
        
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        
        let url=URL(string:networkCall.searchArray[indexPath.row]["image"]!)
            
            if let data = try? Data(contentsOf: url!) {
                // Create Image and Update Image View
                cell.posterImage!.image = UIImage(data: data)
            }
            
        cell.movieLabel?.text=networkCall.searchArray[indexPath.row]["title"]
            cell.movieLabel?.numberOfLines=0
    
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        networkCall.globalURL+=networkCall.searchArray[indexPath.row]["id"]!
        networkCall.id=networkCall.searchArray[indexPath.row]["id"]!
       
        //print(globalURL)
        
        networkCall.getMovieData(networkCall.globalURL){(success) in
            if success==true {
                DispatchQueue.main.async{
                self.performSegue(withIdentifier: "moveToDetailPage", sender: self)
                }
            }
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        networkCall.searchURL+=searchBar.text!
        
        networkCall.getSearchData(networkCall.searchURL){
            (success) in
            print (success)
            if success==true {
                DispatchQueue.main.async{
                self.tableView.reloadData()
                }
                
            }
                
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text=""
        
        networkCall.searchURL="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/"
        networkCall.globalURL="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/film/"
        
        
        //print(globalURL)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="moveToDetailPage" {
            let destinationVC=segue.destination as! DetailViewController
            
            destinationVC.name=networkCall.titleOfMovie
            destinationVC.movieId=networkCall.id
            destinationVC.poster=networkCall.movieImage
            destinationVC.plot=networkCall.plotDescription
            destinationVC.cast=networkCall.jsonArray
            destinationVC.review=networkCall.rating
            destinationVC.year=networkCall.year
            
        }
        
    }
    
    

}

