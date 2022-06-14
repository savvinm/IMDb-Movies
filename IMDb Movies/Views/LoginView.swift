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
        VStack {
            Spacer()
            Text("IMDb Movies")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            /*Image("signInImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.height * 0.3)
                .clipped()
                .cornerRadius(20)*/
            Spacer()
            Text("Sign in to start use IMDb Movies")
                .font(.headline)
                .foregroundColor(.secondary)
            googleLoginButton
                .padding()
            Spacer()
        }
        .padding()
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
