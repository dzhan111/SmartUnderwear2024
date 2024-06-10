import SwiftUI

struct PeripheralView: View {
    @StateObject private var bluetoothViewModel = BluetoothViewModel()
    @State private var isLoading = false
    var body: some View {
        ZStack {
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)
            VStack {
                if (bluetoothViewModel.showingConnectedView){
                    ConnectedView(bluetoothViewModel: bluetoothViewModel)
                        .navigationTitle("Transmitting data...")
                        .foregroundColor(.white)
                    
                }else if(bluetoothViewModel.isComplete){
                    CompleteView(bluetoothViewModel: bluetoothViewModel)
                        .navigationTitle("")
                }else if(bluetoothViewModel.graphAvailable){
                    LineChart()
                        .navigationTitle("Results")
                        .foregroundColor(.white)
                        
                } else {
                    if bluetoothViewModel.peripheralNames.isEmpty {
                        Text("No devices found. \nPlease check to make sure that the Ventos is in pairing mode.")
                            .padding()
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    } else {
                        ZStack{
                            
                            
                            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheralName in
                                Button(action: {
                                    let index = bluetoothViewModel.peripheralNames.firstIndex(of: peripheralName)!
                                    let peripheral = bluetoothViewModel.peripherals[index]
                                    
                                    bluetoothViewModel.connectToPeripheral(peripheral: peripheral)
                                    isLoading = true
                                    //send acknowledge to device to begin transmitting data to the phone
                                    //bluetoothViewModel.sendDataSignal()
                                    
                                    
                                }) {
                                    Text(peripheralName)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            if isLoading { // Show the progress view when isLoading is true
                                ProgressView("Connecting ...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .minimumScaleFactor(2)
                                    .foregroundColor(.white) 
                            }
                            
                        }
                        
                    }//else
                }
            }
            .navigationBarBackButtonHidden()
            .environmentObject(bluetoothViewModel)
        }
    
        .onDisappear {
            bluetoothViewModel.disconnectPeripheral()
        }
    }
}

struct PeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralView()
    }
}

