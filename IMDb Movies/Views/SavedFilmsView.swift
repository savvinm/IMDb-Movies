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
        GeometryReader { geometry in
            VStack(alignment: .center) {
                filterButtons
                filmsList(in: geometry)
            }
            .onAppear { savedFilmsViewModel.updateFilms() }
        }
    }
    
    private func filmsList(in geometry: GeometryProxy) -> some View {
        List {
            ForEach(savedFilmsViewModel.films) { film in
                InListPosterView(film: film, savedFilmsViewModel: savedFilmsViewModel)
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.25)
            }
            .onDelete { index in
                savedFilmsViewModel.deleteFilm(at: index.first!)
            }
            .padding()
        }
    }
    
    private var filterButtons: some View {
        HStack {
            Button(action: { savedFilmsViewModel.listSort = .byDate }, label: { Text("by date") })
                .padding()
            Button(action: { savedFilmsViewModel.listSort = .byName }, label: { Text("by name") })
                .padding()
        }
    }
}
