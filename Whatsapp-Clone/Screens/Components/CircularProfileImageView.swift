//
//  CircularProfileImageView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 01/10/24.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    let profileImageUrl: String?
    let size: Size
    let fallbackImage: FallBackImage
    
    init(_ profileImageUrl: String? = nil,size: Size){
        self.profileImageUrl = profileImageUrl
        self.size = size
        self.fallbackImage = .directChatIcon
    }
    var body: some View {
        if let profileImageUrl {
            KFImage(URL(string:profileImageUrl))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .scaledToFill()
                .frame(width: size.dimension,height: size.dimension)
                .clipShape(Circle())
        }else {
            placeholderImageView()
        }
    }
    private func placeholderImageView() -> some View {
        Image(systemName: fallbackImage.rawValue)
            .resizable()
            .scaledToFit()
            .imageScale(.large)
            .foregroundStyle(Color.placeholder)
            .frame(width: size.dimension, height: size.dimension)
            .background(Color.white)
            .clipShape(.circle)
    }
}
extension CircularProfileImageView {
    enum Size {
        case mini,xSmall,small,medium,large,xLarge
        case custom(CGFloat)
        
        var dimension : CGFloat {
            switch self {
            case .mini:
                return 30
            case .xSmall:
                return 40
            case .small:
                return 50
            case .medium:
                return 60
            case .large:
                return 80
            case .xLarge:
                return 120
            case .custom(let dimension):
                return dimension
            }
        }
    }
    enum FallBackImage : String {
        case directChatIcon = "person.circle.fill"
        case groupChatIcon = "person.2.circle.fill"
        
        init (for membersCount: Int){
            switch membersCount {
            case 2:
                self = .directChatIcon
            default:
                self = .groupChatIcon
            }
        }
    }
}

extension CircularProfileImageView {
    init (_ channel: ChatItem,size: Size){
        self.profileImageUrl = channel.coverImgaeUrl
        self.size = size
        self.fallbackImage = FallBackImage(for: channel.membersCount)
    }
}
#Preview {
    CircularProfileImageView(size:.large)
}
