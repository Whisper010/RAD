//
//  ShapeFactory.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import RealityKit
import SwiftUI


// ShapeFactory class to encapsulate the shape creation logic
struct ShapeFactory {
    
    static let borderSize: Float = 10
    static let angleInDegrees: Float = -90
    static let angleInRadians: Float = angleInDegrees * (Float.pi / 180)

    static func createCircleVertices(radius: Float, segments: Int) -> [SIMD3<Float>] {
        var innerVertices: [SIMD3<Float>] = []

               for i in 0..<segments {
                   // clockwise order
                   let theta = 2 * Float.pi * (1-Float(i) / Float(segments))
                   let x = radius * cos(theta)
                   let y = radius * sin(theta)
                   innerVertices.append(SIMD3<Float>(x, y, 0))
               }
        return makeBorder(for: innerVertices, withSize: borderSize)
    }

    static func createSquareVertices(size: Float) -> [SIMD3<Float>] {
        // Implement square vertex creation logic
        let halfSize = size/2
                let innerVertices: [SIMD3<Float>] = [
                    SIMD3<Float>(-halfSize, halfSize, 0),  // Top-left
                    SIMD3<Float>(halfSize, halfSize, 0),   // Top-right
                    SIMD3<Float>(halfSize, -halfSize, 0),  // Bottom-right
                    SIMD3<Float>(-halfSize, -halfSize, 0)  // Bottom-left
                ]
        return makeBorder(for: innerVertices, withSize: borderSize)
    }

    static func createModelEntity(vertices: [SIMD3<Float>]) -> ModelEntity {
        let indices: [UInt32] = calculateIndices(vertices: vertices)
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.positions = MeshBuffer(vertices)
        meshDescriptor.primitives = .triangles(indices)

        var material = SimpleMaterial(color: .black, isMetallic: false)
        material.roughness = 1.0
        let mesh = try! MeshResource.generate(from: [meshDescriptor])
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        modelEntity.transform.rotation = simd_quatf(angle: angleInRadians, axis: SIMD3<Float>(1, 0, 0))
        

        return modelEntity
    }

    // Helper function to calculate indices
    static func calculateIndices(vertices: [SIMD3<Float>]) -> [UInt32] {
        // Index calculation logic
        var calculatedIndices:[UInt32] = []
        let range: UInt32 = UInt32(vertices.count / 2)
        
        if range > 3 {
            for num in 0..<range {
                if num < range - 1 {
                    calculatedIndices.append(contentsOf: [num, num + range, num + range + 1])
                    calculatedIndices.append(contentsOf: [num, num + range + 1, num + 1])
                } else {
                    calculatedIndices.append(contentsOf: [num, num + range, range])
                    calculatedIndices.append(contentsOf: [num, range, 0])
                }
            }
        } else {
            for num in 0..<range-1 {
                calculatedIndices.append(contentsOf: [num, num + range + 1, num + range])
                calculatedIndices.append(contentsOf: [num, num + range, num + 1])
            }
        }
        
        return calculatedIndices
    }

    // Helper function to create a border for shapes
    static func makeBorder(for innerVertices: [SIMD3<Float>], withSize size: Float) -> [SIMD3<Float>] {
        // Border creation logic
        let scale = 1 + size / 100
        let outerVertices = innerVertices.map { SIMD3<Float>($0.x * scale, $0.y * scale, $0.z) }
        return outerVertices + innerVertices
    }
    
    static func createLineVertices(length: Float, thickness: Float) -> [SIMD3<Float>] {
        
        let scale: Float = 100
        
        let scaledLength: Float = (length ) / scale
        let scaledThickness: Float = thickness / scale

        let innerVertices: [SIMD3<Float>] = [
            SIMD3<Float>(0, scaledThickness, 0),        // Start Top
            SIMD3<Float>(scaledLength, scaledThickness, 0),   // End Top
            SIMD3<Float>(scaledLength, 0, 0),  // End Bottom
            SIMD3<Float>(0, 0, 0)        // Start Bottom
        ]

        
        return innerVertices
    }
    
    
//    static func createCylinderVerticies( radius: Float, height: Float, radialSegments: Int) -> [SIMD3<Float>] {
//        var vertices: [SIMD3<Float>] = []
//        
//        
//        // Create top circle vertices
//        let topVertices = createCircleVertices(radius: radius, segments: radialSegments)
//        for vertex in topVertices {
//            vertices.append(SIMD3<Float>(vertex.x, vertex.y + height / 2, vertex.z))
//        }
//        
//        // Create bottom circle vertices
//        let bottomVertices = createCircleVertices(radius: radius, segments: radialSegments)
//       
//        for vertex in bottomVertices {
//            vertices.append(SIMD3<Float>(vertex.x, vertex.y - height / 2, vertex.z))
//        }
//        
//        
//        
//        return vertices
//    }
    
         
    
}
