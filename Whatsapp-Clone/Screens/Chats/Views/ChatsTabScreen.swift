//
//  ChatsTabScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct ChatsTabScreen: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            HStack {
                allChatButton()
                unreadChatButton()
                groupsChatButton()
                Spacer()
            }.padding(.leading)
            List{
                archivedButton()
                ForEach(0..<12){_ in
                    NavigationLink{
                        ChatRoomScreen()
                    } label: {
                        ChatsItemView()
                    }
                }
                inboxFooterView()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .toolbar{
                leadingNavItems()
                trailingNavItems()
            }
        }
    }
    
    private func allChatButton() -> some View {
        Button{
            
        }label: {
            Text("All")
                .font(.callout)
                .foregroundStyle(.whatsAppBlack)
                .padding(.horizontal,12)
                .padding(.vertical,5)
                .background(Color.gray.opacity(0.4))
                .clipShape(.capsule)
        }
    }
    
    private func unreadChatButton() -> some View{
        Button{
            
        }label: {
            Text("Unread")
                .font(.callout)
                .foregroundStyle(.whatsAppBlack)
                .padding(.horizontal,12)
                .padding(.vertical,5)
                .background(Color.gray.opacity(0.4))
                .clipShape(.capsule)
        }
    }
    
    private func groupsChatButton() -> some View{
        Button{
            
        }label: {
            Text("Groups")
                .font(.callout)
                .foregroundStyle(.whatsAppBlack)
                .padding(.horizontal,12)
                .padding(.vertical,5)
                .background(Color.gray.opacity(0.4))
                .clipShape(.capsule)
        }
    }
}

extension ChatsTabScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button{
                    
                }label: {
                    Label("Select Chats",systemImage: "checkmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            aiButton()
            cameraButton()
            newChatButton()
        }
    }
    
    private func aiButton() -> some View{
        Button{
            
        }label: {
            Image(.circle)
        }
    }
    
    private func cameraButton() -> some View{
        Button{
            
        }label: {
            Image(systemName: "camera")
        }
    }
    
    private func newChatButton() -> some View{
        Button{
            
        }label: {
            Image(.plus)
        }
    }
    
    private func archivedButton() -> some View{
        Button{
            
        }label: {
            Label("Archived",systemImage: "archivebox.fill")
                .bold()
                .padding(5)
                .foregroundStyle(.gray)
        }
    }
    
    private func inboxFooterView() -> some View {
        HStack{
            Image(systemName: "lock.fill")
            (
            Text("Your personal messages are ")
            +
            Text("end-to-end encrypted")
                .foregroundStyle(.blue)
            )
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal,22)
    }
}

#Preview {
    ChatsTabScreen()
}
