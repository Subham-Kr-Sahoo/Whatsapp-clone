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
        VStack{
            Circle()
                .fill(.black.opacity(0.7))
                .frame(width: 60, height: 60)
                .overlay(alignment: .topTrailing){
                    cancelButton(user)
                }
            Text(user.username)
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
