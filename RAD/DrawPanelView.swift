//
//  DrawPanelView.swift
//  RAD
//
//  Created by Linar Zinatullin on 22/02/24.
//

import SwiftUI


struct DrawPanelView: View {
    
    @Environment(ARLogic.self) private var arLogic
    @State var selectedColor: Color = .blue
    let adjustedFont: Font = .caption
    
    var body : some View{
        
        HStack{
            Button(action:{
                if arLogic.currentActiveMode != .erasing {
                    arLogic.currentActiveMode = .erasing
                    print("DEBUG: Erasing Mode Active")
                } else {
                    arLogic.currentActiveMode = .none
                    print("DEBUG: Erasing Mode Inactive")
                }
            }) {
                VStack{
                    Image(systemName: "eraser")
                    Text("Eraser")
                        .font(adjustedFont)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            Button(action:{
                if arLogic.currentActiveMode != .drawing {
                    arLogic.currentActiveMode = .drawing
                    print("DEBUG: Drawing Mode Active")
                } else {
                    arLogic.currentActiveMode = .none
                    print("DEBUG: Drawing Mode Inactive")
                }
            }) {
                VStack{
                    Image(systemName: "paintbrush.pointed")
                    Text("Brushes")
                        .font(adjustedFont)
                }
            }
            .buttonStyle(.plain)
            .padding()
            
            VStack{
                Image(systemName: "paintbrush.pointed")
                    .opacity(0)
                    .overlay{
                        ColorPicker("",selection: $selectedColor)
                            .labelsHidden()
                            .frame(width: 21, height: 21)
                            .clipShape(Circle())
                    }
        
                Text("Pallete")
                    .font(adjustedFont)
            }
                
            .padding()
            Button(action:{}) {
                VStack{
                    Image(systemName: "eyedropper")
                    Text("Picker")
                        .font(adjustedFont)
                }
            }
            .buttonStyle(.plain)
            .padding()
//            Button(action:{}) {
//                VStack{
//                    Image(systemName: "rectangle.fill.on.rectangle.fill")
//                    Text("Layers")
//                        .font(adjustedFont)
//                }
//            }
//            .buttonStyle(.plain)
//            .padding()
        }
        .padding([.top, .bottom], 12)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(.black)
            .opacity(0.5)
        )
       
    }
}


#Preview {
    DrawPanelView(selectedColor: .black)
}
