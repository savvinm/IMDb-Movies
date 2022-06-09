//
//  FilmsInteractor.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 09.06.2022.
//

import Foundation
import Moya

class FilmsInteractor {
    enum ListOption {
        case inTheaters
        case comingSoon
        case mostPopular
    }
    enum InteractorErrors: Error {
        case mappingError
    }
    private let repository = FilmsRepository()
    
    func getPosters(option: ListOption, complitionHandler: @escaping ([Poster]?, Error?) -> Void) {
        repository.fetchList(option: option) { response, error in
            guard let response = response else {
                complitionHandler(nil, error)
                return
            }
            do {
                let films = try self.handleRatingPosterQuery(from: response)
                complitionHandler(films, nil)
            } catch {
                complitionHandler(nil, InteractorErrors.mappingError)
            }
        }
    }
    
    func getFilm(movieId: String, complitionHandler: @escaping (Film?, Error?) -> Void) {
        repository.fetchTitle(movieId: movieId) { response, error in
            guard let response = response else {
                complitionHandler(nil, error)
                return
            }
            do {
                let film = try self.handleFilmQuery(from: response)
                complitionHandler(film, nil)
            } catch {
                complitionHandler(nil, InteractorErrors.mappingError)
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
    
    private func parseAsCharacter(from value: String) -> String {
        let blocks = value.components(separatedBy: "as ")
        if blocks.count == 2 {
            return blocks.first!
        }
        return value
    }
    
    private func handleFilmQuery(from response: Moya.Response) throws -> Film {
        let film = try response.map(IMDbFilm.self)
        var actors = [Film.Actor]()
        for star in film.actorList {
            actors.append(Film.Actor(id: star.id, imageURL: star.image, name: star.name, asCharacter: parseAsCharacter(from: star.asCharacter)))
        }
        var similars = [Poster]()
        for similar in film.similars {
            similars.append(Poster(id: similar.id, title: similar.title, imageURL: similar.image, imdbRating: similar.imDbRating))
        }
        return Film(
            id: film.id,
            title: film.title,
            fullTitle: film.fullTitle,
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
