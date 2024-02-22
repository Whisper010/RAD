//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI
import RealityKit
import ARKit

@Observable
class ARLogic {

}

struct ContentView: View {
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            HStack{
                Button(action:{}){
                    Image(systemName: "rectangle.3.group")
                }
                .buttonStyle(.plain)
                .padding()
                
                Button(action:{}){
                    Image(systemName: "scribble.variable")
                }
                .buttonStyle(.plain)
                .padding()
                Button(action:{}){
                    Image(systemName: "camera")
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
        
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView (frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
       
    }
    
}

#Preview {
    ContentView()
}
