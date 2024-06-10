//
//  Success.swift
//  BLE_dataSend
//
//  Created by David on 7/12/23.
//

import SwiftUI


struct ConnectedView: View {
    @ObservedObject var bluetoothViewModel: BluetoothViewModel
    @State public var showGraph = false
    var body: some View {
        
        NavigationView {
            VStack {
            
                
                Text("Connected to \(bluetoothViewModel.connectedPeripheral?.name ?? "Unnamed Device")")
                //Text("Received Data: \(bluetoothViewModel.receivedData)")
                
                Button(action: {
                    bluetoothViewModel.disconnectPeripheralButton()
                }) {
                    Text("Disconnect")
                }
                
                
                
                
                
                
            }
            
        }
                    
    }
        
}


