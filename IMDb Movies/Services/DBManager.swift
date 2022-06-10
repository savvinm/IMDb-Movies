//
//  DBManager.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 01.06.2022.
//

import Foundation
import RealmSwift

final class DBManager {
    func getRating(for film: Film) -> Int? {
        let localRealm = try! Realm()
        let ratings = localRealm.objects(UserRating.self)
        let options = ratings.where {
            $0.filmId == film.id
        }
        guard options.count == 1 else {
            return nil
        }
        return options.first?.rating
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
}
