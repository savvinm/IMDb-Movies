//
//  SearchView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 12.06.2022.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel = SearchViewModel()
    @FocusState var searchFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                searchField
                    .frame(maxWidth: .infinity, idealHeight: 50)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .padding()
                resultBlock
                    .padding()
            }
            .onTapGesture { searchFieldIsFocused = false }
            .navigationBarHidden(true)
            .padding(.top)
        }
    }
    
    private var resultBlock: some View {
        VStack {
            switch searchViewModel.searchStatus {
            case .start:
                MessageInCenter(message: "Start typing to search for movies")
            case .empty:
                MessageInCenter(message: "Nothing found. Try something else")
            case .something:
                resultScroll
            case .searching:
                searchingView
            }
        }
    }
    
    private var searchingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    private var resultScroll: some View {
        GeometryReader { geometry in
            ScrollView {
                ForEach(searchViewModel.results) { poster in
                    InListPosterView(poster: poster)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                        .padding()
                }
            }
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search", text: $searchViewModel.searchQuery)
                .disableAutocorrection(true)
                .focused($searchFieldIsFocused)
                .frame(height: 50)
                .overlay(alignment: .trailing) {
                    if searchViewModel.searchQuery != ""{
                        Button(action: { searchViewModel.searchQuery = "" }, label: { clearButtonIcon })
                    }
                }
        }
        .padding(.leading, 25)
        .font(.headline)
    }
    
    private var clearButtonIcon: some View {
        Image(systemName: "x.circle.fill")
            .font(.headline)
            .padding()
            .foregroundColor(.secondary)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
