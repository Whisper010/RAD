//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI
import RealityKit
import ARKit

enum Mode{
    case shape
    case draw
    case camera
    case none
    
}

@Observable
class ARLogic {
    var currentMode: Mode = .none
    var selectedColor: Color = .black
}

struct ContentView: View {
    
    @Environment(ARLogic.self) private var arLogic
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
                .allowsHitTesting(false)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                if arLogic.currentMode == .shape  {
                    ShapeView()                            
                        .transition(.move(edge: .bottom))
                }
                if arLogic.currentMode == .draw {
                    DrawPanelView(selectedColor: arLogic.selectedColor)
                }
                if arLogic.currentMode == .camera {
                    CameraInterfaceView()
                }
                if arLogic.currentMode != .camera {
                    ToolView()
                }
            }
            
        }
       
        
    }
}




struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update the AR view if needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
