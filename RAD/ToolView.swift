//
//  ToolView.swift
//  RAD
//
//  Created by Linar Zinatullin on 22/02/24.
//

import SwiftUI

struct ToolView: View{
    
    @Environment(ARLogic.self) private var arLogic
    
    var body: some View{
        HStack(spacing: 20){
            
            Button(action:{
                arLogic.currentMode = .shape
                print("DEBUG: Draw Mode activate")
            }){
                Image(systemName: "rectangle.3.group")
                
            }
            .buttonStyle(.plain)
            .padding()
            
            Button(action:{
                arLogic.currentMode = .draw
                print("DEBUG: Draw Mode activate")
                
            }){
                Image(systemName: "scribble.variable")
            }
            .buttonStyle(.plain)
            .padding()
           
            Button(action:{
                arLogic.currentMode = .camera
                print("DEBUG: Camera Mode activate")
            }){
                Image(systemName: "camera")
            }
            .buttonStyle(.plain)
            .padding()
            
            
        }
    }
    
}

#Preview {
    ToolView()
}
