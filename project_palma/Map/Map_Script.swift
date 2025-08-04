//
//  Map_Script.swift
//  project_palma
//
//  Created by Christian Kleeberg on 15.07.25.
//

import SwiftUI
import MapKit

struct project_palma_map: View {
    
    var body: some View {
        Map {
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        
        }
            .mapStyle(.standard(elevation: .realistic))
    }
}
