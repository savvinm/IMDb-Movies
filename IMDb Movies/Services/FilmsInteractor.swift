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
    
    enum SortOption {
        case byName
        case byDate
    }
    
    private let repository = FilmsRepository()
    private let dbManager = RealmManager()
    private let fileSystemManager = FileSystemManager()
    private var cancellable: AnyCancellable?
    
    func getPosters(option: ListOption) -> AnyPublisher<[Poster], Never> {
        repository.fetchList(option: option)
            .replaceError(with: [])
            .map { $0 ?? [] }
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
    }
    
    /// Takes film and image and returns  new film with image path
    private func saveImage(for film: Film, image: UIImage) throws -> Film {
        var filmWithImages = film
        filmWithImages.imagePath = try fileSystemManager.saveImage(image: image, imageName: film.id)
        return filmWithImages
    }
    
    func saveFilm(_ film: Film) {
        guard let urlString = film.posterURL else {
            return
        }
        cancellable = repository.getImage(urlString: urlString)
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { result in
                guard case let .failure(error) = result else {
                    return
                }
                print(error)
            }, receiveValue: { [weak self] image in
                guard
                    let self = self,
                    let image = image
                else {
                    return
                }
                do {
                    let newFilm = try self.saveImage(for: film, image: image)
                    self.dbManager.saveFilm(film: newFilm)
                } catch {
                    print(error)
                }
            })
    }
    
    func isFilmSaved(filmId: String) -> Bool {
        dbManager.isFilmSaved(filmId: filmId)
    }
}
