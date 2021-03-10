//
//  NetworkCalls.swift
//  MovieFinder
//
//  Created by Panchami Rao on 09/03/21.
//

import Foundation

class NetworkCalls {
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
    
   
    
    func getMovieData(_ URL:String, completionHandler: @escaping (Bool) -> Void) {
        var success:Bool=true
        
        
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
                success=true
                
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
                        
//                        DispatchQueue.main.async{
//                            self.performSegue(withIdentifier: "moveToDetailPage", sender: self)
//                        }
                        
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
            completionHandler(success)
        })

        
        dataTask.resume()
        
    
    }
    
    
    func getSearchData(_ URLL:String, completionHandler:@escaping (Bool) -> Void) {
        
        var success:Bool=false
        
        let request = NSMutableURLRequest(url: NSURL(string: URLL)! as URL,
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
                success=true
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
            
            completionHandler(success)
           
        })
        
       
       
            
        
        dataTask.resume()
        
        
        
    }
    
    
}
