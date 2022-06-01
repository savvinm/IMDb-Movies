//
//  RealmModels.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 01.06.2022.
//

import Foundation
import RealmSwift

class UserRating: Object {
    @Persisted var filmId: String
    @Persisted var rating: Int
    @Persisted var ratingDate: Date
    
    convenience init(filmId: String, rating: Int, ratingDate: Date) {
        self.init()
        self.filmId = filmId
        self.rating = rating
        self.ratingDate = ratingDate
    }
}
