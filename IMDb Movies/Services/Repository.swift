//
//  Repository.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 31.05.2022.
//

import Foundation
import Moya

struct FilmsRepository {
    
    func title(movieId: String, complitionHandler: @escaping (Film?, Error?) -> Void) {
        let provider = MoyaProvider<IMDbService>()
        provider.request(.title(id: movieId)) { result in
            switch result {
            case .success(let response):
                do {
                    let film = try handleFilmQuery(from: response)
                    complitionHandler(film, nil)
                } catch {
                    complitionHandler(nil, RepositoryError.mappingError)
                }
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
    
    func list(option: ListOption, complitionHandler: @escaping ([Poster]?, Error?) -> Void) {
        let provider = MoyaProvider<IMDbService>()
        let moyaOption: IMDbService
        switch option {
        case .inTheaters:
            moyaOption = .inTheaters
        case .comingSoon:
            moyaOption = .comingSoon
        case .mostPopular:
            moyaOption = .mostPopular
        }
        provider.request(moyaOption) { result in
            switch result {
            case .success(let response):
                do {
                    let films: [Poster]
                    switch option {
                    case .comingSoon, .inTheaters, .mostPopular:
                        films = try handleRatingPosterQuery(from: response)
                    }
                    complitionHandler(films, nil)
                } catch {
                    complitionHandler(nil, RepositoryError.mappingError)
                }
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
    
    private func handleRatingPosterQuery(from response: Moya.Response) throws -> [Poster] {
        let query = try response.map(IMDbRatingPosterQuery.self)
        var films = [Poster]()
        for item in query.items {
            films.append(Poster(id: item.id, title: item.title, imageURL: item.image, imdbRating: item.imDbRating))
        }
        return films
    }
    
    private func handlePosterQuery(from response: Moya.Response) throws -> [Poster] {
        let query = try response.map(IMDbPosterQuery.self)
        var films = [Poster]()
        for item in query.items {
            //films.append(createFilm(from: item))
            print(item.title)
        }
        return films
    }
    
    private func handleFilmQuery(from response: Moya.Response) throws -> Film {
        let film = try response.map(IMDbFilm.self)
        var actors = [Film.Actor]()
        for star in film.actorList {
            actors.append(Film.Actor(id: star.id, imageURL: star.image, name: star.name, asCharacter: star.asCharacter))
        }
        var similars = [Poster]()
        for similar in film.similars {
            similars.append(Poster(id: similar.id, title: similar.title, imageURL: similar.image, imdbRating: similar.imDbRating))
        }
        return Film(
            id: film.id,
            title: film.title,
            year: film.year,
            posterURL: film.image,
            runtimeStr: film.runtimeStr,
            plot: film.plot,
            genres: film.genres,
            directors: film.directors,
            writers: film.writers,
            actors: actors,
            contentRating: film.contentRating,
            imdbRating: film.imDbRating,
            imdbRatingVotes: film.imDbRatingVotes,
            similars: similars)
    }
}

enum RepositoryError: Error {
    case mappingError
}

enum ListOption {
    case inTheaters
    case comingSoon
    case mostPopular
}
