//
//  NewMemberAddScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import SwiftUI

struct NewMemberAddScreen: View {
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChatPartnerPickerViewModel()
    var body: some View {
        NavigationStack(path:$viewModel.navStack){
            List{
                HeaderView(item: .newGroup)
                    .onTapGesture {
                        viewModel.navStack.append(.addGroupChatMembers)
                    }
                HeaderView(item: .newContact)
                HeaderView(item: .newCommuity)
                Section{
                    ForEach(1..<18) {_ in
                        ChatOptionsFromContactsView(user: .placeholder)
                    }
                }header: {
                    Text("Contacts On Whatsapp")
                        .textCase(nil)
                        .bold()
                }
            }
            .padding(.top,-20)
            .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always),prompt: "Search Name or Number")
            .navigationTitle("New Chat")
            .navigationDestination(for: chatCreationRoute.self, destination: { Route in
                destinationView(for: Route)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                trailingNavItems()
            }
        }
    }
}
extension NewMemberAddScreen {
    @ViewBuilder
    private func destinationView(for route: chatCreationRoute) -> some View {
        switch route {
        case .addGroupChatMembers:
            AddMemberstoGroupChat(viewModel: viewModel)
        case .setUpGroupChat:
            NewGroupSetupView(viewModel: viewModel)
        }
    }
}

extension NewMemberAddScreen {
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            cancelButton()
        }
    }
    private func cancelButton() -> some View {
        Button{
            dismiss()
        }label: {
            Image(systemName: "xmark")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(.circle)
        }
    }
}

extension NewMemberAddScreen {
    private struct HeaderView : View {
        let item : chatOptions
        var body : some View {
            Button{
                
            }label: {
                buttonBody()
            }
        }
        private func buttonBody() -> some View {
            HStack{
                Image(systemName: item.imageName)
                    .font(.system(size: 16))
                    .frame(width: 40,height: 40)
                    .background(Color(.systemGray5))
                    .clipShape(.circle)
                
                Text(item.title)
                    .fontWeight(.semibold)
            }
        }
    }
}

enum chatOptions : String,CaseIterable,Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newCommuity = "New Community"
    
    var id : String {return rawValue}
    var title : String {return rawValue}
    var imageName : String {
        switch self {
        case .newGroup:
            return "person.2.fill"
        case .newContact:
            return "person.fill.badge.plus"
        case .newCommuity:
            return "person.3.fill"
        }
    }
}


#Preview {
    NewMemberAddScreen()
}
