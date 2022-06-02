//
//  FilmsListViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class FilmsListViewModel: ObservableObject {
    @Published private(set) var inTheaters = [Poster]()
    @Published private(set) var comingSoon = [Poster]()
    @Published private(set) var mostPopular = [Poster]()
    
    init() {
        fetchFilms()
    }
    
    func fetchFilms() {
        let repositiry = FilmsRepository()
        /*repositiry.list(option: .inTheaters) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                self?.inTheaters = films
            }
        }
        repositiry.list(option: .comingSoon) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                self?.comingSoon = films
            }
        }*/
        repositiry.list(option: .mostPopular) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                self?.mostPopular = films
            }
        }
    }
}
