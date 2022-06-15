//
//  SavedFilmsViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 15.06.2022.
//

import Foundation

class SavedFilmsViewModel: ObservableObject {
    @Published var films = [Film]()
    private let interactor = FilmsInteractor()
    
    func updateFilms() {
        films = interactor.getSavedFilms()
        print(films)
    }
}
