//
//  BasicMovieDetail.swift
//  MovieFinder
//
//  Created by Panchami Rao on 17/03/21.
//

import Foundation

struct BasicMovie : Codable  {
    var title: String
    var image: String
    var id: String
}

struct BasicMovieList: Codable {
    let movies: [BasicMovie]
    private enum CodingKeys: String, CodingKey {
        case movies = "titles"
    }
}

protocol MovieModelProtocol {
    func numberOfMovies() -> Int
    func item(atIndexPath indexPath: IndexPath) -> BasicMovie?
}

protocol FavouritesMovieModelProtocol: MovieModelProtocol {
    func removeMovie(atIndexPath indexPath: IndexPath)
}

class BasicMovieModel: MovieModelProtocol {
    
    private var movies: [BasicMovie]
    
    init(movieList: BasicMovieList) {
        movies = movieList.movies
    }

    func numberOfMovies() -> Int {
        return movies.count
    }

    func item(atIndexPath indexPath: IndexPath) -> BasicMovie? {
        return movies[indexPath.row]
    }

    func removeMovie(atIndexPath indexPath: IndexPath) {
        movies.remove(at: indexPath.row)
    }
}

