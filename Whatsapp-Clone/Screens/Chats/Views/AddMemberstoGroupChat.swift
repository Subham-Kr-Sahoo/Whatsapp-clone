//
//  AddMemberstoGroupChat.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 22/09/24.
//

import SwiftUI

struct AddMemberstoGroupChat: View {
    @ObservedObject var viewModel : ChatPartnerPickerViewModel
    var body: some View {
        List{
            if viewModel.showSelectedUser {
                SelectedChatPartnerView(users: viewModel.selectedChatPartner){user in
                    viewModel.handleItemSelection(user)
                }
            }
            Section{
                ForEach(viewModel.users.sorted {$0.id < $1.id}) { item in
                    Button{
                        viewModel.handleItemSelection(item)
                    }label: {
                        groupChatPartner(item)
                    }
                }
            }
            if viewModel.isPaginateable && viewModel.searchText.isEmpty{
                loadMoreUsers()
            }
        }
        .padding(.top,-20)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: viewModel.showSelectedUser)
        .searchable(text: $viewModel.searchText,placement: .navigationBarDrawer(displayMode: .always),prompt: "Search Name or Number")
        .toolbar {
            titleView()
            trailingNavItem()
        }
        .onChange(of: viewModel.searchText) {
            Task{
                viewModel.clearUsers()
                await viewModel.fetchUsers()
            }
        }
    }
    private func groupChatPartner(_ user : UserItems) -> some View {
        ChatOptionsFromContactsView(user: user){
            Spacer()
            let isSelected = viewModel.isUserSelected(user)
            let imageName = isSelected ? "checkmark.circle.fill" : "circle"
            let color = isSelected ? Color.blue : Color(.systemGray4)
            Image(systemName:imageName)
                .foregroundStyle(color)
                .imageScale(.large)
        }
    }
    private func loadMoreUsers() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}
extension AddMemberstoGroupChat {
    @ToolbarContentBuilder
    private func titleView() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack{
                Text("Add Participants")
                    .bold()
                let count = viewModel.selectedChatPartner.count
                let maxCount = channelContents.maxGroupParticipants
                Text("\(count)"+"/"+"\(maxCount)")
                    .font(.footnote)
            }
        }
    }
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button{
                viewModel.navStack.append(.setUpGroupChat)
            }label: {
                Text("Next")
                    .bold()
            }
            .disabled(viewModel.disabledNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        AddMemberstoGroupChat(viewModel: ChatPartnerPickerViewModel())
    }
}
