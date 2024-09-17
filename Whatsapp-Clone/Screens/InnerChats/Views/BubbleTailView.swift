//
//  BubbleTailView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import SwiftUI

struct BubbleTailView: View {
    var direction : messageDirection
    private var foregroundColour : Color {
        return direction == .received ? .bubbleWhite : .bubbleGreen
    }
    var body: some View {
        Image(direction == .sent ? .outgoingTail : .incomingTail)
            .renderingMode(.template)
            .resizable()
            .frame(width:10,height:10)
            .offset(y:3)
            .foregroundStyle(foregroundColour)
    }
}

#Preview {
    BubbleTailView(direction: .random)
}
