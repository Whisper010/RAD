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
import Combine

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

extension ARViewContainer {
    class Coordinator: NSObject {
        var arView: ARView?
        var longPressGestureRecognizer: UILongPressGestureRecognizer?
        var panGestureRecognizer: UIPanGestureRecognizer?
        var drawState: Mode = .none
        var selectedColor: UIColor = .black
        
        var cancellables = Set<AnyCancellable>()
        var drawingEnteties: [DrawingEntity] = []
        
        
        override init(){
            super.init()
        }
        
        func setupSubscriptions() {
            guard let arView = arView else {return}
            
            arView.scene.publisher(for: SceneEvents.Update.self).sink{ [weak self] _ in
                self?.handleSceneUpdate()
            }
            .store(in: &cancellables)
        }
        
        private func handleSceneUpdate() {
            
        }
        
        
        func configureGestureRecognizer(){
            // Initialize the pan gesture recognizer for drawing mode
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            
            
            if let arView = arView,
                let longPressGesture = longPressGestureRecognizer,
                let panGesture = panGestureRecognizer {
                arView.addGestureRecognizer(longPressGesture)
                arView.addGestureRecognizer(panGesture)
            }
            
        }
        
        @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
            guard let arView = arView else { return }
            let location = recognizer.location(in: arView)
            
            if let entity = arView.entity(at: location) {
                if let anchorEntity = entity.anchor, anchorEntity.name == "Shape" {
                    anchorEntity.removeFromParent()
                    
                }
            }
        }
        
        @objc func handlePan(recognizer: UIPanGestureRecognizer) {
            guard let arView = arView else { return }
            let location = recognizer.location(in: arView)
            
            
            switch drawState {
            case .drawing:
                // Drawing logic
                switch recognizer.state {
                case .began, .changed:
                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) {
                        let results = arView.session.raycast(raycastQuery)
                        if let firstResult = results.first {
                            
                            let matrix = firstResult.worldTransform
                            let position = SIMD3<Float>(matrix.columns.3.x , matrix.columns.3.y , matrix.columns.3.z)
                            
                            let anchorWithChild = createModelEntity(at: position, color: selectedColor)
                            
                            arView.scene.addAnchor(anchorWithChild)
                            
                            drawingEnteties.append(DrawingEntity(anchor: anchorWithChild, worldPosition: position))
                            
                        }
                    }
                default:
                    break
                }
                
            case .erasing:
//                 Eraser logic
                if recognizer.state == .began || recognizer.state == .changed {
                    
                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) {
                        let results = arView.session.raycast(raycastQuery)
                        if let firstResult = results.first {
                            
                            let matrix = firstResult.worldTransform
                            let position = SIMD3<Float>(matrix.columns.3.x , matrix.columns.3.y , matrix.columns.3.z)
                            
                            
                            
                            for entityToErase in findEntitiesToErase(near: position, withRadius: 0.05, in: drawingEnteties) {
                                entityToErase.removeFromParent()
                                
                            }
                        }
                    }
                }
            default:
                break
            }
            
           
        }
        
    }
}

class DrawingEntity {
    var anchor: AnchorEntity
    var worldPosition: SIMD3<Float>
    init(anchor: AnchorEntity, worldPosition: SIMD3<Float>) {
        self.anchor = anchor
        self.worldPosition = worldPosition
    }
}




func createModelEntity(at position: SIMD3<Float>, color: UIColor) -> AnchorEntity {
    @Environment(ARLogic.self) var arLogic
    
       let mesh = MeshResource.generateSphere(radius: 0.005)
       
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
       
       let modelEntity = ModelEntity(mesh: mesh, materials: [material])
       
       // Create an anchor entity at the given world position.
        let anchorEntity = AnchorEntity(world: position)
    
        
       
        anchorEntity.name = "Droplet"
    
       // Add the model entity to the anchor entity.
       anchorEntity.addChild(modelEntity)
    
      
    
    return anchorEntity
}

func findEntitiesToErase(near centerPosition: SIMD3<Float>, withRadius radius: Float, in drawingEntities: [DrawingEntity]) ->  [AnchorEntity] {
    
        var entitiesToErase = [AnchorEntity]()


        // Filter only the anchors with the name "Droplet"
    let entities = drawingEntities.filter{$0.anchor.name == "Droplet"}
    

        for entity in entities  {
            // Check if the anchor is within the defined radius
            let distance: Float = simd_distance(entity.worldPosition,centerPosition)
            
            if distance <= radius {
                entitiesToErase.append(entity.anchor)
            }
        }

        return entitiesToErase
}

//struct BeamParameters {
//    var startPosition: SIMD3<Float>
//    var endPosition: SIMD3<Float>
//    var radius: Float
//}

//func createBeam(_ beamParams: BeamParameters, in arView: ARView) -> ModelEntity{
//    let beamLength = simd_distance(beamParams.startPosition, beamParams.endPosition)
//    let cylinder = MeshResource.generateCylinder(radius: beamParams.endPosition,
//                                                 height: beamLength,
//                                                 radialSegment:30,
//                                                 verticalSegments:1,
//                                                 inwardNormals: false)
//    let material = SimpleMaterial(color: .blue, isMetallic: false)
//    let beamModel = ModelEntity(mesh: cylinder, materials: [material])
//
//    // Check if the beam model already exists in the scene and update it
//        if let existingBeam = arView.scene.findEntity(named: "DebugBeam") as? ModelEntity {
//            existingBeam.position = beamModel.position
//            existingBeam.orientation = beamModel.orientation
//            existingBeam.scale = beamModel.scale
//            return existingBeam
//        } else {
//            beamModel.name = "DebugBeam"
//            return beamModel
//        }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
