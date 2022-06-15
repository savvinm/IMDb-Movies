//
//  RealmManager.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 01.06.2022.
//

import Foundation
import RealmSwift

final class RealmManager {
    func getRating(for film: Film) -> Int? {
        guard let saved = getSavedRating(for: film) else {
            return nil
        }
        return saved.rating
    }
    
    private func getSavedRating(for film: Film) ->  UserRating? {
        let localRealm = try! Realm()
        let ratings = localRealm.objects(UserRating.self)
        let options = ratings.where {
            $0.filmId == film.id
        }
        guard !options.isEmpty else {
            return nil
        }
        return options.first
    }
    
    func setRating(for film: Film, rating: Int) {
        let localRealm = try! Realm()
        let ratings = localRealm.objects(UserRating.self)
        let options = ratings.where {
            $0.filmId == film.id
        }
        guard options.isEmpty else {
            let userRating = options.first
            try! localRealm.write {
                userRating?.rating = rating
                userRating?.ratingDate = Date()
            }
            return
        }
        let userRating = UserRating(filmId: film.id, rating: rating, ratingDate: Date())
        try! localRealm.write {
            localRealm.add(userRating)
        }
     }
    
    func getActors(for film: SavedFilm) -> [Film.Actor] {
        var actors = [Film.Actor]()
        for filmActor in film.actors {
            actors.append(Film.Actor(id: filmActor.id, imageURL: nil, imagePath: filmActor.imagePath, name: filmActor.name))
        }
        return actors
    }
    
    func getFilms() -> [Film] {
        let localRealm = try! Realm()
        let localfilms = localRealm.objects(SavedFilm.self)
        var films = [Film]()
        for film in localfilms {
            films.append(Film(
                id: film.id,
                title: film.title,
                fullTitle: film.fullTitle,
                year: film.year,
                posterURL: nil,
                imagePath: film.imagePath,
                runtimeStr: film.runtimeStr,
                plot: film.plot,
                genres: film.genres,
                directors: film.directors,
                writers: film.writers,
                actors: getActors(for: film),
                contentRating: film.contentRating,
                imdbRating: film.imdbRating,
                userRating: film.userRating?.rating,
                similars: [])
            )
        }
        return films
    }
    
    func saveFilm(film: Film) {
        let localRealm = try! Realm()
        let localFilm = SavedFilm(
            id: film.id,
            title: film.title,
            fullTitle: film.fullTitle,
            year: film.year,
            imagePath: film.imagePath!,
            runtimeStr: film.runtimeStr,
            plot: film.plot,
            genres: film.genres,
            directors: film.directors,
            writers: film.writers,
            actors: [],
            contentRating: film.contentRating,
            imdbRating: film.imdbRating,
            userRating: getSavedRating(for: film)
        )
        try! localRealm.write {
            localRealm.add(localFilm)
        }
    }
}
