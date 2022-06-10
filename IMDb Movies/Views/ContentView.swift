//
//  SwiftUIView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 10.06.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        switch authViewModel.state {
        case .signedOut: LoginView()
        case .signedIn: HomeView()
        }
    }
}

