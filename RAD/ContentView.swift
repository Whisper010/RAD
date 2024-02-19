//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
        }
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView (frame: .zero)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
       
    }
    
}

#Preview {
    ContentView()
}
