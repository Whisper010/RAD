//
//  DrawHandler.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import SwiftUI
import RealityKit



func createModelEntity(at position: SIMD3<Float>, color: UIColor)  -> AnchorEntity {
    
    let mesh = MeshResource.generateSphere(radius: 0.001)
    
    let material = SimpleMaterial(color: color, roughness: 1.0, isMetallic: false)
    
    let modelEntity = ModelEntity(mesh: mesh, materials: [material])
    
    modelEntity.generateCollisionShapes(recursive: false)
    
    
    // Create an anchor entity at the given world position.
    let anchorEntity = AnchorEntity(world: position)
    
    
    
    anchorEntity.name = "Droplet"
    
    // Add the model entity to the anchor entity.
    anchorEntity.addChild(modelEntity)
    
    
    return anchorEntity
    
}

func generateTubeMesh(startPosition: SIMD3<Float>, endPosition: SIMD3<Float>, radius: Float, segments: Int, maxHeight: Float) -> (vertices: [SIMD3<Float>], indices: [UInt32]) {
    var vertices: [SIMD3<Float>] = []
    var indices: [UInt32] = []
    let height = min(simd_distance(endPosition, startPosition), maxHeight)
    
    let direction = normalize(endPosition - startPosition)
    let upVector = SIMD3<Float>(0,0,1)
    let rotationMatrix = rotationBetween(from: upVector, to:direction)

    // Generate vertices for the tube
    for z in [0, height] {
        for i in 0..<segments {
            let theta = 2 * Float.pi * Float(i) / Float(segments)
            let x = radius * cos(theta)
            let y = radius * sin(theta)
            
            let originalVertex = SIMD3<Float>(x,y,Float(z))
            let rotatedVectorSIMD4 = (rotationMatrix * SIMD4<Float>(originalVertex,1))
            let rotatedVertex = SIMD3<Float>(rotatedVectorSIMD4.x, rotatedVectorSIMD4.y, rotatedVectorSIMD4.z)
            
            vertices.append(rotatedVertex)
        }
    }

    // Calculate triangles for the tube's sides
    for i in 0..<segments {
        let nextIndex = (i + 1) % segments
        let topI = UInt32(i)
        let bottomI = UInt32(i + segments)
        let topNextI = UInt32(nextIndex)
        let bottomNextI = UInt32(nextIndex + segments)
        
        indices.append(contentsOf: [bottomI, topI, bottomNextI])
        indices.append(contentsOf: [topI, topNextI, bottomNextI])
        
//        indices.append(contentsOf: [bottomI,bottomNextI, topI ])
//        indices.append(contentsOf: [topI, bottomNextI, topNextI])
    }

    return (vertices, indices)
}

func rotationBetween( from: SIMD3<Float>, to: SIMD3<Float>) -> float4x4 {
    let crossProduct = cross(from, to)
    let dotProduct = dot(from, to)
    let s = sqrt((1+dotProduct)*2)
    let invS = 1/s
    
    let q  = simd_quatf(ix: crossProduct.x * invS, iy: crossProduct.y * invS, iz: crossProduct.z * invS, r: s*0.5)
    return float4x4(q)
}

func createTube( startPosition: SIMD3<Float>, endPosition: SIMD3<Float>, radius: Float, segments: Int, maxHeight: Float, color: UIColor) -> AnchorEntity {
    
    
    let (vertices, indices) = generateTubeMesh(startPosition: startPosition, endPosition: endPosition, radius: radius, segments: segments, maxHeight: maxHeight)
    
    // Create Mesh
    var meshDescriptor = MeshDescriptor()
    meshDescriptor.positions = .init(vertices)
    meshDescriptor.primitives = .triangles(indices)
    
    
   
    let anchorWithChild = AnchorEntity(world: startPosition)

    do  {
        let material = SimpleMaterial(color: color, isMetallic: false)
        let mesh = try MeshResource.generate(from: [meshDescriptor])
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        modelEntity.generateCollisionShapes(recursive: true)
        modelEntity.position = SIMD3(0, 0, 0)
        anchorWithChild.addChild(modelEntity)
    }catch {
        
        print("Error generating mesh: \(error)")
    }
    
    
    
//    // Rotate tube to my new position
//    let normalizedDirection = normalize(endPosition - startPosition)
//    
//    
//    let referenceVector = SIMD3<Float>(0, 0, 1)
//    
//    
//    let rotationAxis = cross(referenceVector, normalizedDirection)
//    let angle = acos(dot(referenceVector, normalizedDirection) / (length(referenceVector) * length(normalizedDirection)))
//    
//    
//    let rotation = simd_quatf(angle: angle , axis: rotationAxis)
//    modelEntity.transform.rotation = rotation
//    
    

    anchorWithChild.name = "Droplet"
    
    return anchorWithChild
    
}

//func addVerticesToModelEntity(_ modelEntity: ModelEntity, newVertices: [SIMD3<Float>]) -> ModelEntity {
//    
//    let existingVertices = ModelEntity
//    let existingIndices =
//    // Combine old and new vertices
//    let updatedVertices = existingVertices + newVertices
//    
//    // You might need to update indices based on how new vertices should be connected
//    
//    // Create a new mesh descriptor
//    var meshDescriptor = MeshDescriptor()
//    meshDescriptor.positions = .init(updatedVertices)
//    meshDescriptor.primitives = .triangles(updatedIndices) // Update indices accordingly
//    
//    // Generate the new mesh
//    let material = SimpleMaterial(color: .white, isMetallic: false)
//    let newMesh = try! MeshResource.generate(from: [meshDescriptor])
//    let newModelEntity = ModelEntity(mesh: newMesh, materials: [material])
//    
//    return newModelEntity
//}

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
