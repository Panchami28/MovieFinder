//
//  FavouritesMovieModel.swift
//  MovieFinder
//
//  Created by Panchami Rao on 20/03/21.
//

import Foundation


fileprivate let movieListFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MovieList.plist")

class FavouritesMovieModel: FavouritesMovieModelProtocol {

    private var favourites: [BasicMovie]
    
    init() {
        favourites = [BasicMovie]()
        loadMovies()
    }

    private func loadMovies() {
        if let movieListPath = movieListFilePath {
            if let data = try? Data(contentsOf: movieListPath) {
                let decoder = PropertyListDecoder()
                do {
                    let movies = try decoder.decode([BasicMovie].self, from: data)
                    favourites = movies
                } catch {
                    print("Error decoding data \(error)")
                }
            }
        }
    }

    func numberOfMovies() -> Int {
        return favourites.count
    }

    func item(atIndexPath indexPath: IndexPath) -> BasicMovie? {
        return favourites[indexPath.row]
    }

    func removeMovie(atIndexPath indexPath: IndexPath) {
        favourites.remove(at: indexPath.row)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favourites)
            if let pathToWrite = movieListFilePath {
                try? data.write(to: pathToWrite)
            }
        } catch {
            print("Error encoding data:\(error)")
        }
    }

    class func insertMovie(_ movie: BasicMovie, completion: (Bool)->Void) {
        var favourites = [BasicMovie]()
        guard let movieListPath = movieListFilePath else {
            completion(false)
            return
        }
        if let data = try? Data(contentsOf: movieListPath) {
            let decoder = PropertyListDecoder()
            do {
                favourites = try decoder.decode([BasicMovie].self, from: data)
            } catch {
                print("Error decoding data \(error)")
                completion(false)
            }
        }
        favourites.append(movie)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favourites)
            try data.write(to: movieListPath)
            completion(true)
        } catch {
            //show alert
            print("Error encoding data:\(error)")
            completion(false)
        }
    }
}
