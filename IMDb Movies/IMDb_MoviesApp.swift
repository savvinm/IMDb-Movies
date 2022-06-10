//
//  IMDb_MoviesApp.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import SwiftUI

@main
// swiftlint: disable all
struct IMDb_MoviesApp: App {
    @ObservedObject var authViewModel: AuthViewModel

    init() {
        authViewModel = AuthViewModel()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
