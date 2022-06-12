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
    }
    @Published var searchStatus: SearchStatus = .start
    @Published var searchQuery = "" {
        didSet {
            if searchQuery != oldValue {
                updateSearch()
            }
        }
    }
    @Published var searchFieldIsFocused = false
    
    private func updateSearch() {
        if searchQuery == "" {
            searchStatus = .start
            return
        } else {
            searchStatus = .empty
        }
    }
    
}
