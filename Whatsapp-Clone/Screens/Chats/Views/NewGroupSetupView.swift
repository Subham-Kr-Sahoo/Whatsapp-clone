//
//  NewGroupSetupView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 22/09/24.
//

import SwiftUI

struct NewGroupSetupView: View {
    @State var groupName: String = ""
    @ObservedObject var viewModel : ChatPartnerPickerViewModel
    var body: some View {
        List{
            Section{
                groupNameView()
            }
            Section{
                Text("Disappearing Messages")
                Text("Group Permissions")
            }
            Section{
                SelectedChatPartnerView(users: viewModel.selectedChatPartner) { user in
                    viewModel.handleItemSelection(user)
                }
            }header: {
                HStack {
                    Text("Participants")
                        .bold()
                    let count = viewModel.selectedChatPartner.count
                    let maxCount = channelContents.maxGroupParticipants
                    Text("\(count) of \(maxCount)")
                }
            }
            .listRowBackground(Color.clear)
        }
        .padding(.top,-20)
        .navigationTitle("New Group")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            trailingNavItem()
        }
    }
    private func groupNameView() -> some View{
        HStack(alignment: .center){
            profileImageView()
                
            TextField("", text: $groupName,prompt: Text("Group Name"),axis: .vertical)
                .autocorrectionDisabled()
        }
    }
    private func profileImageView() -> some View{
        Button{
            
        }label: {
            ZStack{
                Image(systemName: "camera")
                    .imageScale(.large)
            }
            .frame(width:60,height:60)
            .background(Color(.systemGray6))
            .clipShape(.circle)
            .padding(.trailing,8)
            .foregroundStyle(.blue)
        }
    }
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button{
                
            }label: {
                Text("Create")
                    .bold()
            }
            .disabled(groupName.isEmpty || viewModel.disabledNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        NewGroupSetupView(viewModel: ChatPartnerPickerViewModel())
    }
}
