//
//  FilmsListViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import Combine
import Foundation

class FilmsListViewModel: ObservableObject {
    enum Statuses {
        case loading
        case error(error: Error)
        case succes
    }
    @Published private(set) var status: Statuses = .loading
    @Published private(set) var inTheaters = [Poster]()
    @Published private(set) var comingSoon = [Poster]()
    @Published private(set) var mostPopular = [Poster]()
    private let interactor = FilmsInteractor()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchFilms()
    }
    
    func fetchFilms() {
        cancellables.removeAll()
        interactor.getPosters(option: .inTheaters)
            .sink { [weak self] films in
                self?.inTheaters = films
                self?.status = .succes
            }
            .store(in: &cancellables)
        interactor.getPosters(option: .comingSoon)
            .sink { [weak self] films in
                self?.comingSoon = films
                self?.status = .succes
            }
            .store(in: &cancellables)
        interactor.getPosters(option: .mostPopular)
            .sink { [weak self] films in
                self?.mostPopular = films
                self?.status = .succes
            }
            .store(in: &cancellables)
    }
}
