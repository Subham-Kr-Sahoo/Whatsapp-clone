//
//  ChatOptionsFromContactsView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import SwiftUI

struct ChatOptionsFromContactsView<Content: View>: View {
    private let user : UserItems
    private let trailingItems : Content
    init(user: UserItems,@ViewBuilder trailingItems: ()->Content = {EmptyView()}) {
        self.user = user
        self.trailingItems = trailingItems()
    }
    var body: some View {
        HStack{
            CircularProfileImageView(user.profileImageUrl, size: .xSmall)
                .frame(width: 40,height: 40)
            VStack(alignment:.leading){
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            trailingItems
        }
    }
}

#Preview {
    ChatOptionsFromContactsView(user: .placeholder)
}
