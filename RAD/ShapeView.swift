//
//  ShapeView.swift
//  RAD
//
//  Created by poojapriyanagaraj on 22/02/24.
//

import SwiftUI

struct ShapeView: View {
    
    @Environment(ARLogic.self) private var arLogic
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(["Shape1", "Shape2", "Shape3"], id: \.self) { shape in
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(shape)
                    }
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        
        }
        
    }

#Preview {
    ShapeView()
}
