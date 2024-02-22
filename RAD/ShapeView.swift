//
//  ShapeView.swift
//  RAD
//
//  Created by poojapriyanagaraj on 22/02/24.
//

import SwiftUI

struct ShapeView: View {
    var didSelectShape: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(["Shape1", "Shape2", "Shape3"], id: \.self) { shape in
                    Button(shape) {
                        self.didSelectShape(shape)
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    ShapeView()
}
