//
//  LoginScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 20/09/24.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var authScreenModel = AuthScreenModel()
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                AuthHeaderView()
                AuthTextField(type: .email, text: $authScreenModel.email)
                    .autocapitalization(.none)
                AuthTextField(type: .password, text: $authScreenModel.password)
                forgotPasswordButton()
                AuthButton(title: "Login") {
                    Task{ await authScreenModel.login() }
                }
                .disabled(authScreenModel.disableLoginButton)
                Spacer()
                signUpButton()
                    .padding(.bottom,30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.gradient.opacity(0.8))
            .ignoresSafeArea()
            .alert(isPresented: $authScreenModel.errorState.showError) {
                Alert(
                    title: Text(authScreenModel.errorState.errorMessage),
                    dismissButton: .default(Text("OK"))
                    )
            }
        }
    }
    private func forgotPasswordButton() -> some View {
        Button{
            
        }label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.trailing,32)
                .bold()
                .padding(.vertical)
        }
    }
    private func signUpButton() -> some View {
        NavigationLink{
            SignupScreen(authScreenModel: authScreenModel)
        }label: {
            HStack{
                Image(systemName: "sparkles")
                (
                    Text("Don't have an account ? ")
                    +
                    Text("Create One").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginScreen()
}
