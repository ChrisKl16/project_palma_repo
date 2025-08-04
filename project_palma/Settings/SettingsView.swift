//
//  SettingsView.swift
//  project_palma
//
//  Created by Christian Kleeberg on 03.08.25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isShowingSettings: Bool

    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.title2)
                    .padding()

                Spacer()
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isShowingSettings = false
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


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isShowingSettings: .constant(true))
    }
}
