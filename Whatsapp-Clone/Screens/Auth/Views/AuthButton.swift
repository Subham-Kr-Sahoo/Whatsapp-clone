//
//  AuthButton.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import SwiftUI

struct AuthButton: View {
    let title : String
    let onTap : () -> Void
    @Environment(\.isEnabled) private var isEnabled
    private var backGroundColor : Color{
        return isEnabled ? Color.white : Color.white.opacity(0.3)
    }
    private var textGroundColor : Color{
        return isEnabled ? Color.green : Color.white
    }
    var body: some View {
        Button{
            onTap()
        }label:{
            HStack{
                Text(title)
                Image(systemName: "arrow.right")
                
            }
            .font(.headline)
            .foregroundStyle(textGroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backGroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .green.opacity(0.2), radius: 10)
            .padding(.horizontal,32)
        }
    }
}

#Preview {
    ZStack {
        Color.green.opacity(0.7)
        AuthButton(title: "Login") {
            
        }
    }
}
