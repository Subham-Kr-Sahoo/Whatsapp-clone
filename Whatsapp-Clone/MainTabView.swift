//
//  MainTabView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct MainTabView: View {
    private let currentUser : UserItems
    init(_ currentUser: UserItems){
        self.currentUser = currentUser
        makeTabBarOpaque()
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    var body: some View {
        TabView{
            UpdatesTabScreen()
                .tabItem {
                    Image(systemName: Tab.updates.icon)
                    Text(Tab.updates.title)
                }
            CallTabScreen()
                .tabItem {
                    Image(systemName: Tab.calls.icon)
                    Text(Tab.calls.title)
                }
            CommunityTabScreen()
                .tabItem {
                    Image(systemName: Tab.communities.icon)
                    Text(Tab.communities.title)
                }
            ChatsTabScreen(currentUser)
                .tabItem {
                    Image(systemName: Tab.chats.icon)
                    Text(Tab.chats.title)
                }
            SettingsTabScreen()
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                    Text(Tab.settings.title)
                }
        }
    }
    private func makeTabBarOpaque(){
        let apperance = UITabBarAppearance()
        apperance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = apperance
        UITabBar.appearance().scrollEdgeAppearance = apperance
    }
}

extension MainTabView{
    
    private enum Tab : String {
        case updates,calls,communities,chats,settings
        
        fileprivate var title : String {
            return rawValue.capitalized
        }
        
        fileprivate var icon : String {
            switch self {
            case .updates:
                return "circle.dashed.inset.filled"
            case .calls:
                return "phone"
            case .communities:
                return "person.3"
            case .chats:
                return "message"
            case .settings:
                return "gear"
            }
        }
    }
}

#Preview {
    MainTabView(.placeholder)
}
