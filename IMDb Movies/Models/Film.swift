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
    let releaseState: String
    let poster: String
    let runtimeStr: String
    let plot: String
    let genres: [String]
    let directors: String
    let stars: String
    let contentRating: String
}
