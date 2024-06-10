//
//  CompleteView.swift
//  SmartUndiesV1
//
//  Created by David on 7/25/23.
//

import SwiftUI

struct CompleteView: View {
    @ObservedObject var bluetoothViewModel: BluetoothViewModel

    var body: some View {
        ZStack {
            Color(hex: "#262626").edgesIgnoringSafeArea(.all) // Apply the background color to the entire view
            
            VStack {
                Text("Data transmission complete.")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white) // Make sure the text is visible against the dark background
                
                Spacer()
                
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaleEffect(3) // Adjust if necessary based on your UI design
                    .foregroundColor(Color.accentColor)
                
                Spacer()
                
                Button("Show Results", action: {
                    bluetoothViewModel.graphAvailable = true
                    bluetoothViewModel.isComplete = false
                })
                .padding()
                .background(Color.accentColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                
                Spacer()
            }
        }
    }
}


