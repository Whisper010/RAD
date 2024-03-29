//
//  RADApp.swift
//  RAD
//
//  Created by Linar Zinatullin on 13/02/24.
//

import SwiftUI

@main
struct RADApp: App {
    
    private var arLogic = ARLogic()
    
    var body: some Scene {
        WindowGroup {
            
            ContentView().preferredColorScheme(.dark)
                .environment(arLogic)
        
        }
    }
}
