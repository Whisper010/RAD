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
        HStack(spacing: 45){
            
            Button(action:{
                arLogic.currentMode = .shape
                print("DEBUG: Draw Mode activate")
                
            }){
                HStack{
                    Image(systemName: "rectangle.3.group")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .imageScale(.small)
                        .frame(width: 20, height: 20)
                        .padding()
                    
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }.buttonStyle(PlainButtonStyle())
            
           
            
            Button(action:{
                arLogic.currentMode = .draw
                print("DEBUG: Draw Mode activate")
                
            }){
                HStack{
                    Image(systemName: "scribble.variable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .imageScale(.small)
                        .frame(width: 20, height: 20)
                        .padding()
                        
                }
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
               
            }
            
            
            .buttonStyle(PlainButtonStyle())
            
           
            Button(action:{
                arLogic.currentMode = .camera
                print("DEBUG: Camera Mode activate")
            }){
                HStack{
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .imageScale(.small)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(PlainButtonStyle())
            
            
            
        }
       
    }
        
    
}

#Preview {
    ToolView()
}
