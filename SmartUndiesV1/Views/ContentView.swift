//
//  ContentView.swift
//  SmartUndiesV1
//
//  Created by David on 7/18/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                .scaleEffect(4)
                
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

