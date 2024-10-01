//
//  GroupMakeProfileImageofUserView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 23/09/24.
//

import SwiftUI

struct GroupMakeProfileImageofUserView: View {
    let users: [UserItems]
    let onTapHandler : (_ user: UserItems) -> Void
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 4)
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(users){item in
                    chatPartnerView(item)
                        .transition(.scale)
                        .animation(.easeInOut, value: users)
                }
            }
            .padding()
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
    GroupMakeProfileImageofUserView(users:UserItems.placeholders){user in
        
    }
}
