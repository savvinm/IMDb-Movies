//
//  Repository.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 31.05.2022.
//

import Foundation
import Moya

protocol Repository {
    associatedtype T
    
    func list(option: ListOption, complitionHandler: @escaping ([T]?, Error?) -> Void)
}

struct FilmRepository: Repository {
    func list(option: ListOption, complitionHandler: @escaping ([Film]?, Error?) -> Void) {
        let provider = MoyaProvider<IMDbService>()
        let moyaOption: IMDbService
        switch option {
        case .inTheaters:
            moyaOption = .inTheaters
        case .comingSoon:
            moyaOption = .comingSoon
        }
        provider.request(moyaOption) { result in
            switch result {
            case .success(let response):
                do {
                    let query = try response.map(IMDbQuery.self)
                    var films = [Film]()
                    for item in query.items {
                        films.append(createFilm(from: item))
                    }
                    complitionHandler(films, nil)
                } catch {
                    complitionHandler(nil, RepositoryError.mappingError)
                }
            case .failure(let error):
                complitionHandler(nil, error)
                return
            }
            
        }
    }
    private func createFilm(from imdbFilm: IMDbFilm) -> Film {
        var genres = [String]()
        for pair in imdbFilm.genreList {
            genres.append(pair.value)
        }
        return Film(id: imdbFilm.id,
                    title: imdbFilm.title,
                    fullTitle: imdbFilm.fullTitle,
                    year: imdbFilm.year,
                    releaseState: imdbFilm.releaseState,
                    poster: imdbFilm.image,
                    runtimeStr: imdbFilm.runtimeStr,
                    plot: imdbFilm.plot,
                    genres: genres,
                    directors: imdbFilm.directors,
                    stars: imdbFilm.stars,
                    contentRating: imdbFilm.contentRating
        )
    }
}

enum RepositoryError: Error {
    case mappingError
}

enum ListOption {
    case inTheaters
    case comingSoon
}
