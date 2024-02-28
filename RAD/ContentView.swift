//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI
import RealityKit
import ARKit
import UIKit

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
    var modelSelected: Model?
    
    var isModifying: Bool = false
    
}

struct ContentView: View {
    
   
    
    @State var updater: Bool = false
    
    var body: some View {
        
        ZStack(alignment:.bottom){
            ARViewContainer()
                .ignoresSafeArea(.all)
            
            
            OverlayView()
                
            
            
        }
        
    }
}

struct OverlayView: View {
    
    @Environment(ARLogic.self) private var arLogic
    
    var body: some View {
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




struct ARViewContainer: UIViewRepresentable {
    
    @Environment(ARLogic.self) private var arLogic
    
    
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        
        
        arView.enableObjectRemoval()
        
        arView.session.run(config)
        
        
        return arView
    }
    
  
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
    
      
        
        // Update the AR view if needed
        if let model = arLogic.modelSelected {
            print("DEBUG: adding model to scene - \(model.modelName)")
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.name = "Anchor"
            
            if let modelEntity = model.modelEntity {
                anchorEntity.addChild(modelEntity)
                uiView.installGestures([.translation, .rotation, .scale], for: modelEntity)
            }
            
            uiView.scene.addAnchor(anchorEntity)
            DispatchQueue.main.async {
                self.arLogic.modelSelected = nil
            }
        }
        
    }
}



extension ARView {
    func enableObjectRemoval(){
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer: )))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
//        if recognizer.state != .began {
//            return // Ensure that the code runs only once at the beginning of the long press
//        }
        
        let location = recognizer.location(in: self)
        if let entity = self.entity(at: location) {
            if let anchorEntity = entity.anchor, anchorEntity.name == "Anchor"{
                anchorEntity.removeFromParent()
                print("Removed anchor with name: " + anchorEntity.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
