//
//  ChannelCreationTextView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 30/09/24.
//

import SwiftUI

struct ChannelCreationTextView: View {
    @State private var showSheet = false
    @Environment(\.colorScheme) private var colorScheme
    private var backgroundColor:Color {
        return colorScheme == .dark ? .black : .yellow
    }
    private var textColor:Color {
        return colorScheme == .dark ? .yellow : .black
    }
    var body: some View {
        NavigationStack{
            Button{
                showSheet.toggle()
            }label:{
                ZStack(alignment:.top){
                    (
                        Text(Image(systemName: "lock.fill"))
                        + Text(" Messages and calls are end-to-end encrypted. No one outside of this chat,not even WhatsApp, can read or listen to them.")
                        + Text(" Tap to learn more.")
                            .bold()
                    )
                    .multilineTextAlignment(.center)
                    .font(.system(size:15))
                    .foregroundStyle(textColor)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal,30)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            sheetView()
                .presentationDetents([.fraction(0.85)])
        }
        
    }
}

struct sheetView : View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    private var backgroundColor:Color {
        return colorScheme == .dark ? .black.opacity(0.7) : .gray.opacity(0.9)
    }
    var body: some View {
        NavigationStack{
            VStack{
                roundedSlider()
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                HStack{
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark")
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                }
                imageAndTextView()
                lineView()
                ButtonView()
                Spacer()
            }
            .padding()
        }
        .background(Color(backgroundColor))
    }
    private func roundedSlider() -> some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(width:60,height:6)
    }
    private func imageAndTextView() -> some View {
        VStack(spacing: 18){
            Image(.lock)
                .resizable()
                .frame(width:137,height:92)
                .imageScale(.large)
            
            Text("Your chat and calls private")
                .font(.system(size: 24))
                .bold()
            
            Text("End-to-end encryption keeps personal messages and calls between you and the people you choose. Not even Whatsapp can read or listen to them.This includes your:")
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
    private func lineView() -> some View {
        VStack {
            individualLineView("text.bubble","Text and voice messages")
            individualLineView("phone", "Audio and video calls")
            individualLineView("paperclip", "Photos, videos and documents")
            individualLineView("pin", "Location Sharing")
            individualLineView("circle.dashed.inset.filled", "Status updates")
        }
        .padding()
    }
    private func individualLineView(_ imageName:String, _ text:String) -> some View {
        HStack(spacing:12){
            Image(systemName: imageName)
                .resizable()
                .frame(width:18,height:18)
            
            Text(text)
                .font(.system(size: 18))
            
            Spacer()
        }
    }
    //This button will direct to a webpage
    private func ButtonView() -> some View {
        Button{
            openURL("https://www.whatsapp.com/security")
        }label: {
            Text("Learn More")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(18)
        }
    }
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ChannelCreationTextView()
    //sheetView()
}
