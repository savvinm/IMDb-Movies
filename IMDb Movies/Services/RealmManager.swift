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
        return localRealm.objects(SavedFilm.self).first(where: { $0.id == filmId }) != nil
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
    
    /// Returns list of all saved films sorted by selected option
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
            actors: actorsForFilm(film: film),
            contentRating: film.contentRating,
            imdbRating: film.imdbRating,
            userRating: getSavedRating(for: film),
            savingDate: Date()
        )
        try! localRealm.write {
            localRealm.add(localFilm)
        }
    }
    
    ///  Saves new actors for film (if needed) and returns list of SavedActor
    private func actorsForFilm(film: Film) -> [SavedActor] {
        let localRealm = try! Realm()
        let localActors = localRealm.objects(SavedActor.self)
        var actors = [SavedActor]()
        for filmActor in film.actors {
            if let saved = localActors.first(where: { $0.id == filmActor.id }) {
                actors.append(saved)
            } else {
                let actor = SavedActor(id: filmActor.id, imagePath: filmActor.imagePath!, name: filmActor.name)
                try! localRealm.write {
                    localRealm.add(actor)
                }
                actors.append(actor)
            }
        }
        return actors
    }
    
    func deleteFilm(_ film: Film) {
        deleteActors(for: film)
        let localRealm = try! Realm()
        let films = localRealm.objects(SavedFilm.self)
        if let film = films.first(where: { $0.id == film.id }) {
            try! localRealm.write {
                localRealm.delete(film)
            }
        }
    }
    
    private func deleteActors(for film: Film) {
        let actors = actorsForDeletion(with: film)
        let localRaelm = try! Realm()
        for filmActor in actors {
            if let savedActor = localRaelm.objects(SavedActor.self).first(where: { $0.id == filmActor.id }) {
                try! localRaelm.write {
                    localRaelm.delete(savedActor)
                }
            }
        }
    }
    
    /// Returns list of actors that are saved for less than two movies
    func actorsForDeletion(with film: Film) -> [Film.Actor] {
        var actors = [Film.Actor]()
        let localRealm = try! Realm()
        for filmActor in film.actors {
            let films = localRealm.objects(SavedFilm.self).filter({ $0.actors.contains(where: { $0.id == filmActor.id }) })
            if films.count <= 1 {
                actors.append(filmActor)
            }
        }
        return actors
    }
}
