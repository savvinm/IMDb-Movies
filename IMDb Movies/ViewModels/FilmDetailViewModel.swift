//
//  FilmDetailViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 02.06.2022.
//

import SwiftUI

class FilmDetailViewModel: ObservableObject {
    enum Statuses {
        case loading
        case error(error: Error)
        case succes
    }
    private let localDataViewModel = LocalDataViewModel()
    private let interactor = FilmsInteractor()
    private let filmId: String?
    private(set) var film: Film?
    @Published private(set) var status: Statuses = .loading
    @Published private(set) var isSaved = false
    let maximumRating = 10
    
    init(filmId: String) {
        self.filmId = filmId
    }
    
    init(film: Film) {
        self.film = film
        filmId = film.id
        status = .succes
    }
    
    func updateFilm() {
        if film == nil && filmId != nil {
            getFilm()
        }
        isSaved = interactor.isFilmSaved(filmId: filmId!)
    }
    
    func getImage(in path: String) -> UIImage? {
        localDataViewModel.getImage(in: path)
    }
    
    private func getFilm() {
        interactor.getFilm(movieId: filmId!) { [weak self] film, error in
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
    
    func toggleSaveFilm(presentationMode: Binding<PresentationMode>?) {
        guard let film = film else {
            return
        }
        if isSaved {
            deleteFilm(film: film)
            presentationMode?.wrappedValue.dismiss()
        } else {
            saveFilm(film: film)
        }
        isSaved.toggle()
    }
    
    private func saveFilm(film: Film) {
        interactor.saveFilm(film)
    }
    
    private func deleteFilm(film: Film) {
        interactor.deleteFilm(film)
    }
}
