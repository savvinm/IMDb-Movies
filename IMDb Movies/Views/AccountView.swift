//
//  AccountView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 11.06.2022.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let isOffline: Bool
    
    var body: some View {
        NavigationView {
            Form {
                userInfoBlock
                userSavedBlock
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Account")
        }
    }
    
    private var userSavedBlock: some View {
        Section(header: Text("")) {
            NavigationLink {
                SavedFilmsView()
            } label: {
                Text("Saved movies")
            }
        }
    }
    
    private var userInfoBlock: some View {
        Section {
            if isOffline {
                offilneMessage
                reconnectButton
            } else {
                userInfo
                signOutButton
            }
        }
        .font(.headline)
    }
    
    private var userInfo: some View {
        HStack(alignment: .center) {
            userImage
                .padding()
            VStack(alignment: .leading) {
                Text("Hello, \(authViewModel.getUserName() ?? "")!")
                Text(authViewModel.getUserEmail() ?? "")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    private var reconnectButton: some View {
        Button(action: { authViewModel.restoreSignIn() }, label: {
            HStack {
                Spacer()
                Text("Try again")
                    .foregroundColor(.blue)
                Spacer()
            }
        })
    }
    
    private var offilneMessage: some View {
        HStack {
           Spacer()
            Text("No internet connection\nCheck your connetction and try again")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
    }
    
    private var userImage: some View {
        AsyncImage(url: authViewModel.getUserImageURL()) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.size.width * 0.12, height: UIScreen.main.bounds.size.width * 0.12)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.12, height: UIScreen.main.bounds.size.width * 0.12)
    }
    
    private var signOutButton: some View {
        Button(action: { authViewModel.signOut() }, label: {
            HStack {
                Spacer()
                Text("Log out")
                    .foregroundColor(.red)
                Spacer()
            }
        })
    }
}
