//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI
import RealityKit
import ARKit

class ARLogic: ObservableObject {
    // Properties for AR logic
}

struct ContentView: View {
    @StateObject var arLogic = ARLogic()
    @State private var showingShapesPicker = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            
            if showingShapesPicker {
                ShapeView { shape in
                    // Handle shape selection
                    print("Selected shape: \(shape)")
                    self.showingShapesPicker = false
                }
                .transition(.move(edge: .bottom))
                .animation(.default)
            }
            
            HStack {
                Button(action: {
                    self.showingShapesPicker.toggle()
                }) {
                    Image(systemName: "rectangle.3.group")
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                Button(action: {}) {
                    Image(systemName: "scribble.variable")
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                Button(action: {}) {
                    Image(systemName: "camera")
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
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
