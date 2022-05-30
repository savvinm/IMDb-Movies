//
//  FilmPreview.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class IMDbQuery: Codable {
    let items: [IMDbFilm]
    let errorMessage: String
}
class IMDbFilm: Identifiable, Codable {
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
    
    class GenrePair: Codable {
        let key: String
        let value: String
    }
}
