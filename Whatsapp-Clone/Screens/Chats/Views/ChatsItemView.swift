//
//  ChatsItemView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct ChatsItemView: View {
    var body: some View {
        HStack(alignment:.center,spacing: 10){
            Circle()
                .frame(width:60,height:60)
            
            VStack(alignment:.leading,spacing: 6){
                titleTextView()
                lastMessagePreview()
            }
        }
    }
    private func titleTextView() -> some View {
        HStack{
            Text("Username Here...")
                .lineLimit(1)
                .bold()
            
            Spacer()
            
            Text("5:50 PM")
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessagePreview() -> some View{
        Text("Hello World")
            .font(.system(size: 16))
            .lineLimit(1)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ChatsItemView()
}