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
    
    static let shared = MovieDataApiManager()

    
    // Change method parameter to movieID
    func getMovieData(forMovie movie: BasicMovie, completionHandler: @escaping (MovieDetail?,Error?) -> Void) {
        guard let movieURL = URL(string: "\(globalURL)\(movie.id)") else { return }
        let request = NSMutableURLRequest(url: movieURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [ weak self] (data, response, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
                print("Failed to load: \(error?.localizedDescription ?? "")")
            }
            else {
                guard let safeData = data else { return }
                let jsonDecoder = JSONDecoder()
                do {
                    let movieDetail = try jsonDecoder.decode(MovieDetail.self, from: safeData)
                    DispatchQueue.main.async {
                        completionHandler(movieDetail,nil)
                    }
                    print("Output:\(movieDetail)")
                } catch (let error) {
                    DispatchQueue.main.async {
                        completionHandler(nil,error)
                    }
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })
        dataTask.resume()
    }
    
    //MARK:-
    //MARK: getSearchData() method
    //MARK:-
    // This method should only take name of the movie or search query
    // Parameter should be movie name and completion handler
    func getSearchData(_ searchQuery: String, completionHandler: @escaping (BasicMovieList?, Error?) -> Void) {
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
                DispatchQueue.main.async {
                    completionHandler(nil,error as NSError?)
                }
            }  else {
                guard let safeData = data else { return }
                let jsonDecoder = JSONDecoder()
                do {
                    let basicMovieDetail = try jsonDecoder.decode(BasicMovieList.self, from: safeData)
                    DispatchQueue.main.async {
                        completionHandler(basicMovieDetail,nil)
                    }
                } catch (let error) {
                    DispatchQueue.main.async {
                        completionHandler(nil,error as NSError?)
                    }
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    
}
