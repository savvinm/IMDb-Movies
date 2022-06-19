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
        case offline
    }
    
    private let clientId = "180084617862-tnl35nlvefv7innflt1a53isgi1o8nae.apps.googleusercontent.com"
    @Published private(set) var state: SignInState = .loading
    
    init() {
        restoreSignIn()
        offlineSignIn()
    }
    
    func restoreSignIn() {
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
    
    private func offlineSignIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [unowned self] in
            if UserDefaults.standard.bool(forKey: "isSignedIn") && state != .signedIn {
                state = .offline
            }
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
            UserDefaults.standard.set(true, forKey: "isSignedIn")
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        state = .signedOut
        UserDefaults.standard.set(false, forKey: "isSignedIn")
    }
    
    func getUserName() -> String? {
        if state == .signedIn {
            return GIDSignIn.sharedInstance.currentUser?.profile?.givenName
        }
        return nil
    }
    
    func getUserEmail() -> String? {
        if state == .signedIn {
            return GIDSignIn.sharedInstance.currentUser?.profile?.email
        }
        return nil
    }
    
    func getUserImageURL() -> URL? {
        if state == .signedIn {
            return GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 100)
        }
        return nil
    }
}
