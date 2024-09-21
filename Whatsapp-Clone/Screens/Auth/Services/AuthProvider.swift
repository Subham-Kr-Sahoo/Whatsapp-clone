//
//  AuthProvider.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum AuthState {
    case pending,loggedIn,loggedOut
}

protocol AuthProvider {
    static var shared: AuthProvider { get }
    var authState : CurrentValueSubject<AuthState,Never> { get }
    func autoLogin() async
    func login(with email:String , and password:String) async throws
    func createAccount(for username:String,with email:String , and password:String) async throws
    func logOut() async throws
}

final class AuthManager : AuthProvider {
    
    private init() {
        
    }
    
    static let shared: AuthProvider = AuthManager()
    
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        
    }
    
    func login(with email: String, and password: String) async throws {
        
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = authResult.user.uid
        let newUser = UserItems(uid: uid, username: username, email: email)
        try await saveUserIntoDB(user: newUser)
    }
    
    func logOut() async throws {
        
    }
}
extension AuthManager {
    private func saveUserIntoDB(user:UserItems) async throws {
        let userDictionary = ["uid":user.uid,"username":user.username,"email":user.email]
        try await Database.database().reference().child("users").child(user.uid).setValue(userDictionary)
    }
}

struct UserItems : Identifiable,Hashable,Decodable {
    let uid : String
    let username : String
    let email : String
    var bio : String? = nil
    var profileImageUrl : String? = nil
    var id : String {
        return uid
    }
    var bioUnwrapped : String {
        return bio ?? "Hey there! I am using WhatsApp"
    }
}
