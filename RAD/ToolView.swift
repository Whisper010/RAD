//
//  ToolView.swift
//  RAD
//
//  Created by Linar Zinatullin on 22/02/24.
//

import SwiftUI

struct ToolView: View{
    
    private var arLogic = ARLogic.shared
    
    var body: some View{
        HStack(){
            
            Button(action:{
                arLogic.showingShapesPicker.toggle()
                print("DEBUG: Draw Mode activate")
            }){
                Image(systemName: "rectangle.3.group")
                
            }
            .buttonStyle(.plain)
            .padding()
            Button(action:{
                arLogic.isDrawPanelEnabled = true
                print("DEBUG: Draw Mode activate")
                
            }){
                Image(systemName: "scribble.variable")
            }
            .buttonStyle(.plain)
            .padding()
            Button(action:{
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
