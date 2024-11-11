//
//  ChatsTabScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct ChatsTabScreen: View {
    @State private var searchText = ""
    @StateObject private var viewModel : ChatTabViewModel
    @State private var showSheet = false
    @Environment(\.colorScheme) private var colorScheme
    init(_ currentUser: UserItems){
        self._viewModel = StateObject(wrappedValue: ChatTabViewModel(currentUser))
    }
    var users : [ChatItem] {
        if searchText.isEmpty {
            return handleType(whichType)
        }
        else {
            let filteredUsers = handleType(whichType).filter { user in
                user.channelName.lowercased().hasPrefix(searchText.lowercased())
            }
            return filteredUsers
        }
    }
    @State private var whichType : type = .all
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
                ForEach(users){channel in
                    NavigationLink{
                        ChatRoomScreen(channel: channel)
                    } label: {
                        ChatsItemView(channel: channel)
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
            .sheet(isPresented: $viewModel.showNewMemberAddScreen) {
                NewMemberAddScreen(onCreate: viewModel.onNewChatCreation)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if let newChannel = viewModel.newChat {
                    ChatRoomScreen(channel: newChannel)
                }
            }
        }
    }
    
    private func allChatButton() -> some View {
        Button{
            withAnimation(.easeInOut) {
                whichType = .all
            }
        }label: {
            Text("All")
                .font(.callout)
                .foregroundStyle(whichType == .all ? .white : .whatsAppBlack)
                .padding(.horizontal,12)
                .padding(.vertical,5)
                .background(whichType == .all ? Color.blue.opacity(0.8) : Color.gray.opacity(0.4))
                .clipShape(.capsule)
        }
    }
    
    private func unreadChatButton() -> some View{
        Button{
            withAnimation(.easeInOut) {
                whichType = .unread
            }
        }label: {
            Text("Unread")
                .font(.callout)
                .foregroundStyle(whichType == .unread ? .white : .whatsAppBlack)
                .padding(.horizontal,12)
                .padding(.vertical,5)
                .background(whichType == .unread ? Color.blue.opacity(0.8) : Color.gray.opacity(0.4))
                .clipShape(.capsule)
        }
    }
    
    private func groupsChatButton() -> some View{
        Button{
            withAnimation(.easeInOut) {
                whichType = .groups
            }
        }label: {
            Text("Groups")
                .font(.callout)
                .foregroundStyle(whichType == .groups ? .white : .whatsAppBlack)
                .padding(.horizontal,12)
                .padding(.vertical,5)
                .background(whichType == .groups ? Color.blue.opacity(0.8) : Color.gray.opacity(0.4))
                .clipShape(.capsule)
        }
    }
    
    private func handleType(_ type : type) -> [ChatItem] {
        switch type {
        case .all:
            return viewModel.channels
        case .groups:
            return viewModel.channels.filter {$0.membersCount > 2}
        case .unread:
            // i have to check it when i will implement the logic of unread chats, currently it is returning nothing
            return []
        }
    }
}

enum type {
    case all
    case groups
    case unread
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
            viewModel.showNewMemberAddScreen = true
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
            Text("Your personal messages are")
            Button{
                showSheet = true
            }label: {
                Text("end-to-end encrypted")
                    .foregroundStyle(.blue)
            }
            .sheet(isPresented: $showSheet) {
                sheetView(colorScheme: colorScheme)
                    .foregroundStyle(Color.whatsAppBlack)
                    .presentationDetents([.fraction(0.85)])
            }
            .padding(.leading,-4)
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal,22)
    }
}

#Preview {
    ChatsTabScreen(.placeholder)
}
