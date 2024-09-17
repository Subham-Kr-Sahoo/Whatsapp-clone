//
//  BubbleTextView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import SwiftUI

struct BubbleTextView: View {
    let item : MessageItems
    var body: some View {
        VStack(alignment:item.horizontalAlignment,spacing:3){
            Text("Hello world how are you my name is subham kumar sahoo and i am currently creayting a messaheib app")
                .padding(10)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .applyTail(item.direction)
            timeStampTextView()
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
        .frame(maxWidth: .infinity,alignment: item.alignment)
        .padding(.leading,item.direction == .received ? 5 : 100)
        .padding(.trailing,item.direction == .received ? 100 : 5)
    }
    private func timeStampTextView() -> some View {
        HStack {
            Text("3:25 AM")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
            
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width:15,height: 18)
                    .foregroundStyle(Color.blue)
            }
        }
    }
}

#Preview {
    ScrollView {
        BubbleTextView(item: .sentplaceholder)
        BubbleTextView(item: .receiveplaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(.black)
}
