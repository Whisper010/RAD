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
    var isPlacementEnabled: Bool
    
    static let shared: ARLogic = ARLogic()
    
    private init() {
        self.isPlacementEnabled = true
    }
}

struct ContentView: View {
    
    var arLogic = ARLogic.shared
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            SomeView(isPlacementEnabled: arLogic.isPlacementEnabled)
        }
        
    }
}

struct SomeView : View {
    
     var isPlacementEnabled: Bool
    
    var body: some View{
        if isPlacementEnabled{
            EmptyView()
        }
        EmptyView()
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
