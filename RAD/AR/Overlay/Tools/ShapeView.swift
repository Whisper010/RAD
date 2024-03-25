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
                        arLogic.selectedModel = shape
                    }) {
                        Image(shape.modelName)
                            .resizable()
                            .frame(width: 30,height: 30)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding()
                .background(Color.white)
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
