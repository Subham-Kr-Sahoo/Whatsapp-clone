//
//  AdminMessageTextView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 30/09/24.
//

import SwiftUI

struct AdminMessageTextView: View {
    let chat : ChatItem
    // if somebody else made this group it doesnot shows the name of the user who created that group - fixed it
    var body: some View {
        VStack{
            if chat.iscreatedByMe {
                textView("You created this group. Tap to add members")
            }else{
                textView("\(chat.creatorName) created this group.")
                textView("\(chat.creatorName) added you")
            }
        }
        .frame(maxWidth: .infinity)
    }
    private func textView(_ text:String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .font(.footnote)
            .padding(8)
            .padding(.horizontal,5)
            .background(.bubbleWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x:0,y:20)
    }
}

#Preview {
    AdminMessageTextView(chat: .placeholder)
}
