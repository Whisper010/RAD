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


// Define the shape types with associated factory methods
enum ShapeType {
    case circle
    case square
    case triangle
    case line

    func createModelEntity() -> ModelEntity {
        switch self {
        case .circle:
            return ShapeFactory.createModelEntity(vertices: ShapeFactory.createCircleVertices(radius: 0.02, segments: 36))
        case .square:
            return ShapeFactory.createModelEntity(vertices: ShapeFactory.createSquareVertices(size: 0.2))
        // Implement model entity creation for triangle and line if needed
        default:
            fatalError("Shape not implemented")
        }
    }
}

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

    // Implement methods for creating triangles and lines if needed

    static func createModelEntity(vertices: [SIMD3<Float>]) -> ModelEntity {
        let indices: [UInt32] = calculateIndices(vertices: vertices)
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.positions = MeshBuffer(vertices)
        meshDescriptor.primitives = .triangles(indices)

        var material = SimpleMaterial(color: .black, isMetallic: false)
        material.roughness = 0.5
        let mesh = try! MeshResource.generate(from: [meshDescriptor])
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        modelEntity.transform.rotation = simd_quatf(angle: angleInRadians, axis: SIMD3<Float>(1, 0, 0))

        return modelEntity
    }

    // Helper function to calculate indices
    static func calculateIndices(vertices: [SIMD3<Float>]) -> [UInt32] {
        // Implement index calculation logic
        var calculatedIndices:[UInt32] = []
        let range: UInt32 = UInt32(vertices.count / 2)
              
              for num in 0..<range {
                  if num < range - 1 {
                      calculatedIndices.append(contentsOf: [num, num + range, num + range + 1])
                      calculatedIndices.append(contentsOf: [num, num + range + 1, num + 1])
                  } else {
                      calculatedIndices.append(contentsOf: [num, num + range, range])
                      calculatedIndices.append(contentsOf: [num, range, 0])
                  }
              }
        return calculatedIndices
    }

    // Helper function to create a border for shapes
    static func makeBorder(for innerVertices: [SIMD3<Float>], withSize size: Float) -> [SIMD3<Float>] {
        // Implement border creation logic
        let scale = 1 + size / 100
        let outerVertices = innerVertices.map { SIMD3<Float>($0.x * scale, $0.y * scale, $0.z) }
        return outerVertices + innerVertices
    }
    
    static func createCylinderVerticies( radius: Float, height: Float, radialSegments: Int) -> [SIMD3<Float>] {
        var vertices: [SIMD3<Float>] = []
        
        
        // Create top circle vertices
        let topVertices = createCircleVertices(radius: radius, segments: radialSegments)
        for vertex in topVertices {
            vertices.append(SIMD3<Float>(vertex.x, vertex.y + height / 2, vertex.z))
        }
        
        // Create bottom circle vertices
        let bottomVertices = createCircleVertices(radius: radius, segments: radialSegments)
       
        for vertex in bottomVertices {
            vertices.append(SIMD3<Float>(vertex.x, vertex.y - height / 2, vertex.z))
        }
        
        
        
        return vertices
    }
    
         
    
}

// The Model struct now initializes with a ShapeType
struct Model: Identifiable {
    var id = UUID()
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    var shapeType: ShapeType

    init(modelName: String, shapeType: ShapeType) {
        self.shapeType = shapeType
        self.modelName = modelName
        self.image = UIImage(named: modelName) ?? UIImage()
        self.modelEntity = self.shapeType.createModelEntity()
        self.modelEntity?.generateCollisionShapes(recursive: true)
    }
}




// ViewModel holding the array of Model objects
struct ViewModel {
    var shapes: [Model] = [
        Model(modelName: "Shape0", shapeType: .square),
        Model(modelName: "Shape1", shapeType: .circle),
        
        // Initialize other shapes with their corresponding types
    ]
    static let droplet: Model = Model(modelName: "Droplet", shapeType: .circle)
}

