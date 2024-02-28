//
//  ShapeView.swift
//  RAD
//
//  Created by poojapriyanagaraj on 22/02/24.
//

import SwiftUI

struct ShapeView: View {
    
    @Environment(ARLogic.self) private var arLogic
    
    var shapes = ViewModel().shapes
    
    var body: some View {
        ZStack {
            HStack() {
                ForEach(shapes) { shape in
                    Button(action: {
                        let model = Model(modelName: shape.modelName, shapeType: shape.shapeType)
                        arLogic.modelSelected = model
                    }) {
                        Image(shape.modelName)
                            .resizable()
                            .frame(width: 30,height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0).size(width: 30, height: 30))
                    }
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }.padding()
                .background(RoundedRectangle(cornerRadius: 10.0)
                    .fill(.black)
                    .opacity(0.5))
            
        }
    }
    
}

#Preview {
    ShapeView()
}
