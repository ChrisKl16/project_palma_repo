//
//  ContentView.swift
//  project_palma
//
//  Created by Christian Kleeberg on 10.07.25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @AppStorage("user") private var userData: Data?
    @State private var isShowingNotification: Bool = false
    @State private var isShowingSettings: Bool = false
    @State private var hasCompletedOnboarding: Bool = false
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if !hasCompletedOnboarding && !isLoading {
                OnboardingView()
                    .transition(.opacity)
            } else if !isLoading {
                mainContent
            } else {
                loadingView
            }
        }
        .onAppear {
            loadOnboardingStatus()
        }
    }
    
    private func loadOnboardingStatus() {
        if let userData = userData {
            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                hasCompletedOnboarding = user.hasCompletedOnboarding
            } catch {
                hasCompletedOnboarding = false
            }
        } else {
            hasCompletedOnboarding = false
        }
        isLoading = false
    }
    
    var mainContent: some View {
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
    
    var loadingView: some View {
        ZStack {
            Background(BackgroundColor: .white)
            
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .onAppear {
                // Preview should load onboarding
            }
    }
}

