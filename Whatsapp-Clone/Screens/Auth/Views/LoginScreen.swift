//
//  LoginScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 20/09/24.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        NavigationStack{
            VStack {
                AuthHeaderView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.gradient.opacity(0.8))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoginScreen()
}
