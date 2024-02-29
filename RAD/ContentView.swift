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

enum Tool{
    case shape
    case brush
    case camera
    case none
    
}

enum Mode {
    case drawing
    case erasing
    case none
}

@Observable
class ARLogic {
    
    
    var currentSelectedTool: Tool = .none
    var currentActiveMode: Mode = .none
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
            if arLogic.currentSelectedTool == .shape  {
                ShapeView()
                    .transition(.move(edge: .bottom))
            }
            if arLogic.currentSelectedTool == .brush {
                DrawPanelView(selectedColor: arLogic.selectedColor)
            }
            if arLogic.currentSelectedTool == .camera {
                CameraInterfaceView()
            }
            if arLogic.currentSelectedTool != .camera {
                ToolView()
                
            }
        }
        
    }
}




struct ARViewContainer: UIViewRepresentable {
    
    @Environment(ARLogic.self) private var arLogic
    
    
    
    func makeCoordinator() -> Coordinator {
            Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        context.coordinator.arView = arView
        context.coordinator.configureGestureRecognizer()
        
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
        
        
        arView.session.run(config)
        
        
        return arView
    }
    
  
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
    
        
        
        switch arLogic.currentActiveMode {
            case .drawing where context.coordinator.drawState != .drawing:
                context.coordinator.drawState = .drawing
                context.coordinator.enableDrawingMode()
            case .erasing where context.coordinator.drawState != .erasing:
                context.coordinator.drawState = .erasing
                context.coordinator.enableDrawingMode()
            case .none:
                context.coordinator.drawState = .none
                context.coordinator.disableDrawingMode()
            default:
                break
            }

      
        
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

extension ARViewContainer {
    class Coordinator: NSObject {
        var arView: ARView?
        var longPressGestureRecognizer: UILongPressGestureRecognizer?
        var panGestureRecognizer: UIPanGestureRecognizer?
        var drawState: Mode = .none
        
        
        override init(){
            super.init()
        }
        
        func configureGestureRecognizer(){
            // Initialize the pan gesture recognizer for drawing mode
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            
            // Assuming the gestures are not exclusive and can coexist.
            if let arView = arView, let longPressGesture = longPressGestureRecognizer{
                arView.addGestureRecognizer(longPressGesture)
                
            }
        }
        
        @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
            guard let arView = arView else { return }
            let location = recognizer.location(in: arView)
            if let entity = arView.entity(at: location) {
                if let anchorEntity = entity.anchor, anchorEntity.name == "Anchor" {
                    anchorEntity.removeFromParent()
                    print("Removed anchor with name: " + anchorEntity.name)
                }
            }
        }
        
        @objc func handlePan(recognizer: UIPanGestureRecognizer) {
            guard let arView = arView else { return }
            let location = recognizer.location(in: arView)
            
            
            switch drawState {
            case .drawing:
                switch recognizer.state {
                case .began, .changed:
                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) {
                        let results = arView.session.raycast(raycastQuery)
                        if let firstResult = results.first {
                            let matrix = firstResult.worldTransform
                            let position = SIMD3<Float>(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
                            let modelEntity = createModelEntity(at: position)
                            arView.scene.addAnchor(modelEntity)
                        }
                    }
                default:
                    break
                }
                
            case .erasing:
                // Implement eraser logic here
                switch recognizer.state {
                case .began, .changed:
                    
                    if let entity = arView.entity(at: location), let anchorEntity = entity.anchor, anchorEntity.name == "droplet" {
                        anchorEntity.removeFromParent()
                    }
                    
                default:
                    break
                }
            default:
                break
            }
            
           
        }
        
        func enableDrawingMode() {
            if let arView = self.arView, let panGesture = panGestureRecognizer {
                arView.addGestureRecognizer(panGesture)
            }
        }
        func disableDrawingMode() {
            if let arView = self.arView, let panGesture = panGestureRecognizer {
                arView.removeGestureRecognizer(panGesture)
            }
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
       
        // Optionally, give the anchor a name for later reference.
        anchorEntity.name = "droplet"
    
       // Add the model entity to the anchor entity.
       anchorEntity.addChild(modelEntity)
      
    
    return anchorEntity
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
