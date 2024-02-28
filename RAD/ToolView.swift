//
//  ToolView.swift
//  RAD
//
//  Created by Linar Zinatullin on 22/02/24.
//

import SwiftUI

struct ToolView: View{
    
    @Environment(ARLogic.self) private var arLogic
    
    let tapGesture = TapGesture()
    
    var body: some View{
        HStack(spacing: 20){
            
            Button(action:{
                arLogic.currentMode = .shape
                print("DEBUG: Draw Mode activate")
            }){
                HStack{
                    Image(systemName: "rectangle.3.group")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:50)
                }
            }
            .padding()
            .buttonStyle(PlainButtonStyle())
            
            Button(action:{
                arLogic.currentMode = .draw
                print("DEBUG: Draw Mode activate")
                
            }){
                HStack{
                    Image(systemName: "scribble.variable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                }
            }
            
            .padding()
            .buttonStyle(PlainButtonStyle())
            
           
            Button(action:{
                arLogic.currentMode = .camera
                print("DEBUG: Camera Mode activate")
            }){
                HStack{
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                }
                
            }
            
            .padding()
            .buttonStyle(PlainButtonStyle())
            
            
            
        }
    }
        
    
}

#Preview {
    ToolView()
}
