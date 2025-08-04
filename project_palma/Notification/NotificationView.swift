//
//  NotificationView.swift
//  project_palma
//
//  Created by Christian Kleeberg on 29.07.25.
//

import SwiftUI

struct NotificationView: View {
    @Binding var isShowingNotification: Bool

    var body: some View {
        NavigationView {
            VStack {
                Text("Notifications")
                    .font(.title2)
                    .padding()

                Spacer()
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isShowingNotification = false
                        }
                        print("XDismiss Button tapped")
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(isShowingNotification: .constant(true))
    }
}
