//
//  DrawPanelView.swift
//  RAD
//
//  Created by Linar Zinatullin on 22/02/24.
//

import SwiftUI


struct DrawPanelView: View {
    

    var body : some View{
        HStack{
            Button(action:{}) {
                VStack{
                    Image(systemName: "eraser")
                    Text("Eraser")
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            Button(action:{}) {
                VStack{
                    Image(systemName: "paintbrush.pointed")
                    Text("Brushes")
                }
            }
            .buttonStyle(.plain)
            .padding()
            Button(action:{}) {
                VStack{
                    Image(systemName: "square.fill")
                        .foregroundStyle(.black)
                    Text("Pallete")
                }
            }
            .buttonStyle(.plain)
            .padding()
            Button(action:{}) {
                VStack{
                    Image(systemName: "eyedropper")
                    Text("Picker")
                }
            }
            .buttonStyle(.plain)
            .padding()
            Button(action:{}) {
                VStack{
                    Image(systemName: "rectangle.fill.on.rectangle.fill")
                    Text("Layers")
                }
            }
            .buttonStyle(.plain)
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(.black)
            .opacity(0.5)
        )
    }
}


#Preview {
    DrawPanelView()
}
