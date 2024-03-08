//
//  Coordinator.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import SwiftUI
import RealityKit
import ARKit
import Combine


extension ARViewContainer {
    class Coordinator: NSObject {
        var arView: ARView?
        var longPressGestureRecognizer: UILongPressGestureRecognizer?
        var panGestureRecognizer: UIPanGestureRecognizer?
        var drawState: Mode = .none
        var selectedColor: UIColor = .black
        
        var selectedModel: Model?
        
        var cancellables = Set<AnyCancellable>()
        var drawingEnteties: [DrawingEntity] = []
        
        // Define a publisher for drawing events
        var drawPublisher = PassthroughSubject<DrawEvent, Never>()
        
        enum DrawEvent {
            case draw(startPosition: SIMD3<Float>, endPosition: SIMD3<Float>, maxHeight: Float, color: UIColor)
        }
        
        
        override init(){
            super.init()
            setupDrawSubcriber()
            configureGestureRecognizer()
            setupSubscriptions()
        }
        
         func setupDrawSubcriber() {
            drawPublisher
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .sink{[weak self] event in
                    guard let self = self, let arView = self.arView else {return}
                    
                    switch event {
                    case .draw(let startPosition, let endPosition, let maxHeight, let color):
                        
                        let tubeSegment =  createTube(startPosition: startPosition, endPosition: endPosition, radius: 0.002, segments: 9, maxHeight: maxHeight, color: selectedColor)
                        
                        createAndAddTubeSegments(startPosition: startPosition, endPosition: endPosition, maxHeight: maxHeight, color: color, to: arView)

                        
                        arView.scene.addAnchor(tubeSegment)
                        
                        drawingEnteties.append(DrawingEntity(anchor: tubeSegment, worldPosition: endPosition))
                    }
                }
                .store(in: &cancellables)
        }
        private func createAndAddTubeSegments(startPosition: SIMD3<Float>, endPosition: SIMD3<Float>, maxHeight: Float, color: UIColor, to arView: ARView) {
            var attachPosition = startPosition
            var distanceToFill = simd_distance(endPosition, startPosition)

            while distanceToFill > 0 {
                let direction = normalize(endPosition - attachPosition)
                let segmentLength =  min(maxHeight,distanceToFill)
                let segmentEnd = attachPosition + direction * segmentLength
                let tubeSegmentToFill = createTube(startPosition: attachPosition, endPosition: segmentEnd, radius: 0.002, segments: 9, maxHeight: segmentLength, color: color)

                DispatchQueue.main.async {
                    arView.scene.addAnchor(tubeSegmentToFill)
                    self.drawingEnteties.append(DrawingEntity(anchor: tubeSegmentToFill, worldPosition: segmentEnd))
                }

                attachPosition = segmentEnd
                distanceToFill -= segmentLength
            }
        }
        
   
        private func publishDrawingEvent(startPosition: SIMD3<Float>, endPosition: SIMD3<Float>, maxHeight: Float, color: UIColor) {
            
            drawPublisher.send(.draw(startPosition: startPosition, endPosition: endPosition, maxHeight: maxHeight, color: color))
        }
        
        func captureARViewFrame(completion: @escaping (UIImage?) -> Void) {
            guard let arView = self.arView else {  completion(nil)
                return }
            return arView.snapshot(saveToHDR: false) { image in
                completion(image)
            }
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
                    for child in anchorEntity.children {
                        anchorEntity.removeChild(child)
                    }
                    
                }
            }
            
