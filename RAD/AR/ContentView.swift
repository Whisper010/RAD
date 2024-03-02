//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    
    
    @State var updater: Bool = false
    
    var body: some View {
        
        ZStack(alignment:.bottom){
            ARViewContainer()
                .ignoresSafeArea(.all)
            
            OverlayView()

        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
