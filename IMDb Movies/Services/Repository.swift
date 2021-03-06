//
//  Repository.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 31.05.2022.
//

import Combine
import Foundation
import Moya

final class FilmsRepository {
    enum RepositoryErrors: Error {
        case mappingError
        case imageDecodingError
    }
    private let provider = MoyaProvider<IMDbService>()
    
    func fetchTitle(movieId: String) -> AnyPublisher<Film?, Error> {
        return provider.requestPublisher(.title(id: movieId))
            .map { [weak self] response in
                return try? self?.handleFilmQuery(from: response)
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchList(option: FilmsInteractor.ListOption) -> AnyPublisher<[Poster]?, Error> {
        let moyaOption: IMDbService
        switch option {
        case .inTheaters:
            moyaOption = .inTheaters
        case .comingSoon:
            moyaOption = .comingSoon
        case .mostPopular:
            moyaOption = .mostPopular
        case .search(let searchQuery):
            moyaOption = .search(searchQuery: searchQuery)
        }
        return provider.requestPublisher(moyaOption)
            .map { [weak self] response in
                do {
                    let films: [Poster]?
                    switch option {
                    case .inTheaters, .comingSoon, .mostPopular:
                        films = try self?.handleRatingPosterQuery(from: response)
                    case .search:
                        films = try self?.handleSearchResultQuery(from: response)
                    }
                    return films
                } catch {
                    return nil
                }
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    private func handleRatingPosterQuery(from response: Moya.Response) throws -> [Poster] {
        let query = try response.map(IMDbRatingPosterQuery.self)
        var films = [Poster]()
        for item in query.items {
            films.append(Poster(id: item.id, title: item.title, imageURL: item.image, imdbRating: item.imDbRating, description: item.description))
        }
        return films
    }
    
    private func handleSearchResultQuery(from response: Moya.Response) throws -> [Poster] {
        let query = try response.map(IMDbSearchResultQuery.self)
        var films = [Poster]()
        for item in query.results {
            films.append(Poster(id: item.id, title: item.title, imageURL: item.image, imdbRating: item.imDbRating, description: item.description))
        }
        return films
    }
    
    private func handleFilmQuery(from response: Moya.Response) throws -> Film {
        let film = try response.map(IMDbFilm.self)
        var actors = [Film.Actor]()
        for star in film.actorList {
            actors.append(Film.Actor(id: star.id, imageURL: star.image, name: star.name))
        }
        var similars = [Poster]()
        for similar in film.similars {
            similars.append(Poster(id: similar.id, title: similar.title, imageURL: similar.image, imdbRating: similar.imDbRating, description: similar.description))
        }
        return Film(
            id: film.id,
            title: film.title,
            fullTitle: film.fullTitle,
            year: film.year,
            posterURL: film.image,
            imagePath: nil,
            runtimeStr: film.runtimeStr,
            plot: film.plot,
            genres: film.genres,
            directors: film.directors,
            writers: film.writers,
            actors: actors,
            contentRating: film.contentRating,
            imdbRating: film.imDbRating,
            similars: similars)
    }
    
    func getImage(urlString: String) -> AnyPublisher<UIImage?, Error> {
       return provider.requestPublisher(.image(url: urlString))
            .map { response in
                UIImage(data: response.data)
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
