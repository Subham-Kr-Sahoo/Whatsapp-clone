//
//  ChatRoomScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(0..<12){_ in
                    Text("PlaceHolder")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.gray.opacity(0.1))
                }
            }
        }
        .toolbar(.hidden,for: .tabBar)
        .toolbar{
            leadingNavItems()
            trailingNavItems()
        }
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}
extension ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                Circle()
                    .frame(width:40,height:40)
                Text("Subham Kumar Sahoo")
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button{
                    
                }label: {
                    Image(systemName: "video")
                }
                
                Button{
                    
                }label: {
                    Image(systemName: "phone")
                }
            }
            
            
        }
    }
}
#Preview {
    NavigationStack {
        ChatRoomScreen()
    }
}
