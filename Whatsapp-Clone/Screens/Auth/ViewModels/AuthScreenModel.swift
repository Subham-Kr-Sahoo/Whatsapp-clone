//
//  AuthScreenModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import Foundation

final class AuthScreenModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var userName = ""
    @Published var isLoading = false
    
    var disableLoginButton: Bool {
        return email.isEmpty || password.isEmpty || isLoading
    }
    var disableSignupButton: Bool {
        return userName.isEmpty || email.isEmpty || password.isEmpty || isLoading
    }
    
}
