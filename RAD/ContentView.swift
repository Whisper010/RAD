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
    var isDrawPanelEnabled: Bool = false
    var showingShapesPicker = false
    
    static var shared: ARLogic = ARLogic()
    
    private init() {
        
    }
    
}

struct ContentView: View {
    
    @State private var arLogic = ARLogic.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            VStack{
                if arLogic.isDrawPanelEnabled {
                    DrawPanelView()
                }
                
                ToolView()
                if arLogic.showingShapesPicker {
                    ShapeView { shape in
                        if arLogic.showingShapesPicker {
                            ShapeView { shape in
                                // Handle shape selection
                                print("Selected shape: \(shape)")
                                arLogic.showingShapesPicker = false
                            }
                            .transition(.move(edge: .bottom))
                            .animation(.default)
                        }
                        
                    }
                    
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
