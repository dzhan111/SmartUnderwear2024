import CoreBluetooth
import SwiftUI

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var showingConnectedView = false
    @Published var runningProgram = false
    @Published var graphAvailable = false
    @Published var receivedData: String = ""
    var nullCount : Int = 0
    var refresh: Int = 0
    var firstRound: Bool = true

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
        clearFile()
        receivedData = ""
    }

    // ...
    
    // Method to process and display received data
    func displayReceivedData(_ data: Data) {
        //print("read data: \(data)")
        
        // Convert the data bytes to an array of integers
        let integers = data.map { Int($0) }
        
        // Process the received integers
        for integerValue in integers {

            // Perform further processing or formatting of the received integers as needed
            print("\(integerValue)")
            
            // Example: Write the integer to a file
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Unable to access Documents directory.")
                return
            }
            
            //let fileURL = documentsDirectory.appendingPathComponent("rawData.txt")
            
            do {
                // Convert the integer to a string
                let stringValue = String(integerValue)
                
                // Append a newline character to the string
                let dataString = stringValue + "\n"
                receivedData = receivedData + stringValue + ","
                
                // Get the file URL for the Documents directory
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    print("Unable to access Documents directory.")
                    return
                }
                
                // Append the desired file name to the Documents directory URL
                let fileURL = documentsDirectory.appendingPathComponent("rawData.txt")
                
                // Create a FileHandle in append mode
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                
                // Convert the string to data
                if let data = dataString.data(using: .utf8) {
                    // Write the data at the end of the file
                    fileHandle.write(data)
                    
                    //print("Data appended to file successfully.")
                }
                
                // Close the file handle
                fileHandle.closeFile()
            } catch {
                print("Error writing file: \(error.localizedDescription)")
            }
            
            if(integerValue == 255){
                nullCount += 1
                
            }else{
                nullCount = 0
            }
            
            if(nullCount == 4){
                if(firstRound){
                    clearFile()
                    firstRound = false
                }else{
                    disconnectPeripheral()
                    
                    
                    //parse data
                    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        print("Unable to access Documents directory.")
                        return
                    }
                    let fileURL = documentsDirectory.appendingPathComponent("rawData.txt")
                    
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                            // Create the file if it doesn't exist
                        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
                    }
                    
                    parseData(atURL: fileURL)
                    graphAvailable = true
                }
            }
            
            
        }
    }

    // Connect function
    func connectToPeripheral(peripheral: CBPeripheral) {
        self.centralManager?.connect(peripheral, options: nil)
        clearFile()
        receivedData = ""
        graphAvailable = false
    }

    // Disconnect function
    func disconnectPeripheral() {
        if let peripheral = connectedPeripheral {
            if peripheral.state != .disconnected {
                centralManager?.cancelPeripheralConnection(peripheral)
            }
            // Reset the connectedPeripheral property
            connectedPeripheral = nil
        }
        
        print("Disconnected")
        
        
    }
    
    func disconnectPeripheralButton() {
        if let peripheral = connectedPeripheral {
            if peripheral.state != .disconnected {
                centralManager?.cancelPeripheralConnection(peripheral)
            }
            // Reset the connectedPeripheral property
            connectedPeripheral = nil
        }
        
        runningProgram = false
        print("Disconnected")
        
        
    }

}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)

            if let peripheralName = peripheral.name {
                self.peripheralNames.append(peripheralName)
            } else if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                self.peripheralNames.append(advertisementName)
            } else {
                self.peripheralNames.append("Unnamed Device")
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unnamed Device")")
        showingConnectedView = true
        connectedPeripheral = peripheral

        // Set the peripheral delegate to receive data
        peripheral.delegate = self
        // Discover services and characteristics
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral.name ?? "Unnamed Device")")
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral.name ?? "Unnamed Device")")
        // Perform further actions as needed after disconnection
        showingConnectedView = false
        connectedPeripheral = nil
    }
}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }

            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            // Process and display received data
            displayReceivedData(data)
            
            
        }
    }
}

extension BluetoothViewModel {
    // Function to send data back to the connected device
    func sendDataToDevice(_ dataString: String) {
        guard let peripheral = connectedPeripheral else {
            print("No connected peripheral.")
            return
        }
        
        guard let characteristic = findCharacteristicForSendingData(peripheral) else {
            print("Unable to find characteristic for sending data.")
            return
        }
        
        if let data = dataString.data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            print("Data sent successfully.")
        } else {
            print("Failed to convert string to data.")
        }
    }
    
    // Helper method to find the appropriate characteristic for sending data
    private func findCharacteristicForSendingData(_ peripheral: CBPeripheral) -> CBCharacteristic? {
        guard let services = peripheral.services else {
            return nil
        }
        
        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }
            
            for characteristic in characteristics {
                // Replace the UUID below with the appropriate UUID of the characteristic you want to use for sending data
                if characteristic.uuid == CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e") {
                    return characteristic
                }
            }
        }
        
        return nil
    }
}

