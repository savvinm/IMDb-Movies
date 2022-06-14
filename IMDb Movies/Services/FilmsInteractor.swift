//
//  FilmsInteractor.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 09.06.2022.
//

import Foundation

final class FilmsInteractor {
    enum ListOption {
        case inTheaters
        case comingSoon
        case mostPopular
        case search(searchQuery: String)
    }
    private let repository = FilmsRepository()
    private let dbManager = DBManager()
    
    func searchFilms(searchQuery: String, complitionHandler: @escaping (String, [Poster]?, Error?) -> Void) {
        repository.fetchList(option: .search(searchQuery: searchQuery)) { films, error in
            complitionHandler(searchQuery, films, error)
        }
    }
    
    func getPosters(option: ListOption, complitionHandler: @escaping ([Poster]?, Error?) -> Void) {
        repository.fetchList(option: option) {films, error in
            complitionHandler(films, error)
        }
    }
    
    func getFilm(movieId: String, complitionHandler: @escaping (Film?, Error?) -> Void) {
        repository.fetchTitle(movieId: movieId) { [weak self] film, error in
            guard var filmWithRating = film else {
                complitionHandler(nil, error)
                return
            }
            filmWithRating.userRating = self?.getRating(for: filmWithRating)
            complitionHandler(filmWithRating, nil)
        }
    }
    
    private func getRating(for film: Film) -> Int? {
        dbManager.getRating(for: film)
    }
    
    func setRating(for film: Film, rating: Int) {
        dbManager.setRating(for: film, rating: rating)
    }
}
