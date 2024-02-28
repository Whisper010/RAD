//
//  Model.swift
//  RAD
//
//  Created by Linar Zinatullin on 27/02/24.
//

import UIKit
import RealityKit
import Combine
import ARKit
import simd

struct Model: Identifiable {
    
    var id: UUID = UUID()
    
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        modelEntity = createShape()
        modelEntity?.generateCollisionShapes(recursive: true)
    }
    
    
    func createShape () -> ModelEntity{
        let vertices: [SIMD3<Float>] = [
            SIMD3<Float>(-0.1, 0.1, 0),   // 0: Top left (outer)
            SIMD3<Float>(-0.1, -0.1, 0),  // 1: Bottom left (outer)
            SIMD3<Float>(0.1, -0.1, 0),   // 2: Bottom right (outer)
            SIMD3<Float>(0.1, 0.1, 0),    // 3: Top right (outer)
            SIMD3<Float>(-0.09, 0.09, 0), // 4: Top left (inner)
            SIMD3<Float>(-0.09, -0.09, 0),// 5: Bottom left (inner)
            SIMD3<Float>(0.09, -0.09, 0), // 6: Bottom right (inner)
            SIMD3<Float>(0.09, 0.09, 0)   // 7: Top right (inner)
           ]

        /// Connecting the vertices
        let indices: [UInt32] = [
                   
            // Top edge
             0, 4, 7,  0, 7, 3,
             // Right edge
             3, 7, 6,  3, 6, 2,
             // Bottom edge
             2, 6, 5,  2, 5, 1,
             // Left edge
             1, 5, 4,  1, 4, 0
            
        ]
        
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.positions = MeshBuffer(vertices)
        meshDescriptor.primitives = .triangles(indices)
        
        
        
        
        var material = SimpleMaterial(color: .black, isMetallic: false)
        material.roughness = 0.5
        let mesh = try! MeshResource.generate(from: [meshDescriptor])
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        let angleInDegreas: Float = -80
        let angleInRadians = angleInDegreas * (Float.pi/180)
        modelEntity.transform.rotation = simd_quatf(angle: angleInRadians, axis: SIMD3<Float>(1,0,0))
        
        return modelEntity
        
    }
    
    
}


struct ViewModel {
    var shapes: [Model] = [Model(modelName: "Shape0"),
                           Model(modelName: "Shape1"),
                           Model(modelName: "Shape2")
    ]
}
