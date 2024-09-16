//
//  SettingsTabScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct SettingsTabScreen: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            List{
                SettingsHeaderView()
                Section{
                    SettingsItemView(item: .broadCastLists)
                    SettingsItemView(item: .starredMessages)
                    SettingsItemView(item: .linkedDevices)
                }
                Section{
                    SettingsItemView(item: .account)
                    SettingsItemView(item: .privacy)
                    SettingsItemView(item: .chats)
                    SettingsItemView(item: .notifications)
                    SettingsItemView(item: .storage)
                }
                Section{
                    SettingsItemView(item: .help)
                    SettingsItemView(item: .tellFriend)
                }
            }
            .navigationTitle("Settings")
            .searchable(text: $searchText)
        }
    }
}

private struct SettingsHeaderView: View {
    var body: some View {
        Section{
            HStack(alignment:.center,spacing: 10){
                Circle()
                    .frame(width:55,height:55)
                UserInfoTextView()
            }
            SettingsItemView(item: .avatar)
        }
    }
    private func UserInfoTextView() -> some View {
        VStack(alignment:.leading,spacing: 0){
            HStack{
                Text("Subham Kumar Sahoo")
                    .font(.system(size: 20))
                
                Spacer()
                
                Image(.qrcode)
                    .renderingMode(.template)
                    .padding(5)
                    .foregroundStyle(.blue)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            
            Text("Hey there! I am using WhatsApp")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
        }
        .lineLimit(1)
    }
    
}

#Preview {
    SettingsTabScreen()
}
