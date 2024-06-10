//
//  PairedView.swift
//  SmartUndiesV1
//
//  Created by David on 7/20/23.
//

import SwiftUI

struct PairedView: View {
    @ObservedObject var bluetoothViewModel = BluetoothViewModel1()
    var body: some View {
        ZStack {
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)
            VStack {
                
                Spacer()
                Text("Your device is now connected. Please attach the device to your undergarments and press 'Start Test' to begin. ")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding(20)
                    .foregroundColor(.white)
                Spacer()
                
                Button(action: {
                    
                    bluetoothViewModel.timerView = true
                    bluetoothViewModel.disconnectPeripheral()
                    
                    //send acknowledge command in order to start the timer on the SU
                    
                    
                    
                }) {
                    Text("Start Test")
                        .font(.title)
                    //.fontWeight(.bold)
                        .padding(.all)
                        .background(Color.accentColor)
                        .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                }
                Spacer()
                
            }
        }
    }
}

struct PairedView_Previews: PreviewProvider {
    static var previews: some View {
        PairedView()
    }
}
