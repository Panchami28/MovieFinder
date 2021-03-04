//
//  ListViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var globalURL:String="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/film/"
    
    let headers = [
        "x-rapidapi-key": "0aa8f88433msh99f545de959cc9bp16bc3ajsn4dd85324e7f6",
        "x-rapidapi-host": "imdb-internet-movie-database-unofficial.p.rapidapi.com"
    ]
    
    var titleOfMovie:String=""
    var rating:String=""
    var year:String=""
    var movieImage:String=""
    var plotDescription:String=""
    var jsonArray=[[String:Any]]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view

        /* Setup delegates */
               tableView.delegate = self
               tableView.dataSource = self
               searchBar.delegate = self
        
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath)
        
        cell.textLabel?.numberOfLines=0
        
        cell.textLabel?.text="Title: \(titleOfMovie)"+"\n" + "Rating: \(rating)" + "\n" + "Year of release: \(year)"
      
        return cell
    }
    
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        globalURL+=searchBar.text!
        print(globalURL)
        
        getMovieData(globalURL)
        
        self.tableView.reloadData()
    }
    
    
    
    
    func getMovieData(_ URL:String) {
        
        let request = NSMutableURLRequest(url: NSURL(string: URL)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if error != nil {
                print(error!)
            }
            else {
                //let httpResponse = response as? HTTPURLResponse
                
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        // try to read out a string array
                        print("Success getting data")
                        //print(json)
                        self.titleOfMovie=json["title"] as! String
                        self.rating=json["rating"] as! String
                        self.year=json["year"] as! String
                        self.movieImage=json["poster"] as! String
                        self.plotDescription=json["plot"] as! String
                        self.jsonArray = (json["cast"] as? [[String: Any]])!
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
           
           
        })

        
        dataTask.resume()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="moveToDetailedView" {
            let destinationVC=segue.destination as! DetailViewController
            
            destinationVC.poster=movieImage
            destinationVC.plot=plotDescription
            destinationVC.cast=jsonArray
        }
    }
    

}

