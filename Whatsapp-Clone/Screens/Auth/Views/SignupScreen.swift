//
//  SignupScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import SwiftUI

struct SignupScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var authScreenModel : AuthScreenModel
    var body: some View {
        VStack{
            Spacer()
            AuthHeaderView()
            AuthTextField(type: .email, text: $authScreenModel.email)
                .autocapitalization(.none)
            AuthTextField(type: .custom("Username", "at"), text: $authScreenModel.userName)
            AuthTextField(type: .password, text: $authScreenModel.password)
            AuthButton(title: "Create an Account") {
                Task { await authScreenModel.signup() }
            }
            .disabled(authScreenModel.disableSignupButton)
            Spacer()
            backButton()
                .padding(.bottom,30)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background{
            LinearGradient(colors: [.green,.green.opacity(0.8),.teal], startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    private func backButton() -> some View {
        Button{
            dismiss()
        }label: {
            HStack{
                Image(systemName: "sparkles")
                (
                    Text("Already Have an Account ? ")
                    +
                    Text("Login").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignupScreen(authScreenModel: AuthScreenModel())
}
