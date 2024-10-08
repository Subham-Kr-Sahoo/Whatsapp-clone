//
//  TextInputArea.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct TextInputArea: View {
    @State private var isPulsing = false
    @Binding var textMessage : String
    @Binding var isRecording : Bool
    @Binding var elapsedTime : TimeInterval
    var disabledSendButton : Bool
    let actionHandler : (_ action : userAction) -> Void
    private var isSendButtonDisabled : Bool {
        return disabledSendButton || isRecording
    }
    var body: some View {
        HStack(alignment:.bottom,spacing: 8){
            imagePickerButton()
                .disabled(isRecording)
                .grayscale(isRecording ? 0.8 : 0)
            audioRecorderButton()
            if isRecording {
                audioSessionRecordingView()
            }else{
                messageTextField()
            }
            sendMessageButton()
                .disabled(isSendButtonDisabled)
                .grayscale(isSendButtonDisabled ? 0.8 : 0)
        }
        .padding(.bottom)
        .padding(.horizontal,8)
        .padding(.top,10)
        .background(.whatsAppWhite)
        .animation(.spring, value: isRecording)
        .onChange(of: isRecording) { oldValue,newValue in
            if newValue {
                withAnimation(.easeInOut(duration:1.5).repeatForever()){
                    isPulsing = true
                }
            }else{
                isPulsing = false
            }
        }
    }
    
    private func audioSessionRecordingView() -> some View {
        HStack{
            Image(systemName: "circle.fill")
                .foregroundStyle(Color.red)
                .font(.caption)
                .scaleEffect(isPulsing ? 1.5 : 1)
            
            Text("Recording Audio")
                .font(.callout)
                .lineLimit(1)
            
            Spacer()
            
            Text(elapsedTime.formatElapsedTime)
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(.horizontal,8)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .clipShape(.capsule)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.blue.opacity(0.1))
        )
        .overlay{
            textViewBorder()
        }
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
            actionHandler(.recordAudio)
            isRecording.toggle()
        }label: {
            Image(systemName:isRecording ? "square.fill" : "mic.fill")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(6)
                .background(isRecording ? .red : .blue)
                .clipShape(.circle)
                .padding(.horizontal,3)
        }
    }
}

extension TextInputArea {
    enum userAction {
        case presentPhotoPicker
        case sendMessage
        case recordAudio
    }
}

#Preview {
    TextInputArea(textMessage: .constant(""), isRecording: .constant(false), elapsedTime: .constant(0),disabledSendButton: false) { action in
        
    }
}
