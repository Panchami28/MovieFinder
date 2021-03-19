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

class BasicMovieModel {
    private var basicMovieList: BasicMovieList?
    
    init(movieList: BasicMovieList) {
        basicMovieList = movieList
    }
    
    func numberOfItems() -> Int {
        return basicMovieList?.movies.count ?? 0
    }
    
    func item(atIndex index: Int) -> BasicMovie? {
        return basicMovieList?.movies[index]
    }
    
}

