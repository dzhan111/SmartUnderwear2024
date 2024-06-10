//
//  InstructionSheetView.swift
//  SmartUndiesV1
//
//  Created by David on 7/21/23.
//

import SwiftUI

struct InstructionSheetView: View {
    var body: some View {
        // Use ZStack to ensure the background covers the entire screen
        ZStack {
            // Apply background color to ZStack to cover the entire view
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)
            
            // Place your Text view inside the ZStack
            Text("These are the instructions that are available anytime. The User will see these by tapping the icon in the top right corner")
                .multilineTextAlignment(.center)
                .padding(40)
                .foregroundColor(.white) // Ensure text is visible on a dark background
                .font(.system(.body).bold())
        }
    }
}

struct InstructionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionSheetView()
    }
}
