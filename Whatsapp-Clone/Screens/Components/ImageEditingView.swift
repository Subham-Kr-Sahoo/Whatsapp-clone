//
//  ImageEditingView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 05/10/24.
//

import SwiftUI

struct ImageEditingView: View {
    let image : UIImage
    let dismiss : () -> Void
    var body: some View {
        Image(uiImage:image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity,maxHeight:.infinity)
            .ignoresSafeArea()
            .overlay(alignment:.topLeading){
                cancelButton()
            }
            .overlay(alignment: .topTrailing){
                HStack(spacing:8){
                    rotateOrCropButton()
                    filterView()
                    pencilView()
                    addTextView()
                    saveView()
                }
                .padding([.top,.trailing],10)
            }
    }
    private func cancelButton() -> some View {
        Button{
            dismiss()
        }label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(Circle())
                .padding(10)
                .bold()
        }
    }
    
    private func rotateOrCropButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "crop.rotate")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(Circle())
                .bold()
        }
    }
    
    private func addTextView() -> some View {
        Button{
            
        }label: {
            Image(systemName: "plus")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(Circle())
                .bold()
        }
    }
    
    private func pencilView() -> some View {
        Button{
            
        }label: {
            Image(systemName: "pencil")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(Circle())
                .bold()
        }
    }
    
    private func filterView() -> some View {
        Button{
            
        }label: {
            Image(systemName: "camera.filters")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(Circle())
                .bold()
        }
    }
    
    private func saveView() -> some View {
        Button{
            
        }label: {
            Text("SAVE")
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(.capsule)
                .bold()
        }
    }

}

#Preview {
    ImageEditingView(image: .stubImage0){
        
    }
}
