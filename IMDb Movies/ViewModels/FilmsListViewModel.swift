//
//  FilmsListViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class FilmsListViewModel: ObservableObject {
    private let apiKey = "k_nrvtd8at"
    @Published private(set) var films = [IMDbFilm]()
    
    func fetchFilms() {
        let url = "https://imdb-api.com/en/API/InTheaters/\(apiKey)"
        let api = APIService()
        print(url)
        api.fetchInTheaters(from: url) { result in
            switch result {
            case .success(let query):
                DispatchQueue.main.async { [weak self] in
                    self?.films = query.items
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
