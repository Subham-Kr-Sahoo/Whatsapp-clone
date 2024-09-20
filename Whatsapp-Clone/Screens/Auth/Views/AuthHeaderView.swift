//
//  AuthHeaderView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 20/09/24.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        HStack{
            Image(.whatsapp)
                .resizable()
                .frame(width: 40,height: 40)
            Text("WhatsApp")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    AuthHeaderView()
}
