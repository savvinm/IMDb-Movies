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
    private let filmId: String
    private(set) var film: Film?
    @Published private(set) var status: Statuses
    let maximumRating = 10
    private let interactor = FilmsInteractor()
    
    init(filmId: String) {
        status = .loading
        self.filmId = filmId
    }
    
    func updateFilm() {
        if film == nil {
            getFilm()
        }
    }
    
    private func getFilm() {
        interactor.getFilm(movieId: filmId) { [weak self] film, error in
            guard let self = self else {
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.status = .error(error: error)
                }
                return
            }
            if let film = film {
                DispatchQueue.main.async {
                    self.film = film
                    self.status = .succes
                }
            }
        }
    }
    
    func rateFilm(rating: Int) {
        guard film != nil else {
            return
        }
        interactor.setRating(for: film!, rating: rating)
        film!.userRating = rating
        objectWillChange.send()
    }
    
    func saveFilm() {
        guard let film = film else {
            return
        }
        do {
            try interactor.saveFilm(film)
        } catch {
            print(error)
        }
    }
}
