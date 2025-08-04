//
//  LittleImage.swift
//  project_palma
//
//  Created by Christian Kleeberg on 29.07.25.
//

import SwiftUI

struct littleImage: View {
    
    var imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .symbolRenderingMode(.hierarchical)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.black)
            .frame(width: 25, height: 25)
            .padding(10)
    }
}

struct littleImage_Previews: PreviewProvider {
    static var previews: some View {
        littleImage(imageName: "gearshape")
    }
}
