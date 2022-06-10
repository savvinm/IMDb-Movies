//
//  VK.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 10.06.2022.
//

import GoogleSignInSwift
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Text("Sign in")
            .onTapGesture {
                authViewModel.signIn()
            }
    }
}
