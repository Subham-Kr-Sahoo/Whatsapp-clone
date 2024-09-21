//
//  RoutesView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import SwiftUI

struct RoutesView: View {
    @StateObject private var viewModel = RouteScreenModel()
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
        case .loggedIn(let loggedInUser):
            MainTabView(loggedInUser)
        case .loggedOut :
            LoginScreen()
        }
    }
}

#Preview {
    RoutesView()
}
