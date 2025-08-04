//
//  ContentView.swift
//  project_palma
//
//  Created by Christian Kleeberg on 10.07.25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var isShowingNotification: Bool = false
    @State private var isShowingSettings: Bool = false

    var body: some View {
        ZStack {
            Background(BackgroundColor: .white)
            
            VStack {
                TopBar(isShowingNotification: $isShowingNotification, isShowingSettings: $isShowingSettings)
                
                TabView {
                    Group {
                        MapView()
                            .tabItem {
                                littleImage(imageName: "map.fill")
                                Text("Map")
                            }
                        
                        EventsView()
                            .tabItem {
                                littleImage(imageName: "calendar.badge.clock")
                                Text("Calendar")
                            }
                        
                        CommunityView()
                            .tabItem {
                                littleImage(imageName: "rectangle.3.group.fill")
                                Text("Groups")
                            }
                        
                        FriendsView()
                            .tabItem {
                                littleImage(imageName: "figure.2")
                                Text("Friends")
                            }
                    }
                    .toolbarBackground(.white, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                }
                .accentColor(Color("BrandPrimaryColor"))
            }
            
            if isShowingNotification {
                NotificationView(isShowingNotification: $isShowingNotification)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
            if isShowingSettings {
                SettingsView(isShowingSettings: $isShowingSettings)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

