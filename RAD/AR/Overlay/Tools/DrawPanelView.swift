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
    
    @State var start = Date.now
    
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
                    TimelineView(.animation){ tl in
                        let time = start.distance(to: tl.date)
                        ZStack {
                            if arLogic.currentActiveMode == .erasing {
                                HStack{
                                    Circle().fill(Color.blue)
                                        .colorEffect(
                                            ShaderLibrary.rainbow(.float(time))
                                        )
                                        .frame(width: 30, height: 30)
                                }.clipShape(Circle())
                            }
                            HStack{
                                Image(systemName: "eraser")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .imageScale(.small)
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    
                            }
                            .background( Material.ultraThin)
                            .clipShape(Circle())
                            
                        }
                        
                        Text("Eraser")
                            .font(adjustedFont)
                    }
                        
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
                    
                    TimelineView(.animation){ tl in
                        let time = start.distance(to: tl.date)
                        ZStack {
                            
                            if arLogic.currentActiveMode == .drawing {
                                HStack{
                                    Circle().fill(Color.blue)
                                        .colorEffect(
                                            ShaderLibrary.rainbow(.float(time))
                                        )
                                        .frame(width: 30, height: 30)
                                }.clipShape(Circle())
                            }
                            HStack{
                                Image(systemName: "paintbrush.pointed")
                                    .resizable()
                                    .font(adjustedFont)
                                    .aspectRatio(contentMode: .fit)
                                    .imageScale(.small)
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    
                            }
                            .background( Material.ultraThin)
                            .clipShape(Circle())
                        }
                        
                        Text("Brush")
                            .font(adjustedFont)
                            
                    }
                    
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            
            VStack{
                HStack{
                Image(systemName: "paintbrush.pointed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .imageScale(.small)
                        .frame(width: 20, height: 20)
                        .padding()
                        .opacity(0)
                        .overlay{
                            ColorPicker("",selection: $selectedColor)
                                .labelsHidden()
                                .imageScale(.large)
                                .frame(width: 25, height: 25)
                                .clipShape(Circle())
                        }
                }.background(.ultraThinMaterial)
                    .clipShape(Circle())
                
        
                Text("Pallete")
                    .font(adjustedFont)
            }
                
            .padding(.horizontal)
//            Button(action:{
//          
//                
//            }) {
//                VStack{
//                    HStack{
//                        Image(systemName: "eyedropper")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .imageScale(.small)
//                            .frame(width: 20, height: 20)
//                            .padding()
//                    }
//                    .background(arLogic.currentActiveMode == .shaping ? Material.ultraThick : Material.ultraThin)
//                    .clipShape(Circle())
//                    
//                    Text("Picker")
//                        .font(adjustedFont)
//                }
//                
//            }
//            .buttonStyle(.plain)
//            .padding(.horizontal)
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
        .onChange(of: selectedColor) {
            arLogic.selectedColor = selectedColor
        }
       
    }
}


#Preview {
    DrawPanelView(selectedColor: .black)
}
