//
//  VK.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 10.06.2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
       googleLoginButton
    }
    
    private var googleLoginButton: some View {
        Button(action: { authViewModel.signIn() }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.cyan)
                    .opacity(0.85)
                Text("Sign in with Google")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
        })
    }
}
