//
//  ShapeTypes.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import RealityKit


// Types of shape for ShapeFactory
enum ShapeType {
    case circle
    case square
    case triangle
    case line

    func createModelEntity() -> ModelEntity {
        switch self {
        case .circle:
            return ShapeFactory.createModelEntity(vertices: ShapeFactory.createCircleVertices(radius: 0.05, segments: 72))
        case .square:
            return ShapeFactory.createModelEntity(vertices: ShapeFactory.createSquareVertices(size: 0.2))
        case .line:
            return ShapeFactory.createModelEntity(vertices:
                ShapeFactory.createLineVertices(length:50.0, thickness: 1.0))
        default:
            fatalError("Shape not implemented")
        }
    }
}
