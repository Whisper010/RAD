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
//        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(["Shape0", "Shape1", "Shape2"], id: \.self) { shape in
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(shape)
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
            
//        }
    }
    
}

#Preview {
    ShapeView()
}
