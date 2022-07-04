//
//  SearchViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 12.06.2022.
//

import Combine
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
                startDelay()
            }
        }
    }
    @Published private(set) var results = [Poster]()
    private let interactor = FilmsInteractor()
    private var workItem: DispatchWorkItem?
    private var cancellable: AnyCancellable?
    
    private func startDelay() {
        guard searchQuery != "" else {
            results = []
            searchStatus = .start
            return
        }
        searchStatus = .searching
        workItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: workItem)
        self.workItem = workItem
    }
    
    private func performSearch() {
        let query = searchQuery
        cancellable = interactor.getPosters(option: .search(searchQuery: searchQuery))
            .sink { [weak self] films in
                guard query == self?.searchQuery else {
                    return
                }
                self?.results = films
                self?.searchStatus = films.isEmpty ? .empty : .something
            }
    }
}