            if drawState == .erasing {
                if let entity = arView.entity(at: location) {
                    if let anchorEntity = entity.anchor, anchorEntity.name == "Droplet" {
                        anchorEntity.removeFromParent()
                       
                        for child in anchorEntity.children {
                            anchorEntity.removeChild(child)
                        }
                    }
                }
            }
        }
        
        // Example of an async function for raycasting
        func performRaycast(from location: CGPoint, allowing: ARRaycastQuery.Target, alignment: ARRaycastQuery.TargetAlignment) -> SIMD3<Float>? {
            guard let arView = self.arView else { return nil }
                
                // Create a raycast query
                guard let query = arView.makeRaycastQuery(from: location, allowing: allowing, alignment: alignment) else { return nil }
                
                // Perform the raycast synchronously
                let results = arView.session.raycast(query)
                
                // Get the first result and extract the world transform position
                guard let firstResult = results.first else { return nil }
                let matrix = firstResult.worldTransform
                let position = SIMD3<Float>(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
                
                return position
        }
        
        @objc func handlePan(recognizer: UIPanGestureRecognizer) {
            guard let arView = arView else { return }
            let location = recognizer.location(in: arView)
            
            var allowingMode: ARRaycastQuery.Target = .estimatedPlane
            
            switch drawState {
            case .drawing:
                // Drawing logic
                switch recognizer.state {
                    
                case .began:
                    if let position =  performRaycast(from: location, allowing: allowingMode, alignment: .any) {
                        
                        
                        
                        let anchor = AnchorEntity(world: position)
                        anchor.name = "Droplet"
                        arView.scene.addAnchor(anchor)
                        
                        drawingEnteties.append(DrawingEntity(anchor: anchor, worldPosition: position))
                        
                    }
                    
                case .changed:
                    if let position =  performRaycast(from: location, allowing: allowingMode, alignment: .any), let last = drawingEnteties.last {
                            
                        let startPosition = last.worldPosition
                        var endPosition = position
                        let maxHeight: Float = 0.007
//                        let maxLength:Float = 0.3
//                        
//                        if simd_distance(startPosition, endPosition) > maxLength {
//                            return
//                        }
//                        
                        publishDrawingEvent(startPosition: startPosition, endPosition: endPosition, maxHeight: maxHeight, color: selectedColor)
                                

                                //                            if let child = tubeSegment.children.first as? HasCollision {
                                //                            arView.installGestures([], for: child)
                                //                            }
                                //
                               
                            
                        }
                        
                    
                default:
                    break
                }
                
            case .shaping:
                // Shaping logic
                

                switch recognizer.state{
                case .began:
                 
                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: allowingMode, alignment: .any) {
                        let results = arView.session.raycast(raycastQuery)
                        if let firstResult = results.first {
                            
                            let matrix = firstResult.worldTransform
                            let position = SIMD3<Float>(matrix.columns.3.x , matrix.columns.3.y , matrix.columns.3.z)
                            
                            // action
                            
                            if let model = selectedModel {
                                
                                let newModel = Model(modelName: model.modelName, shapeType: model.shapeType)
                                
                                if let modelEntity = newModel.modelEntity{
                                    let anchor = AnchorEntity(world: position)
                                    
                                    anchor.name = "Shape"
                                    anchor.addChild(modelEntity)
                                    
//                                    arView.installGestures([], for: modelEntity)
                                    
                                    arView.scene.addAnchor(anchor)
                                    
                                    drawingEnteties.append(DrawingEntity(anchor: anchor, worldPosition: position))
                                }
                            }
                            
                        }
                    }
                case .changed:
                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: allowingMode, alignment: .any) {
                        let results = arView.session.raycast(raycastQuery)
                        if let firstResult = results.first {
                            
                            let matrix = firstResult.worldTransform
                            let position = SIMD3<Float>(matrix.columns.3.x , matrix.columns.3.y , matrix.columns.3.z)
                            
                            // action
                            
                            let drawingEntity = drawingEnteties.last
                            if let drawingEntity = drawingEntity {
                                
                                let origin = drawingEntity.worldPosition
                                if let modelEntity = drawingEntity.anchor.children.first{
                                    
                                    let distance = simd_distance(origin, position)
                                    let scaleFactor: Float = 50
                                    
                                    // Update position
                                    
                                    
                                    modelEntity.transform.scale.x = distance * scaleFactor
                                    let aspectRatio:Float = 1
                                    modelEntity.transform.scale.y = distance * aspectRatio * scaleFactor
                                    
                                }
                            }
                           
                            
                        }
                    }
//
//                case .ended:
//                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .any) {
//                        let results = arView.session.raycast(raycastQuery)
//                        if let firstResult = results.first {
//                            
//                            let matrix = firstResult.worldTransform
//                            let position = SIMD3<Float>(matrix.columns.3.x , matrix.columns.3.y , matrix.columns.3.z)
//                            
//                            // action
//                            
//                            if let modelEntity = modelEntity {
//                                let anchor = AnchorEntity(world: position)
//                                anchor.name = "Shape"
//                                anchor.addChild(modelEntity)
//                                arView.scene.addAnchor(anchor)
//                            }
//                            
//                           
//                            
//                        }
//                    }
                    
//
                default:
                    break
                }
            
                
            case .erasing:
//                 Eraser logic
                if recognizer.state == .began || recognizer.state == .changed {
                    
                    if let raycastQuery = arView.makeRaycastQuery(from: location, allowing: allowingMode, alignment: .any) {
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

//extension ARViewContainer.Coordinator {
//    
//    
//}
