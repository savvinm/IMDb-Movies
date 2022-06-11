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
    
    private var accountTab: some View {
        AccountView().tabItem {
            VStack {
                Image(systemName: "list.bullet")
                Text("Account")
            }
        }
    }
}
