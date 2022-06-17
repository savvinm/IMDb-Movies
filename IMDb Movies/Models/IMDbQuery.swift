//
//  FilmPreview.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

struct IMDbSearchResultQuery: Codable {
    let expression: String
    let results: [IMDbPoster]
}

struct IMDbRatingPosterQuery: Codable {
    let items: [IMDbPoster]
    let errorMessage: String
}

struct IMDbPoster: Codable, Identifiable {
    let id: String
    let title: String
    let image: String
    let description: String?
    let imDbRating: String?
}

struct IMDbFilm: Identifiable, Codable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let runtimeStr: String
    let plot: String
    let genres: String
    let directors: String
    let writers: String
    let actorList: [IMDbActor]
    let contentRating: String
    let imDbRating: String?
    let similars: [IMDbPoster]

    struct IMDbActor: Codable, Identifiable {
        let id: String
        let image: String
        let name: String
    }
}
