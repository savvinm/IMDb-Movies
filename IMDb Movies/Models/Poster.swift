//
//  Poster.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 02.06.2022.
//

import Foundation

struct Poster: Identifiable {
    let id: String
    let title: String
    let imageURL: String
    let imdbRating: String?
}
