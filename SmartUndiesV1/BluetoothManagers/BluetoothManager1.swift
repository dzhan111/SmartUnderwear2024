//
//  BluetoothManager1.swift
//  SmartUndiesV1
//
//  Created by David on 7/20/23.
//

import CoreBluetooth
import SwiftUI

class BluetoothViewModel1: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var paired = false
    @Published var timerView = false
    @Published var peripheral = false
    
    
    @Published var receivedData: String = ""
    var count : Int = 0
    var firstRound: Bool = true

    override init() {
        super.init()
        count = 0
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
        clearFile()
        receivedData = ""
    }

    // ...

    // Connect function
    func connectToPeripheral(peripheral: CBPeripheral) {
        self.centralManager?.connect(peripheral, options: nil)
        clearFile()
        receivedData = ""
        
    }

    // Disconnect function
    func disconnectPeripheral() {
        if let peripheral = connectedPeripheral {

            if peripheral.state != .disconnected {
                centralManager?.cancelPeripheralConnection(peripheral)
            }
            // Reset the connectedPeripheral property
            connectedPeripheral = nil
            paired = false
            
        }
        count = 0
        print("Disconnected")
        
        
        
    }
    
}

extension BluetoothViewModel1: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral)  {
            // Check if the name of the peripheral is "Feather nRF52328"
            if peripheral.name == "SUW" {
                self.peripherals.append(peripheral)
                self.peripheralNames.append("Ventos")
            } else {
                // If the name is not "Feather nRF52328", don't add it to the list
                // You can optionally add a default name for the peripheral here
                // For example:
                // self.peripheralNames.append("Unnamed Device")
            }
        }
    }


    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unnamed Device")")
        
        connectedPeripheral = peripheral

        // Set the peripheral delegate to receive data
        peripheral.delegate = self
        // Discover services and characteristics
        peripheral.discoverServices(nil)
        
        paired = true
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral.name ?? "Unnamed Device")")
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        paired = false
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral.name ?? "Unnamed Device")")
        // Perform further actions as needed after disconnection
        
        connectedPeripheral = nil
        paired = false
    }
}

extension BluetoothViewModel1: CBPeripheralDelegate {
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
        //only sends once WE press start when dc
        if(count < 1){
            sendDataToDevice("S")
            print("start signal: S")
            count += 1
            
        }
        
    }
    
    func sendStartSignal(character characteristic: CBCharacteristic) {
        //only sends once WE press start when dc
            sendDataToDevice("A")
            print("start signal: A")
            
        
        
    }
}


extension BluetoothViewModel1 {
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
    func findCharacteristicForSendingData(_ peripheral: CBPeripheral) -> CBCharacteristic? {
        guard let services = peripheral.services else {
            return nil
        }
        
        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }
            
            for characteristic in characteristics {
                // Replace the tri below with the appropriate UUID of the characteristic you want to use for sending data
                if characteristic.uuid == CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e") {
                    return characteristic
                }
            }
        }
        
        return nil
    }
}

