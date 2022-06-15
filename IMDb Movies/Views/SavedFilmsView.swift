//
//  SavedFilmsView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 15.06.2022.
//

import SwiftUI

struct SavedFilmsView: View {
    @ObservedObject var savedFilmsViewModel = SavedFilmsViewModel()
    
    var body: some View {
        VStack {
            
        }
        .onAppear { savedFilmsViewModel.updateFilms() }
    }
}
