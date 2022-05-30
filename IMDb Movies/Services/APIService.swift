//
//  APIService.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class APIService {
    func fetchFilms(from url: String, completion: @escaping (Result<IMDbQuery, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponseStatus))
                return
            }
            guard error == nil else {
                completion(.failure(.dataTaskError))
                return
            }
            guard let data = data else {
                completion(.failure(.corruptData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            do {
                let decodedData = try decoder.decode(IMDbQuery.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }

        }
        .resume()
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}
