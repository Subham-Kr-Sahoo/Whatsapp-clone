//
//  UpdatesTabScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct UpdatesTabScreen: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            List{
                statusSectionHeader()
                    .listRowBackground(Color.clear)
                statusSection()
                
                Section{
                    recentUpdatesItemView()
                }header: {
                    Text("recent updates")
                }
                
                Section{
                    channelListView()
                }header: {
                    channelSectionHeader()
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Updates")
            .searchable(text: $searchText)
        }
    }
    
    private func channelSectionHeader() -> some View {
        HStack{
            Text("Channels")
                .bold()
                .font(.title3)
                .textCase(nil)
                .foregroundStyle(.whatsAppBlack)
            
            Spacer()
            
            Button{
                
            }label: {
                Image(systemName: "plus")
                    .padding(7)
                    .background(Color(.systemGray5))
                    .clipShape(.circle)
            }
        }
    }
}
extension UpdatesTabScreen {
    enum Constant {
        static let imageDimensions: CGFloat = 55
    }
}

private struct statusSectionHeader : View {
    var body: some View {
        HStack(alignment:.top){
            Image(systemName: "circle.dashed")
                .foregroundStyle(.blue)
                .imageScale(.large)
            (Text("Use Status to share photos, text and videos that disappear in 24 hours.")
            + Text(" ")
            + Text("Status Privacy")
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            )
            Image(systemName:"xmark")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.whatsAppWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10, style:.continuous))
    }
}

private struct statusSection : View {
    var body: some View {
        HStack(alignment:.center){
            ZStack {
                Circle()
                    .frame(width:55,height:55)
                
                Circle()
                    .fill(Color.blue)
                    .frame(width:20,height:20)
                    .overlay{
                        Image(systemName: "plus")
                            .imageScale(.small)
                            .foregroundStyle(.white)
                    }
                    .offset(x:20-2,y:20-2)
            }.frame(width:55,height:55)
            
            VStack(alignment:.leading){
                Text("My Status")
                    .font(.callout)
                    .bold()
                Text("Add to my status")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
            
            Spacer()
            
            cameraButton()
            pencilButton()
        }
    }
    
    private func cameraButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "camera.fill")
                .padding(10)
                .background{
                    Circle()
                        .foregroundStyle(.gray).opacity(0.4)
                }
        }
    }
    
    private func pencilButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "pencil")
                .padding(10)
                .background{
                    Circle()
                        .foregroundStyle(.gray).opacity(0.4)
                }
        }
    }
}

private struct recentUpdatesItemView : View {
    var body: some View {
        HStack{
            Circle()
                .frame(width: UpdatesTabScreen.Constant.imageDimensions,height: UpdatesTabScreen.Constant.imageDimensions)
            VStack(alignment:.leading){
                Text("Ashutosh Maharana")
                    .font(.callout)
                    .bold()
                Text("1h ago")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
        }
    }
}

private struct channelListView : View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Stay updated on topics that matter to you. Find channels to follow below")
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(.horizontal)
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(0..<5){_ in
                        channelItemView()
                    }
                }
            }
            
            Button{
                
            }label: {
                Text("Explore more")
                    .bold()
                    .foregroundStyle(.whatsAppWhite)
                    .padding(.vertical,8)
                    .padding(.horizontal,16)
                    .background(Color.blue)
                    .clipShape(.capsule)
            }
            .padding(.vertical)
        }
    }
}

private struct channelItemView : View {
    var body: some View {
        VStack(alignment:.center){
            Circle()
                .frame(width: UpdatesTabScreen.Constant.imageDimensions,height: UpdatesTabScreen.Constant.imageDimensions)
            Text("Real Madrid C.F.")
            
            Button{
                
            }label: {
                Text("Follow")
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(.capsule)
            }
        }
        .padding(.horizontal,16)
        .padding(.vertical)
        .overlay{
            RoundedRectangle(cornerRadius:10)
                .stroke(Color(.systemGray3),lineWidth: 1)
        }
    }
}
#Preview {
    UpdatesTabScreen()
}
