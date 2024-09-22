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
    var body: some View {
        NavigationStack{
            List{
                ForEach(chatOptions.allCases){item in
                    HeaderView(item: item)
                }
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
            .searchable(text: $searchText,prompt: "Search Name or Number")
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                trailingNavItems()
            }
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
