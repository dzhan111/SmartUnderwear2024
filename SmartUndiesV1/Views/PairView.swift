//
//  PairView.swift
//  SmartUndiesV1
//
//  Created by David on 7/20/23.
//

import SwiftUI

struct PairView: View {
    @StateObject private var bluetoothViewModel = BluetoothViewModel1()
    @State private var isLoading = false

    var body: some View {
        ZStack {
            // Apply the hex color as background to the entire view
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)

            VStack {
                if (bluetoothViewModel.paired) {
                    PairedView(bluetoothViewModel: bluetoothViewModel)
                        .navigationTitle("Device Connected")
                        .foregroundColor(.white)
                } else if (bluetoothViewModel.timerView) {
                    TimerView()
                        .navigationTitle("Time Left")
                        .foregroundColor(.white)
                } else if (bluetoothViewModel.peripheralNames.isEmpty) {
                    Text("No devices found. \n\nPlease check to make sure that the Ventos is in pairing mode.")
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white) // Ensure text is visible against the dark background
                        .font(.system(.body).bold())
                } else {
                    ZStack {
                        List(bluetoothViewModel.peripheralNames, id: \.self) { peripheralName in
                            Button(action: {
                                let index = bluetoothViewModel.peripheralNames.firstIndex(of: peripheralName)!
                                let peripheral = bluetoothViewModel.peripherals[index]
                                bluetoothViewModel.connectToPeripheral(peripheral: peripheral)
                                isLoading = true
                            }) {
                                Text(peripheralName)
                                    .foregroundColor(.white) // Ensure list text is visible
                            }
                        }
                        .listStyle(PlainListStyle()) // Optional: Apply a plain list style

                        if isLoading { // Show the progress view when isLoading is true
                            ProgressView("Connecting ...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black.opacity(0.5)) // Optional: Dim the background when loading
                        }
                    }
                }
            }
            .foregroundColor(.white) // Set default text color for the VStack content
        }
        .onDisappear {
            bluetoothViewModel.disconnectPeripheral()
        }
    }
}

struct PairView_Previews: PreviewProvider {
    static var previews: some View {
        PairView()
    }
}
