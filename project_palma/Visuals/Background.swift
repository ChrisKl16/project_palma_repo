//
//  Background.swift
//  project_palma
//
//  Created by Christian Kleeberg on 29.07.25.
//

import SwiftUI

struct Background: View {
    
    var BackgroundColor: Color
    
    var body: some View {
        Color(BackgroundColor)
            .edgesIgnoringSafeArea(.all)
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background(BackgroundColor: .white)
    }
}
