//
//  TextInputArea.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct TextInputArea: View {
    @State private var text = ""
    var body: some View {
        HStack(alignment:.bottom,spacing: 8){
            imagePickerButton()
            audioRecorderButton()
            messageTextField()
            sendMessageButton()
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
        TextField("Message",text: $text,axis: .vertical)
            .padding(5)
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
            
        }label: {
            Image(systemName: "photo.on.rectangle")
                .imageScale(.large)
                .padding(.bottom,2)
                
        }
    }
    
    private func sendMessageButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(6)
                .background(Color.gray).opacity(1.5)
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

#Preview {
    TextInputArea()
}