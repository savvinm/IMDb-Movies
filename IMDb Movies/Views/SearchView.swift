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
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, idealHeight: 50)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                resultBlock
            }
            .padding(.top)
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private var resultBlock: some View {
        VStack {
            switch searchViewModel.searchStatus {
            case .start:
                startMessage
            case .empty:
                emptyMessage
            case .something:
                resultScroll
            }
        }
        .onTapGesture {
            searchFieldIsFocused = false
        }
    }
    
    private var startMessage: some View {
        VStack {
            Spacer()
            Text("Start typing to search for moves")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
    }
    
    private var emptyMessage: some View {
        VStack {
            Spacer()
            Text("Nothing found. Try typing something else")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
    }
    
    private var resultScroll: some View {
        ScrollView {
            
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search", text: $searchViewModel.searchQuery, onEditingChanged: { (isBegin) in
                withAnimation(.easeInOut) {
                    searchViewModel.searchFieldIsFocused = isBegin
                }
            })
            .disableAutocorrection(true)
            .focused($searchFieldIsFocused)
            .frame(height: 50)
            .overlay(alignment: .trailing) {
                if searchViewModel.searchQuery != ""{
                    Button(action: { searchViewModel.searchQuery = "" }, label: { clearButtonIcon })
                }
            }
        }
        .padding(.leading)
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
