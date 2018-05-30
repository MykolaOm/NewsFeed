//
//  NewsModel.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import Foundation

// No Optional variables. as json is "static"

struct VideoData: Decodable {
    let page: Int
    let totalResults : Int
    let totalPages: Int
    let results : [Movie]
}

struct Movie : Decodable {
    let voteCount : Int
    let id : Int
    let video : Bool
    let voteAverage : Double
    let title : String
    let popularity : Double
    let posterPath : String
    let originalLanguage : String
    let originalTitle : String
    let genreIds : [Int]
    let backdropPath : String
    let adult : Bool
    let overview : String
    let releaseDate : String
}
