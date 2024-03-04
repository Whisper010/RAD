//
//  DrawHandler.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import SwiftUI
import RealityKit



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
