//
//  FilmsViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class FilmsViewModel: ObservableObject {
    @Published private(set) var inTheaters = [Film]()
    @Published private(set) var comingSoon = [Film]()
    @Published private(set) var top250 = [Film]()
    private let dbManager = DBManager()
    
    init() {
        fetchFilms()
    }
    
    func fetchFilms() {
        let repositiry = FilmRepository()
        /*repositiry.list(option: .inTheaters) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                self?.inTheaters = films
            }
        }*/
        repositiry.list(option: .comingSoon) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                self?.comingSoon = films
            }
        }
        /*repositiry.list(option: .top250) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                self?.top250 = films
            }
        }*/
    }
    
    func getRating(for film: Film) -> Int? {
        dbManager.getRating(for: film)
    }
    
    func rate(_ film: Film, rating: Int) {
        dbManager.setRating(for: film, rating: rating)
        objectWillChange.send()
    }
}
