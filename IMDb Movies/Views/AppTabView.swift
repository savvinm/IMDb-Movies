//
//  AppTabView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 11.06.2022.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            homeTab
            searchTab
            accountTab
        }
    }
    
    private var homeTab: some View {
        HomeView().tabItem {
            VStack {
                Image(systemName: "film")
                Text("Movies")
            }
        }
    }
    
    private var searchTab: some View {
        SearchView().tabItem {
            VStack {
                Image(systemName: "text.magnifyingglass")
                Text("Search")
            }
        }
    }
    
    private var accountTab: some View {
        AccountView(isOffline: false).tabItem {
            VStack {
                Image(systemName: "list.bullet")
                Text("Account")
            }
        }
    }
}
