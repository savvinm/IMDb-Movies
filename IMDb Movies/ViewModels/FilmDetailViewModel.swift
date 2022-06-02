//
//  FilmDetailViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 02.06.2022.
//

import Foundation

class FilmDetailViewModel: ObservableObject {
    enum Statuses {
        case loading
        case error(error: Error)
        case succes
    }
    
    @Published var film: Film?
    var status: Statuses
    
    init(filmId: String) {
        status = .loading
        getFilm(filmId: filmId)
    }
    
    private func getFilm(filmId: String) {
        let repository = FilmsRepository()
        repository.title(movieId: filmId) { [weak self] film, error in
            guard let self = self else {
                return
            }
            if let error = error {
                self.status = .error(error: error)
                self.objectWillChange.send()
                return
            }
            if var film = film {
                film.userRating = self.getRating(for: film)
                self.status = .succes
                self.film = film
            }
        }
    }
    
    private func getRating(for film: Film) -> Int? {
        let dbManager = DBManager()
        return dbManager.getRating(for: film)
    }
    
    func rateFilm(rating: Int) {
        guard film != nil else {
            return
        }
        let dbManager = DBManager()
        dbManager.setRating(for: film!, rating: rating)
        film!.userRating = rating
    }
}
