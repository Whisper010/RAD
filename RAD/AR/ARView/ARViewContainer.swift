//
//  ARViewContainer.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import SwiftUI
import RealityKit
import ARKit



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
//
//            // Enable automatic occlusion of virtual content by the mesh
//            arView.environment.sceneUnderstanding.options.insert(.occlusion)
        }
        
        
        arView.session.run(config)
        
        // Subscribe for Event update every frame
        context.coordinator.setupSubscriptions()
        
        return arView
    }
    
  
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
    
        
        
        switch arLogic.currentActiveMode {
            case .drawing where context.coordinator.drawState != .drawing:
                context.coordinator.drawState = .drawing
            case .erasing where context.coordinator.drawState != .erasing:
                context.coordinator.drawState = .erasing
            case .none:
                context.coordinator.drawState = .none
            default:
                break
            }
        
        if UIColor(arLogic.selectedColor) != context.coordinator.selectedColor{
            context.coordinator.selectedColor = UIColor(arLogic.selectedColor)
        }

      
        
        // Update the AR view
        if let model = arLogic.modelSelected {
            print("DEBUG: adding model to scene - \(model.modelName)")
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.name = "Shape"
            
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
