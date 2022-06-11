//
//  FilmsListViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Foundation

class FilmsListViewModel: ObservableObject {
    enum Statuses {
        case loading
        case error(error: Error)
        case success
    }
    @Published private(set) var status: Statuses = .loading
    @Published private(set) var inTheaters = [Poster]()
    @Published private(set) var comingSoon = [Poster]()
    @Published private(set) var mostPopular = [Poster]()
    
    init() {
        fetchFilms()
    }
    
    func fetchFilms() {
        let interactor = FilmsInteractor()
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
        interactor.getPosters(option: .mostPopular) { [weak self] films, error in
            if let error = error {
                print(error)
            }
            if let films = films {
                DispatchQueue.main.async {
                    self?.mostPopular = films
                    self?.status = .success
                }
            }
        }
    }
}
