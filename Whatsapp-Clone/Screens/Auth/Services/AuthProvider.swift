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
    case emailLoginFailed(_  descriprion:String)
}
extension authError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .accounCreationError(let description):
            return description
        case .failedtoSaveUserInfo(let description):
            return description
        case .emailLoginFailed(let description):
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
    //MARK: AUTO LOGIN
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        }else{
            Task { await fetchUserInfo() }
        }
    }
    //MARK: LOGIN
    func login(with email: String, and password: String) async throws {
        do{
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUserInfo()
            print("Successfully signed in \(authResult.user.email ?? "")")
        }catch{
            print("Failed to Signed In to Account: \(email)")
            throw authError.emailLoginFailed(error.localizedDescription)
        }
    }
    //MARK: CREATE AN ACCOUNT
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
    //MARK: USER LOGOUT
    func logOut() async throws {
        do{
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("Successfully logged out")
        }catch{
            print("failed to log out : \(error.localizedDescription)")
        }
    }
}
extension AuthManager {
    //MARK: STORING IT TO IN DB
    private func saveUserIntoDB(user:UserItems) async throws {
        do{
            let userDictionary : [String:Any] = [.uid:user.uid,.username:user.username,.email:user.email]
            try await FirebaseConstants.userRef.child(user.uid).setValue(userDictionary)
        }catch{
            print("Failed to Save user info to the Database : \(error.localizedDescription)")
            throw authError.failedtoSaveUserInfo(error.localizedDescription)
        }
    }
    //MARK: RETRIVING THE USER INFO FROM DB
    private func fetchUserInfo() async {
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.userRef.child(currentID).observe(.value) {[weak self]DataSnapshot in
            guard let userDict = DataSnapshot.value as? [String:Any] else { return }
            let user = UserItems(dictionary: userDict)
            self?.authState.send(.loggedIn(user))
            print("\(user.username) is logged in")
        }withCancel: { error in
            print("Failed to get current user info \(error.localizedDescription)")
        }
    }
}

//MARK: test data for fetching users in a paginating manner
extension AuthManager {
    static let testAccounts : [String] = [
        "arunsingh@example.com",
        "rahulsharma@example.com",
        "priyapatel@example.com",
        "nehaagarwal@example.com",
        "amitverma@example.com",
        "deepakgupta@example.com",
        "sumanrao@example.com",
        "vikashkumar@example.com",
        "anjalipandey@example.com",
        "manojyadav@example.com",
        "rekhasingh@example.com",
        "sunilkhan@example.com",
        "purnimalokhande@example.com",
        "santhoshreddy@example.com",
        "shivapillai@example.com",
        "rakeshtiwari@example.com",
        "seemagupta@example.com",
        "rishabhdesai@example.com",
        "nidhiiyer@example.com",
        "abhishekmishra@example.com",
        "kritikabansal@example.com",
        "anuragjain@example.com",
        "poonamkhan@example.com",
        "naveenrao@example.com",
        "sandhyapatil@example.com",
        "sandeepbose@example.com",
        "gayatrichowdhury@example.com",
        "pradeeppatel@example.com",
        "jyotigupta@example.com",
        "anushkapandey@example.com",
        "karthiknambiar@example.com",
        "shreyaagarwal@example.com",
        "ankurbhatt@example.com",
        "lavanyaacharya@example.com",
        "ashutoshshah@example.com",
        "ruchikaverma@example.com",
        "siddhartmalik@example.com",
        "rajatmehta@example.com",
        "shrutikulkarni@example.com",
        "adarshyadav@example.com",
        "mohitsharma@example.com",
        "meenakshiiyer@example.com",
        "vandanadesai@example.com",
        "karanmishra@example.com",
        "riyaagarwal@example.com",
        "sohankumar@example.com",
        "tarundhawan@example.com",
        "meghatiwari@example.com",
        "jayashreebhat@example.com"
    ]
}

