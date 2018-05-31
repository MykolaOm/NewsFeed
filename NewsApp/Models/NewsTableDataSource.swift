//
//  NewsTableDataSourse.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 31.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import Foundation

class NewsTableDataSource {
    
    let overview : String
    let title : String
    let imageUrl : String
    let voteAverage : Double
    let basePath = "http://image.tmdb.org/t/p/w500"
   
    init( overview : String, title : String , posterPath:String, voteAverage: Double) {
        self.overview = overview
        self.imageUrl = self.basePath + posterPath
        self.title = title
        self.voteAverage = voteAverage
    }
}
