//
//  FilmPreview.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

struct IMDbQuery: Codable {
    let items: [IMDbFilm]
    let errorMessage: String
}
struct IMDbFilm: Identifiable, Codable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let releaseState: String
    let image: String
    let runtimeStr: String
    let plot: String
    let genres: String
    let directors: String
    let stars: String
    let contentRating: String
    let genreList: [GenrePair]
    
    struct GenrePair: Codable {
        let key: String
        let value: String
    }
}
