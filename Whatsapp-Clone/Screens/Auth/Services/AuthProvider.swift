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
    case pending,loggedIn(UserItems),loggedOut
}

protocol AuthProvider {
    static var shared: AuthProvider { get }
    var authState : CurrentValueSubject<AuthState,Never> { get }
    func autoLogin() async
    func login(with email:String , and password:String) async throws
    func createAccount(for username:String,with email:String , and password:String) async throws
    func logOut() async throws
}

enum authError : Error {
    case accounCreationError(_ description:String)
    case failedtoSaveUserInfo(_ description:String)
}
extension authError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .accounCreationError(let description):
            return description
        case .failedtoSaveUserInfo(let description):
            return description
        }
    }
}

final class AuthManager : AuthProvider {
    
    private init() {
        Task { await autoLogin() }
    }
    
    static let shared: AuthProvider = AuthManager()
    
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        }else{
            Task { await fetchUserInfo() }
        }
    }
    
    func login(with email: String, and password: String) async throws {
        
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        do{
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItems(uid: uid, username: username, email: email)
            try await saveUserIntoDB(user: newUser)
            self.authState.send(.loggedIn(newUser))
        }catch{
            print("Failed to Create an Account: \(error.localizedDescription)")
            throw authError.accounCreationError(error.localizedDescription)
        }
    }
    
    func logOut() async throws {
        
    }
}
extension AuthManager {
    private func saveUserIntoDB(user:UserItems) async throws {
        do{
            let userDictionary = ["uid":user.uid,"username":user.username,"email":user.email]
            try await Database.database().reference().child("users").child(user.uid).setValue(userDictionary)
        }catch{
            print("Failed to Save user info to the Database : \(error.localizedDescription)")
            throw authError.failedtoSaveUserInfo(error.localizedDescription)
        }
    }
    private func fetchUserInfo() async {
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(currentID).observe(.value) {[weak self]DataSnapshot in
            guard let userDict = DataSnapshot.value as? [String:Any] else { return }
            let user = UserItems(dictionary: userDict)
            self?.authState.send(.loggedIn(user))
            print("\(user.username) is logged in")
        }withCancel: { error in
            print("Failed to get current user info \(error.localizedDescription)")
        }
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

extension UserItems {
    init(dictionary:[String:Any]){
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? nil
    }
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
