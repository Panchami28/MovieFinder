//
//  NetworkCalls.swift
//  MovieFinder
//
//  Created by Panchami Rao on 09/03/21.
//

import Foundation

class  MovieDataApiManager {
    var globalURL: String = "https://imdb-internet-movie-database-unofficial.p.rapidapi.com/film/"
    
    let searchURLBase: String = "https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/"
    
    let headers = [
        "x-rapidapi-key": "0aa8f88433msh99f545de959cc9bp16bc3ajsn4dd85324e7f6",
        "x-rapidapi-host": "imdb-internet-movie-database-unofficial.p.rapidapi.com"
    ]
    // Move this code inside another object
    /*
     Example:
     
     */
    var titleOfMovie: String = ""
    var rating: String = ""
    var year:String=""
    var movieImage:String=""
    var plotDescription:String=""
    
    var jsonArray=[[String:Any]]()
    var searchArray=[[String:String]]()
    var flag:Int=0
    var id:String=""
    
    // Change method parameter to movieID
    func getMovieData(_ movieId:String, completionHandler: @escaping (Bool) -> Void) {
        guard let movieURL = URL(string: "\(globalURL)\(movieId)") else { return }
        id=movieId
        let request = NSMutableURLRequest(url: movieURL,
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
                //use optional chaining for data
                if let safeData = data {
                    do {
                        // make sure this JSON is in the format we expect
                        if let json = try JSONSerialization.jsonObject(with: safeData, options: []) as? [String: Any] {
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
                        DispatchQueue.main.async {
                            completionHandler(false)
                        }
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
                
            }
            DispatchQueue.main.async {
                completionHandler(true)
            }
        })
        
        dataTask.resume()
    }
    
    // This method should only take name of the movie or search query
    // Parameter should be movie name and completion handler
    func getSearchData(_ searchQuery: String, completionHandler: @escaping (Bool) -> Void) {
        let encodedString = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        guard let searchURL = URL(string: "\(searchURLBase)\(encodedString)") else { return }
        
        let request = NSMutableURLRequest(url: searchURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            }  else {
                //let httpResponse = response as? HTTPURLResponse
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        // try to read out a string array
                        self.searchArray = (json["titles"] as? [[String: String]])!
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completionHandler(true)
            }
            
        })
        
        dataTask.resume()
        
    }
    
    
}
