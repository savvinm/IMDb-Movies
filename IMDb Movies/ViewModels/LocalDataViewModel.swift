//
//  LocalDataViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 18.06.2022.
//

import SwiftUI

class LocalDataViewModel: ObservableObject {
    enum ListOption: String, CaseIterable {
        case byDate = "by date"
        case byName = "by name"
    }
    
    @Published private(set) var films = [Film]()
    var listSort: ListOption = .byDate {
        didSet {
            if listSort != oldValue {
                updateFilms()
            }
        }
    }
    private let interactor = FilmsInteractor()
    
    func getImage(in path: String) -> UIImage? {
        do {
            return try interactor.readImageInFileSystem(path: path)
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteFilm(at index: Int) {
        interactor.deleteFilm(films[index])
        films.remove(at: index)
    }
    
    func updateFilms() {
        switch listSort {
        case .byName:
            films = interactor.getSavedFilms(sortOption: .byName)
        case .byDate:
            films = interactor.getSavedFilms(sortOption: .byDate)
        }
    }
}
