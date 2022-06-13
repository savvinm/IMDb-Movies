//
//  FilmPreview.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

struct IMDbSearchResultQuery: Codable {
    let expression: String
    let results: [IMDbSearchPoster]
}

struct IMDbRatingPosterQuery: Codable {
    let items: [IMDbPosterWithRating]
    let errorMessage: String
}

struct IMDbSearchPoster: Codable, Identifiable {
    let id: String
    let title: String
    let image: String
    let description: String
}

struct IMDbPosterWithRating: Codable, Identifiable {
    let id: String
    let title: String
    let image: String
    let imDbRating: String
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
    let imDbRating: String
    let imDbRatingVotes: String
    let similars: [IMDbPosterWithRating]

    struct IMDbActor: Codable, Identifiable {
        let id: String
        let image: String
        let name: String
        let asCharacter: String
    }
}
