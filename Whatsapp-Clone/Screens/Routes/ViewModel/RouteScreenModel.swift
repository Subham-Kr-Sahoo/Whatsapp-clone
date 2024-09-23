//
//  RouteScreenModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import Foundation
import Combine

final class RouteScreenModel : ObservableObject {
    @Published private(set) var authState = AuthState.pending
    private var cancellables : AnyCancellable?
    init() {
        cancellables = AuthManager.shared.authState.receive(on: DispatchQueue.main)
            .sink {[weak self] AuthState in
                self?.authState = AuthState
            }
//        AuthManager.testAccounts.forEach { exampleMail in
//            registerTestAccount(with: exampleMail)
//        }
    }
//    private func registerTestAccount(with email:String){
//        Task{
//            let username = email.replacingOccurrences(of: "@example.com", with: "")
//            try? await AuthManager.shared.createAccount(for: username, with: email, and: "1234567890")
//        }
//    }
}
