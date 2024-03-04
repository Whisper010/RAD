//
//  DrawingEntity.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import RealityKit


class DrawingEntity {
    var anchor: AnchorEntity
    var worldPosition: SIMD3<Float>
    init(anchor: AnchorEntity, worldPosition: SIMD3<Float>) {
        self.anchor = anchor
        self.worldPosition = worldPosition
    }
}

