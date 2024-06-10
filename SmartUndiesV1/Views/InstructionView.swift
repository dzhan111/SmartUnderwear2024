//
//  InstructionView.swift
//  SmartUndiesV1
//
//  Created by David on 7/21/23.
//

import SwiftUI

import SwiftUI

struct InstructionView: View {
    @State private var nextView = false
    @State private var showInstructions = false

    var body: some View {
        ZStack {
            // Apply background color to ZStack to cover the entire view
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)

            // Main content
            if (!nextView) {
                VStack(alignment: .center) {
                    Spacer()
                    Text("These are sample instructions")
                        .font(.title)
                        .foregroundColor(.white) // Ensure text is visible on the dark background
                     
                    Text("1. User will be able to access these anytime by tapping the icon in the top left corner \n\n2. You can link the terms and condition \n\n3. Taking care of liabilities can also be here")
                        .multilineTextAlignment(.leading)
                        .padding(30)
                        .foregroundColor(.white) // Ensure text is visible on the dark background
                        .font(.system(.body).bold())
                    Spacer()
                    Button("I wish to proceed", action: {
                        nextView = true
                    })
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .font(.system(.body).bold())
                    Spacer()
                }
            } else {
                PairView() // Make sure this view also supports dark background or has its own background set appropriately
                    .navigationTitle("Connect to device")
                    .foregroundColor(.white)
            }
        }
        .foregroundColor(.white) // Set default text color for the whole ZStack
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
    }
}
