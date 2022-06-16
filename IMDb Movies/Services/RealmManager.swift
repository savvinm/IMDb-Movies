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
        getSavedRating(for: film)?.rating
    }
    
    private func getSavedRating(for film: Film) ->  UserRating? {
        let localRealm = try! Realm()
        let ratings = localRealm.objects(UserRating.self)
        return ratings.first(where: { $0.filmId == film.id })
    }
    
    func setRating(for film: Film, rating: Int) {
        let localRealm = try! Realm()
        if let savedRating = getSavedRating(for: film) {
            try! localRealm.write {
                savedRating.rating = rating
                savedRating.ratingDate = Date()
            }
        } else {
            let userRating = UserRating(filmId: film.id, rating: rating, ratingDate: Date())
            writeRatingToFilm(rating: userRating, filmId: film.id)
            try! localRealm.write {
                localRealm.add(userRating)
            }
        }
     }
    
    func isFilmSaved(filmId: String) -> Bool {
        let localRealm = try! Realm()
        if localRealm.objects(SavedFilm.self).first(where: { $0.id == filmId }) != nil {
            return true
        }
        return false
    }
    
    private func writeRatingToFilm(rating: UserRating, filmId: String) {
        let localRealm = try! Realm()
        if let film = localRealm.objects(SavedFilm.self).first(where: { $0.id == filmId }) {
            try! localRealm.write {
                film.userRating = rating
            }
        }
    }
    
    private func getActors(for film: SavedFilm) -> [Film.Actor] {
        var actors = [Film.Actor]()
        for filmActor in film.actors {
            actors.append(Film.Actor(id: filmActor.id, imageURL: nil, imagePath: filmActor.imagePath, name: filmActor.name))
        }
        return actors
    }
    
    func getFilms(sortOption: FilmsInteractor.SortOption) -> [Film] {
        let localRealm = try! Realm()
        let localfilms = localRealm.objects(SavedFilm.self).sorted(by: { filmA, filmB in
            switch sortOption {
            case .byName:
                return filmA.fullTitle < filmB.fullTitle
            case .byDate:
                return filmA.savingDate > filmB.savingDate
            }
            
        })
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
            userRating: getSavedRating(for: film),
            savingDate: Date()
        )
        try! localRealm.write {
            localRealm.add(localFilm)
        }
    }
    
    func deleteFilm(_ film: Film) {
        let localRealm = try! Realm()
        let films = localRealm.objects(SavedFilm.self)
        if let film = films.first(where: { $0.id == film.id }) {
            try! localRealm.write {
                localRealm.delete(film)
            }
        }
    }
}
