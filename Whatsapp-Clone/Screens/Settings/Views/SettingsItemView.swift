//
//  SettingsItemView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct SettingsItemView: View {
    let item : SettingsItem
    var body: some View {
        HStack(spacing:12){
            iconImageView()
            Text(item.title)
                .font(.system(size: 18))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func iconImageView() -> some View {
        switch item.imageType {
        case .systemImage:
            Image(systemName: item.imageName)
                .bold()
                .font(.callout)
                .frame(width:30,height:30)
                .foregroundStyle(.white)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius:8, style: .continuous))
                
        case .assetImage:
            Image(item.imageName)
                .renderingMode(.template)
                .padding(3)
                .frame(width:30,height:30)
                .foregroundStyle(.white)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius:8, style: .continuous))
        }
    }
}

#Preview {
    SettingsItemView(item: .chats)
}
