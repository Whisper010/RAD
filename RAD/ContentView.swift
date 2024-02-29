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
        
        // Enable people occlusion if available
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        } else if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentation) {
            config.frameSemantics.insert(.personSegmentation)
        }
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
            // Enable automatic occlusion of virtual content by the mesh
//            arView.environment.sceneUnderstanding.options.insert(.occlusion)
        }
        
        
        arView.enableModeActive()
//        arView.enableObjectRemoval()
        
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
    
    func enableModeActive(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer: )))
        self.addGestureRecognizer(panGestureRecognizer)
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
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer){
        guard let arView = recognizer.view as? ARView else {return}
        
        
        
        switch recognizer.state {
        case .began,.changed:
            let location = recognizer.location(in: self)
            // Convert the 2D touch location to a 3D location in AR space
            if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any){
                // Perform the raycast
                let results = arView.session.raycast(raycastQuery)
                
                if let firstResult = results.first{
                    // Get the 3D coordinates from the first result
                    let matrix = firstResult.worldTransform
                    let position = SIMD3<Float>(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
                    
                    
                    // Create or update a ModelEntity at this position
                        let modelEntity = createModelEntity(at: position)
                        arView.scene.addAnchor(modelEntity)
                }
            }
        
        default:
            break
        }
    
    }
}

func createModelEntity(at position: SIMD3<Float>) -> AnchorEntity {
    // Generate a sphere mesh with a specified radius.
       let mesh = MeshResource.generateSphere(radius: 0.005)
       
       // Create a simple material for the sphere.
       let material = SimpleMaterial(color: .blue, isMetallic: true)
       
       // Create the model entity with the mesh and the material.
       let modelEntity = ModelEntity(mesh: mesh, materials: [material])
       
       // Create an anchor entity at the given world position.
       let anchorEntity = AnchorEntity(world: position)
       
       // Add the model entity to the anchor entity.
       anchorEntity.addChild(modelEntity)
       // Optionally, give the anchor a name for later reference.
       anchorEntity.name = "droplet"
    
    return anchorEntity
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
