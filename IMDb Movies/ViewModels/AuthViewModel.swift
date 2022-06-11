//
//  AuthViewModel.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 10.06.2022.
//

import Foundation
import GoogleSignIn

class AuthViewModel: ObservableObject {
    
    enum SignInState {
        case signedIn
        case signedOut
        case loading
    }
    
    private let clientId = "180084617862-tnl35nlvefv7innflt1a53isgi1o8nae.apps.googleusercontent.com"
    @Published private(set) var state: SignInState = .loading
    
    init() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] _, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                state = .signedIn
            }
        } else {
            state = .signedOut
        }
    }
    
    func signIn() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            state = .signedIn
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        state = .signedOut
    }
    
    func getUserName() -> String? {
        if state == .signedIn {
            return GIDSignIn.sharedInstance.currentUser?.profile?.givenName
        }
        return nil
    }
}
