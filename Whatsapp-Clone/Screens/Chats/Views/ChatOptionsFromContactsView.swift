//
//  ChatOptionsFromContactsView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import SwiftUI

struct ChatOptionsFromContactsView: View {
    let user : UserItems
    var body: some View {
        HStack{
            Circle()
                .frame(width: 40,height: 40)
            VStack(alignment:.leading){
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    ChatOptionsFromContactsView(user: .placeholder)
}
