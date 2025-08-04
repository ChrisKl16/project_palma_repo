//
//  Header.swift
//  project_palma
//
//  Created by Christian Kleeberg on 03.08.25.
//

import SwiftUI

struct Header: View {
    
    var headertext: String
    
    var body: some View {
        Text(headertext)
            .font(.system(size: 25, weight: .medium, design: .default))
            .foregroundColor(.black)
            .padding(7)
    }
}

#Preview {
    Header(headertext: "Gather")
}
