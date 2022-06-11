//
//  AccountView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 11.06.2022.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                
            } label: {
                Text("Saved movies")
            }
        }
    }
    
    private var userInfoBlock: some View {
        Section {
            HStack {
                Text("Hello \(authViewModel.getUserName() ?? "")!")
                    .padding()
                Spacer()
            }
            signOutButton
        }
        .font(.headline)
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
