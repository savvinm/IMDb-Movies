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
    
    enum SortOption {
        case byName
        case byDate
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
    
    func readImageInFileSystem(path: String) throws -> UIImage {
        try fileSystemManager.readImage(imagePath: path)
    }
    
    func getSavedFilms(sortOption: SortOption) -> [Film] {
        dbManager.getFilms(sortOption: sortOption)
    }
    
    func deleteFilm(_ film: Film) {
        do {
            try deleteImages(for: film)
            dbManager.deleteFilm(film)
        } catch {
            print(error)
        }
    }
    
    private func deleteImages(for film: Film) throws {
        if let imagePath = film.imagePath {
            try fileSystemManager.deleteFile(fileName: imagePath)
        }
        for filmActor in film.actors {
            if let imagePath = filmActor.imagePath {
                try fileSystemManager.deleteFile(fileName: imagePath)
            }
        }
    }
    
    private func getAllImageURLs(for film: Film) -> [String: String] {
        var dict = [String: String]()
        if let imagePath = film.posterURL {
            dict[film.id] = imagePath
        }
        for filmActor in film.actors.prefix(5) {
            if let imagePath = filmActor.imageURL {
                dict[filmActor.id] = imagePath
            }
        }
        return dict
    }
    
    private func saveImages(for film: Film, images: [String: UIImage]) throws -> Film {
        var paths = [String: String]()
        var filmWithImages = film
        for key in images.keys {
            paths[key] = try fileSystemManager.saveImage(image: images[key]!, imageName: key)
        }
        filmWithImages.imagePath = paths[film.id]
        filmWithImages.actors = []
        for filmActor in film.actors {
            filmWithImages.actors.append(Film.Actor(id: filmActor.id, imageURL: nil, imagePath: paths[filmActor.id], name: filmActor.name))
        }
        return filmWithImages
    }
    
    func saveFilm(_ film: Film) throws {
        let urls = getAllImageURLs(for: film)
        var images = [String: UIImage]()
        let group = DispatchGroup()
        for key in urls.keys {
            group.enter()
            repository.getImage(url: urls[key]!) { image, error in
                if let error = error {
                    print(error)
                }
                if let image = image {
                    images[key] = image
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let newFilm = try self.saveImages(for: film, images: images)
                self.dbManager.saveFilm(film: newFilm)
            } catch {
                print(error)
            }
        }
    }
    
    func isFilmSaved(filmId: String) -> Bool {
        dbManager.isFilmSaved(filmId: filmId)
    }
}
