//
//  Coordinator.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import SwiftUI
import RealityKit
import Combine


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
