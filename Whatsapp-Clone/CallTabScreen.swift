//
//  CallTabScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct CallTabScreen: View {
    @State private var searchText = ""
    @State private var callHistory = callHistorys.all
    var body: some View {
        NavigationStack{
            List{
                Section{
                    createCallLinkSection()
                }
                Section{
                    ForEach(0..<15){_ in
                        recentCallItems()
                    }
                }header: {
                    Text("Recents")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.whatsAppBlack)
                        .textCase(nil)
                }
            }.navigationTitle("Calls")
             .searchable(text: $searchText)
             .toolbar{
                 leadingNavItem()
                 trailingNavItem()
                 principalNavItem()
             }
        }
    }
}
extension CallTabScreen {
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Edit") {
                
            }
        }
    }
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button{
                
            }label: {
                Image(systemName: "phone.arrow.up.right")
            }
        }
    }
    @ToolbarContentBuilder
    private func principalNavItem() -> some ToolbarContent {
        ToolbarItem(placement:.principal) {
            Picker("",selection: $callHistory){
                ForEach(callHistorys.allCases){item in
                    Text(item.rawValue.capitalized)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            .frame(width:150)
        }
    }
    private enum callHistorys : String , CaseIterable , Identifiable {
        case all , missed
        var id: String {
            return rawValue
        }
    }
}

private struct createCallLinkSection : View {
    var body: some View {
        HStack{
            Image(systemName: "link")
                .foregroundStyle(Color.blue)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(.circle)
            VStack(alignment:.leading){
                Text("Create Call Link")
                    .foregroundStyle(.blue)
                Text("Share a link for your whatsapp call")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
        }
    }
}

private struct recentCallItems : View {
    var body: some View {
        HStack{
            Circle()
                .frame(width:UpdatesTabScreen.Constant.imageDimensions-10)
            
            recentcallTextView()
            
            Spacer()
            
            Text("Yesterday")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
            
            Image(systemName: "info.circle")
            
        }
    }
    
    private func recentcallTextView() -> some View{
        VStack(alignment:.leading){
            Text("RahulDev Nayak")
            
            HStack(spacing:5){
                Image(systemName: "phone.arrow.up.right.fill")
                Text("Outgoing")
            }
            .font(.system(size: 14))
            .foregroundStyle(.gray)
        }
    }
}



#Preview {
    CallTabScreen()
}
