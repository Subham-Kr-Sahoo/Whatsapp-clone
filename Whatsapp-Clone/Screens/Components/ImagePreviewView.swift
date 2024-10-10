//
//  ImagePreviewView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 10/10/24.
//

import SwiftUI
import Kingfisher

struct ImagePreviewView: View {
    let text : String
    let image : String
    let dismiss : () -> Void
    @State private var rotation : Double = 0
    let screenWidth = UIScreen.main.bounds.width
    @State private var isExpanded: Bool = false
    @State private var flipHorizontally : Bool = false
    @State private var flipVertically : Bool = false
    @State private var scale: CGFloat = 1.0
     @State private var lastScale: CGFloat = 1.0
    var body: some View {
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                scale = lastScale * value
                scale = max(0.5,min(scale,5.0))
            }
            .onEnded { value in
                lastScale = scale
            }
        ZStack{
            KFImage(URL(string:image))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity,maxHeight:.infinity)
                .ignoresSafeArea()
                .rotationEffect(.degrees(rotation),anchor: .center)
                .scaleEffect(x: flipHorizontally ? -1 : 1 , y : flipVertically ? -0.99 : 0.99,anchor: .center)
                .gesture(magnificationGesture)
                .scaleEffect(scale)
            if text != "" {
                textPreview()
                    .multilineTextAlignment(.center)
            }
                
        }
        .overlay(alignment:.topLeading){
            cancelButton()
        }
        .overlay(alignment: .topTrailing){
            HStack(spacing:0){
                rotateLeft()
                rotateRight()
                flipHorizontal()
                flipVertical()
            }
        }
    }
    
    private func textPreview() -> some View {
        VStack {
            Spacer()
            if text.numberOfLines() > 3 {
                ScrollView(showsIndicators:false){
                    Text(text)
                        .lineLimit(isExpanded || text.numberOfLines() <= 3 ? text.numberOfLines() + 3 : 3)
                        .font(.system(size: 17))
                        .foregroundStyle(.whatsAppBlack)
                    if text.numberOfLines() > 3 {
                        buttonToExpandOrCollapse()
                    }
                }
                .padding(8)
                .cornerRadius(16)
                .frame(height: isExpanded ? 160 : 100)
                .background{
                    (RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .fill(.ultraThinMaterial)
                }
                .overlay(
                    (RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .stroke(Color(.systemGray5))
                )
                .animation(.smooth, value: isExpanded)
            }
            else {
                Text(text)
                    .padding(8)
                    .background(                    (RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        (RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .stroke(Color(.systemGray5))
                    )
                
            }
        }
        .padding(.bottom,20)
        .padding(8)
    }
    
    private func buttonToExpandOrCollapse() -> some View {
        Button{
            isExpanded.toggle()
        }label: {
            Text(isExpanded ? "... Show Less" : "... Show More")
                .foregroundStyle(.blue)
                .padding(.leading,4)
        }
        .frame(width: UIScreen.main.bounds.width - 32, alignment: .trailing)
    }
    
    private func flipHorizontal() -> some View {
        Button{
            withAnimation(.smooth){
                flipHorizontally.toggle()
            }
        }label: {
            Image(systemName: "flip.horizontal")
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
    
    private func flipVertical() -> some View {
        Button{
            withAnimation(.smooth){
                flipVertically.toggle()
            }
        }label: {
            Image(systemName: "arrow.trianglehead.up.and.down.righttriangle.up.righttriangle.down")
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
    
    private func rotateRight() -> some View {
        Button{
            withAnimation(.smooth){
                rotation += 90
            }
        }label: {
            Image(systemName: "rotate.right")
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
    
    private func rotateLeft() -> some View {
        Button{
            withAnimation(.smooth){
                rotation -= 90
            }
        }label: {
            Image(systemName: "rotate.left")
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
}

#Preview {
    ImagePreviewView(text: "", image: ""){
        
    }
}

