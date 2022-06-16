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

class SavedFilm: Object {
    @Persisted var id: String
    @Persisted var title: String
    @Persisted var fullTitle: String
    @Persisted var year: String
    @Persisted var imagePath: String
    @Persisted var runtimeStr: String
    @Persisted var plot: String
    @Persisted var genres: String
    @Persisted var directors: String
    @Persisted var writers: String
    @Persisted var actors = List<SavedActor>()
    @Persisted var contentRating: String
    @Persisted var imdbRating: String?
    @Persisted var userRating: UserRating?
    @Persisted var savingDate: Date
    
    convenience init(id: String, title: String, fullTitle: String, year: String, imagePath: String,
                     runtimeStr: String, plot: String, genres: String, directors: String, writers: String,
                     actors: [SavedActor], contentRating: String, imdbRating: String?, userRating: UserRating?, savingDate: Date) {
        self.init()
        self.id = id
        self.title = title
        self.fullTitle = fullTitle
        self.year = year
        self.imagePath = imagePath
        self.runtimeStr = runtimeStr
        self.plot = plot
        self.genres = genres
        self.directors = directors
        self.writers = writers
        self.actors.append(objectsIn: actors)
        self.contentRating = contentRating
        self.imdbRating = imdbRating
        self.userRating = userRating
        self.savingDate = savingDate
    }
}

class SavedActor: Object {
    @Persisted var id: String
    @Persisted var imagePath: String
    @Persisted var name: String
    
    convenience init(id: String, imagePath: String, name: String) {
        self.init()
        self.id = id
        self.imagePath = imagePath
        self.name = name
    }
}
