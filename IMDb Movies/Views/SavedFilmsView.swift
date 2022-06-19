//
//  SavedFilmsView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 15.06.2022.
//

import SwiftUI

struct SavedFilmsView: View {
    @ObservedObject var localDataViewModel = LocalDataViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if localDataViewModel.films.isEmpty {
                    emptyMessage
                } else {
                    filterButtons
                    filmsList(in: geometry)
                }
            }
            .onAppear { localDataViewModel.updateFilms() }
            .toolbar {
                if !localDataViewModel.films.isEmpty {
                    EditButton()
                }
            }
        }
    }
    
    private var emptyMessage: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("There is nothing yet. Add movies to your saved list by tapping \(Image(systemName: "bookmark"))")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
        .padding()
    }
    
    private func filmsList(in geometry: GeometryProxy) -> some View {
        List {
            ForEach(localDataViewModel.films) { film in
                InListPosterView(film: film, localDataViewModel: localDataViewModel)
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.25)
                    .padding(.vertical)
            }
            .onDelete { index in
                localDataViewModel.deleteFilm(at: index.first!)
            }
        }
    }
    
    private var filterButtons: some View {
        Picker("Choose sorting option", selection: $localDataViewModel.listSort) {
            ForEach(LocalDataViewModel.ListOption.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
