//
//  SearchViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 12.06.2022.
//

import Foundation

class SearchViewModel: ObservableObject {
    enum SearchStatus {
        case empty
        case something
        case start
        case searching
    }
    @Published private(set) var searchStatus: SearchStatus = .start
    @Published var searchQuery = "" {
        didSet {
            if searchQuery != oldValue {
                updateSearch()
            }
        }
    }
    @Published private(set) var results = [Poster]()
    private let interactor = FilmsInteractor()
    
    private func updateSearch() {
        guard searchQuery != "" else {
            searchStatus = .start
            return
        }
        searchStatus = .searching
        interactor.searchFilms(searchQuery: searchQuery) { [weak self] query, films, error in
            guard query == self?.searchQuery else {
                return
            }
            if let error = error {
                print(error)
            }
            if let films = films {
                DispatchQueue.main.async {
                    self?.results = films
                    self?.searchStatus = films.isEmpty ? .empty : .something
                }
            }
        }
    }
}
