//
//  ContentView.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    
    
    @State var updater: Bool = false
    @Environment(ARLogic.self) private var arLogic
    
    @State var showMessage: Bool = false
    
    var body: some View {
        
        ZStack(alignment:.bottom){
            ARViewContainer()
                .ignoresSafeArea(.all)
            
            OverlayView()
                
        }.alert(isPresented: $showMessage) {
            Alert(title: Text("Warning"), message: Text("This device does not support LiDAR technology. Some features may not be available."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            showMessage = arLogic.hasLidar
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
