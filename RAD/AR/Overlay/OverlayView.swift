//
//  OverlayView.swift
//  RAD
//
//  Created by Linar Zinatullin on 02/03/24.
//

import SwiftUI


struct OverlayView: View {
    
    @Environment(ARLogic.self) private var arLogic
    
    var body: some View {
        VStack{
            if arLogic.currentSelectedTool == .shape  {
                ShapeView()
                    .transition(.move(edge: .bottom))
            }
            if arLogic.currentSelectedTool == .brush {
                DrawPanelView(selectedColor: arLogic.selectedColor)
            }
            if arLogic.currentSelectedTool == .camera {
                CameraInterfaceView()
            }
            if arLogic.currentSelectedTool != .camera {
                ToolView()
                
            }
        }
        
    }
}
