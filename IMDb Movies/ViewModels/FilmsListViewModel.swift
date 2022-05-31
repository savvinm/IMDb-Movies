//
//  FilmsListViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class FilmsListViewModel: ObservableObject {
    @Published private(set) var inTheaters = [Film]()
    @Published private(set) var comingSoon = [Film]()
    
    init() {
        fetchFilms()
    }
    
    func fetchFilms() {
        let repositiry = FilmRepository()
        repositiry.list(option: .inTheaters) { [weak self] films, error in
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
        }
    }
}
