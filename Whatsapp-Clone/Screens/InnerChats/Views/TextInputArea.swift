//
//  TextInputArea.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage : String
    let actionHandler : (_ action : userAction) -> Void
    private var disabledSendButton : Bool {
        return textMessage.isEmptyOrWhiteSpace
    }
    var body: some View {
        HStack(alignment:.bottom,spacing: 8){
            imagePickerButton()
            audioRecorderButton()
            messageTextField()
            sendMessageButton()
                .disabled(disabledSendButton)
                .grayscale(disabledSendButton ? 0.8 : 0)
        }
        .padding(.bottom)
        .padding(.horizontal,8)
        .padding(.top,10)
        .background(.whatsAppWhite)
    }
    private func textViewBorder() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color(.systemGray5),lineWidth: 1)
    }
    private func messageTextField() -> some View {
        // axis kaa kaam yahi heh kie agar text bounded size se jyada hua toh
        // size konse direction me badhega
        TextField("Message",text: $textMessage,axis: .vertical)
            .padding(5)
            .lineLimit(5) //here line limit works great if the line exceeds it works as a scroll view
            .autocorrectionDisabled()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay{
                textViewBorder()
            }
    }
    private func imagePickerButton() -> some View {
        Button{
            actionHandler(.presentPhotoPicker)
        }label: {
            Image(systemName: "photo.on.rectangle")
                .imageScale(.large)
                .padding(.bottom,2)
                
        }
    }
    
    private func sendMessageButton() -> some View {
        Button{
            actionHandler(.sendMessage)
        }label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(6)
                .background(Color.blue)
                .clipShape(.circle)
                
        }
    }
    
    private func audioRecorderButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "mic.fill")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(6)
                .background(.blue)
                .clipShape(.circle)
                .padding(.horizontal,3)
        }
    }
}

extension TextInputArea {
    enum userAction {
        case presentPhotoPicker
        case sendMessage
    }
}

#Preview {
    TextInputArea(textMessage: .constant("")){action in 
        
    }
}
