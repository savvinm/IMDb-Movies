//
//  Film.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 31.05.2022.
//

import Foundation

struct Film: Identifiable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let posterURL: String
    let runtimeStr: String
    let plot: String
    let genres: String
    let directors: String
    let writers: String
    let actors: [Actor]
    let contentRating: String
    let imdbRating: String
    let imdbRatingVotes: String
    var userRating: Int?
    let similars: [Poster]
    
    struct Actor: Identifiable {
        let id: String
        let imageURL: String
        let name: String
    }
}
