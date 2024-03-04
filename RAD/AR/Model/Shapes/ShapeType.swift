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
            return ShapeFactory.createModelEntity(vertices: ShapeFactory.createCircleVertices(radius: 0.02, segments: 36))
        case .square:
            return ShapeFactory.createModelEntity(vertices: ShapeFactory.createSquareVertices(size: 0.2))
        default:
            fatalError("Shape not implemented")
        }
    }
}
