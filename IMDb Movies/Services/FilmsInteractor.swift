//
//  FilmsInteractor.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 09.06.2022.
//

import SwiftUI

final class FilmsInteractor {
    enum ListOption {
        case inTheaters
        case comingSoon
        case mostPopular
        case search(searchQuery: String)
    }
    enum SavingErrors: Error {
        case imageDownloadingTimeOut
    }
    private let repository = FilmsRepository()
    private let dbManager = RealmManager()
    private let fileSystemManager = FileSystemManager()
    
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
    
    func getSavedFilms() -> [Film] {
        dbManager.getFilms()
    }
    
    func saveFilm(_ film: Film) throws {
        var posterImage: UIImage?
        let group = DispatchGroup()
        var status = false
        group.enter()
        repository.getImage(url: film.posterURL!) { image, error in
            if let error = error {
                print(error)
            }
            if let image = image {
                posterImage = image
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            if posterImage != nil {
                var newFilm = film
                do {
                    newFilm.imagePath = try self?.fileSystemManager.saveImage(image: posterImage!, imageName: "Posters.\(film.id)")
                    self?.dbManager.saveFilm(film: newFilm)
                } catch {
                    print(error)
                }
            }
        }
        /*let timeoutResult = group.wait(timeout: .now() + 6)
        if timeoutResult == .timedOut {
            throw SavingErrors.imageDownloadingTimeOut
        }*/
    }
}
