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
    @Published var errorState: (showError: Bool, errorMessage: String) = (false,"Error happened")
    
    var disableLoginButton: Bool {
        return email.isEmpty || password.isEmpty || isLoading
    }
    var disableSignupButton: Bool {
        return userName.isEmpty || email.isEmpty || password.isEmpty || isLoading
    }
    func signup() async {
        DispatchQueue.main.async{
            self.isLoading = true
        }
        do{
            try await AuthManager.shared.createAccount(for: userName, with: email, and: password)
        }catch{
            errorState.errorMessage = "Failed to create an account \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
}
