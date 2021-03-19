//
//  MovieDetail.swift
//  MovieFinder
//
//  Created by Panchami Rao on 08/03/21.
//

import Foundation

struct Cast: Codable {
    var actor: String = ""
    var character: String = ""
}

struct MovieDetail: Codable {
    let id: String
    let title: String
    let year: String
    let rating: String
    let poster: String
    let plot: String
    let cast: [Cast]
    
    var castString: String? {
        let casts = cast.compactMap { $0.actor }
        let formattedCast = casts.joined(separator: " as ")
        return formattedCast
    }
}



