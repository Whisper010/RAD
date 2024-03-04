//
//  Model.swift
//  RAD
//
//  Created by Linar Zinatullin on 27/02/24.
//

import SwiftUI
import RealityKit


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
        self.modelEntity?.generateCollisionShapes(recursive: false)
    }
}


// ViewModel holding the array of Model objects
struct ViewModel {
    var shapes: [Model] = [
        Model(modelName: "Shape0", shapeType: .square),
        Model(modelName: "Shape1", shapeType: .circle),
        Model(modelName: "Shape2", shapeType: .line)
        
    ]
    static let droplet: Model = Model(modelName: "Droplet", shapeType: .circle)
}

