//
//  ListViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var globalURL:String="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/film/"
    
    var searchURL:String="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/"
    
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
    var searchArray=[[String:String]]()
    var flag:Int=0
    var id:String=""
    
    
    
    
    
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
      
            return searchArray.count
        
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        
            let url=URL(string:searchArray[indexPath.row]["image"]!)
            
            if let data = try? Data(contentsOf: url!) {
                // Create Image and Update Image View
                cell.posterImage!.image = UIImage(data: data)
            }
            
            cell.movieLabel?.text=searchArray[indexPath.row]["title"]
            cell.movieLabel?.numberOfLines=0
    
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // globalURL+=(tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        
//        if flag==1 {
//            globalURL+=movieArray[indexPath.row].id
//        }
        
            globalURL+=searchArray[indexPath.row]["id"]!
            id=searchArray[indexPath.row]["id"]!
       
        print(globalURL)
        
        getMovieData(globalURL)
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
         searchURL+=searchBar.text!
        
        getSearchData(searchURL)
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text=""
        
        searchURL="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/"
        globalURL="https://imdb-internet-movie-database-unofficial.p.rapidapi.com/film/"
        
        flag=0
        
        //print(globalURL)
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
                        
                        DispatchQueue.main.async{
                            self.performSegue(withIdentifier: "moveToDetailPage", sender: self)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
           
        })

        
        dataTask.resume()
    
    }
    
    
    func getSearchData(_ URLL:String) {
        
        let request = NSMutableURLRequest(url: NSURL(string: URLL)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            }  else {
                //let httpResponse = response as? HTTPURLResponse
                
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        // try to read out a string array
                        self.searchArray = (json["titles"] as? [[String: String]])!
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
           
        })

        dataTask.resume()
        
    }
    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="moveToDetailPage" {
            let destinationVC=segue.destination as! DetailViewController
            
            destinationVC.name=titleOfMovie
            destinationVC.movieId=id
            destinationVC.poster=movieImage
            destinationVC.plot=plotDescription
            destinationVC.cast=jsonArray
            destinationVC.review=rating
            destinationVC.year=year
            
        }
        
    }
    
    

}

