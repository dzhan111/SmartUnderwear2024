import SwiftUI

struct PeripheralView: View {
    @StateObject private var bluetoothViewModel = BluetoothViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if (bluetoothViewModel.showingConnectedView){
                    ConnectedView(bluetoothViewModel: bluetoothViewModel)
                }else if(bluetoothViewModel.graphAvailable){
                    LineChart(bluetoothViewModel: bluetoothViewModel)
                } else {
                    if bluetoothViewModel.peripheralNames.isEmpty {
                        Text("No devices found")
                    } else {
                        List(bluetoothViewModel.peripheralNames, id: \.self) { peripheralName in
                            Button(action: {
                                let index = bluetoothViewModel.peripheralNames.firstIndex(of: peripheralName)!
                                let peripheral = bluetoothViewModel.peripherals[index]
                                bluetoothViewModel.connectToPeripheral(peripheral: peripheral)
                            }) {
                                Text(peripheralName)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bluetooth")
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

