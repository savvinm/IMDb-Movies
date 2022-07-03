//
//  FilmsInteractor.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 09.06.2022.
//

import Combine
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
    var cancellables = Set<AnyCancellable>()
    
    func searchFilms(searchQuery: String) -> AnyPublisher<[Poster], Never> {
        repository.fetchList(option: .search(searchQuery: searchQuery))
            .replaceError(with: [])
            .map { films in
                guard let films = films else {
                    return []
                }
                return films
            }
            .eraseToAnyPublisher()
    }
    
    func getPosters(option: ListOption) -> AnyPublisher<[Poster], Never> {
        repository.fetchList(option: option)
            .replaceError(with: [])
            .map { films in
                guard let films = films else {
                    return []
                }
                return films
            }
            .eraseToAnyPublisher()
    }
    
    func getFilm(movieId: String) -> AnyPublisher<Film?, Error> {
        repository.fetchTitle(movieId: movieId)
            .map { [weak self] film in
                guard var filmWithRating = film else {
                    return nil
                }
                filmWithRating.userRating = self?.getRating(for: filmWithRating)
                return filmWithRating
            }
            .eraseToAnyPublisher()
    }
    
    func getRating(for film: Film) -> Int? {
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
    
    /// Prepare film for deletion by removing images from file system
    private func deleteImages(for film: Film) throws {
        if let imagePath = film.imagePath {
            try fileSystemManager.deleteFile(fileName: imagePath)
        }
        let actors = dbManager.actorsForDeletion(with: film)
        for filmActor in actors {
            if let imagePath = filmActor.imagePath {
                try fileSystemManager.deleteFile(fileName: imagePath)
            }
        }
    }
    
    /// Prepare list of film images for downloading
    private func getAllImageURLs(for film: Film, maxActors: Int) -> [String: String] {
        var dict = [String: String]()
        if let imagePath = film.posterURL {
            dict[film.id] = imagePath
        }
        for filmActor in film.actors.prefix(maxActors) {
            if let imagePath = filmActor.imageURL {
                dict[filmActor.id] = imagePath
            }
        }
        return dict
    }
    
    /// Takes film and images and returns  new film with image paths
    private func saveImages(for film: Film, images: [String: UIImage], maxActors: Int) throws -> Film {
        var paths = [String: String]()
        var filmWithImages = film
        for key in images.keys {
            paths[key] = try fileSystemManager.saveImage(image: images[key]!, imageName: key)
        }
        filmWithImages.imagePath = paths[film.id]
        filmWithImages.actors = []
        for filmActor in film.actors.prefix(maxActors) {
            filmWithImages.actors.append(Film.Actor(id: filmActor.id, imageURL: nil, imagePath: paths[filmActor.id], name: filmActor.name))
        }
        return filmWithImages
    }
    
    func saveFilm(_ film: Film) {
        let urls = getAllImageURLs(for: film, maxActors: 5)
        var images = [String: UIImage]()
        let group = DispatchGroup()
        for key in urls.keys {
            group.enter()
            repository.getImage(url: urls[key]!)
                .sink(receiveCompletion: { result in
                    guard case let .failure(error) = result else {
                        return
                    }
                    print(error)
                }, receiveValue: { image in
                    if let image = image {
                        images[key] = image
                        group.leave()
                    }
                })
                .store(in: &cancellables)
        }
        group.notify(queue: .global()) { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let newFilm = try self.saveImages(for: film, images: images, maxActors: 5)
                self.dbManager.saveFilm(film: newFilm)
                self.cancellables.removeAll()
            } catch {
                print(error)
            }
        }
    }
    
    func isFilmSaved(filmId: String) -> Bool {
        dbManager.isFilmSaved(filmId: filmId)
    }
}
