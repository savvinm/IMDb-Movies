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
            signOutButton
        }
        .font(.headline)
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
