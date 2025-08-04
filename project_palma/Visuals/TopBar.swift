//
//  TopBar.swift
//  project_palma
//
//  Created by Christian Kleeberg on 03.08.25.
//

import SwiftUI

struct TopBar: View {
    @Binding var isShowingNotification: Bool
    @Binding var isShowingSettings: Bool
    
    var body: some View {
        HStack(spacing: 100) {
            Button {
                withAnimation {
                    isShowingNotification = true
                }
                print("Notification tapped")
            } label: {
                littleImage(imageName: "newspaper")
            }
            Header(headertext: "Gather")
            Button {
                withAnimation {
                    isShowingSettings = true
                }
                print("Settings tapped")
            } label: {
                littleImage(imageName: "gearshape")
            }
        }
    }
}
                    
#Preview {
    TopBar(isShowingNotification: .constant(false), isShowingSettings: .constant(false))
}
