//
//  FilmsListViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class FilmsListViewModel: ObservableObject {
    private let apiKey = "k_nrvtd8at"
    @Published private(set) var inTheaters = [IMDbFilm]()
    @Published private(set) var comingSoon = [IMDbFilm]()
    
    init() {
        fetchFilms()
    }
    
    func fetchFilms() {
        let api = APIService()
        var url = "https://imdb-api.com/en/API/InTheaters/\(apiKey)"
        api.fetchFilms(from: url) { result in
            switch result {
            case .success(let query):
                DispatchQueue.main.async { [weak self] in
                    self?.inTheaters = query.items
                }
            case .failure(let error):
                print(error)
            }
        }
        url = "https://imdb-api.com/en/API/ComingSoon/\(apiKey)"
        api.fetchFilms(from: url) { result in
            switch result {
            case .success(let query):
                DispatchQueue.main.async { [weak self] in
                    self?.comingSoon = query.items
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
