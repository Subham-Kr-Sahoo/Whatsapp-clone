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
    }
}
