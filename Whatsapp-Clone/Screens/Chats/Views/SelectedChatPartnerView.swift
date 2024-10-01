//
//  SelectedChatPartnerView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 22/09/24.
//

import SwiftUI

struct SelectedChatPartnerView: View {
    let users: [UserItems]
    let onTapHandler : (_ user: UserItems) -> Void
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(users){item in
                    chatPartnerView(item)
                }
            }
        }
    }
    private func chatPartnerView(_ user: UserItems) -> some View{
        VStack(alignment: .center){
            CircularProfileImageView(user.profileImageUrl,size: .medium)
                .overlay(alignment: .topTrailing){
                    cancelButton(user)
                }
            Text(user.username)
                .frame(width: 70)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(Color.whatsAppBlack)
                .font(.system(size:14))
        }
    }
    private func cancelButton(_ user: UserItems) -> some View{
        Button{
            onTapHandler(user)
        }label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(5)
                .background(Color(.systemGray2))
                .clipShape(.circle)
                
        }
    }
}

#Preview {
    SelectedChatPartnerView(users: UserItems.placeholders){user in
        
    }
}
