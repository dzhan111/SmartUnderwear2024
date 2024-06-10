//
//  Parser.swift
//  dataParserText
//
//  Created by David on 6/29/23.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Darwin


func parseData(atURL: URL) {
    var count = 0

   
    let content = readFile(atURL: atURL)
        
    count = content.count
    
    
    print("Total lines: \(count)")

    
    //declaration of arrays
    //change all to String if needed
    let time1: [String] = []
    let unfiltered_high_gain: [String] = []
    
    let time2: [String] = []
    let unfiltered_high_gain2: [String] = []
    let temperature: [String] = []
    let sniff: [String] = []
    
    let header_time1 = ["time1"]
    let header_unfiltered_high_gain = ["unfiltered_high_gain"]
    
    let header_time2 = ["time2"]
    let header_unfiltered_high_gain2 = ["unfiltered_high_gain2"]
    let header_temperature = ["temperature"]
    let header_sniff = ["sniff"]
    
    var table_data1: [[String]] = [header_time1, time1,
                                header_unfiltered_high_gain, unfiltered_high_gain]

    var table_data2: [[String]] = [header_time2, time2,
                                header_unfiltered_high_gain2, unfiltered_high_gain2,
                                header_temperature, temperature,
                                header_sniff, sniff]
    
    //figure out how to change
    let pattern1: String = "3 2"
    let pattern2: String = "3 2 1 1"
    
    
    let PRINT = 0
    let tracking_num = count
    
    
    
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Unable to access Documents directory.")
        return
    }
    let filePath = documentsDirectory.appendingPathComponent("unsorted.txt")
    let file = filePath.absoluteString
    //redirectStdout(toFile: file)
    printData(trackingNum: tracking_num)
    
    
    
    //input file to orderFile
    let fileURL = documentsDirectory.appendingPathComponent("unsorted.txt")
    
    if !FileManager.default.fileExists(atPath: fileURL.path) {
            // Create the file if it doesn't exist
        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
    }
    
    orderFile(fileURL: fileURL)
    
    
    //function declarations
    func save(info: Any, column_name: String) {
        
        if column_name == "time1" {
           // time1.append(info as! String)
            table_data1[1].append(info as! String)
        } else if column_name == "Sensor 1 unfiltered high gain" {
            //unfiltered_high_gain.append(info as! String)
            table_data1[3].append(info as! String)
        } else if column_name == "time2" {
            //time2.append(info as! String)
            table_data2[1].append(info as! String)
        } else if column_name == "Sensor 1 unfiltered high gain2" {
            //unfiltered_high_gain2.append(info as! String)
            table_data2[3].append(info as! String)
            //print("beans2 + \(unfiltered_high_gain2)")
        } else if column_name == "temperature" {
            //temperature.append(info as! String)
            table_data2[5].append(info as! String)
        } else if column_name == "sniff" {
            //sniff.append(info as! String)
            table_data2[7].append(info as! String)
        } else {
            print("Check column names")
        }
        
        
    }
    
    func endOfBlock(initial_index: Int, max_flash_index: Int, null_bytes: Int) -> Int {
        
        var result = 0
        var counter = 0
        var updatedIndex = initial_index
        
        while updatedIndex <= max_flash_index && counter != null_bytes {
            
           
            result = Int(content[updatedIndex]) ?? 0
            updatedIndex += 1
            
            if result == 255 {
                counter += 1
            } else {
                counter = 0
            }
        }
        
        return updatedIndex - null_bytes - 1
    }
    
    
    func flashRead(addr: Int, bytesNum: Int) -> Int {
        var toreconstitute = [Int?](repeating: nil, count: bytesNum)
        var reconstituted = 0
        
        if bytesNum == 4 {
            for i in 0..<bytesNum {
                let readAddr = addr + i
                toreconstitute[i] = Int(content[readAddr])
            }
            reconstituted = (toreconstitute[3]! << 24) | (toreconstitute[2]! << 16) | (toreconstitute[1]! << 8) | (toreconstitute[0]! & 0xff)
        } else if bytesNum == 3 {
            for i in 0..<bytesNum {
                let readAddr = addr + i
                toreconstitute[i] = Int(content[readAddr])
                
                
            }
            reconstituted = (toreconstitute[2]! << 16) | (toreconstitute[1]! << 8) | (toreconstitute[0]! & 0xff)
        } else if bytesNum == 2 {
            for i in 0..<bytesNum {
                let readAddr = addr + i
                toreconstitute[i] = Int(content[readAddr])
            }
            reconstituted = (toreconstitute[1]! << 8) | (toreconstitute[0]! & 0xff)
        } else if bytesNum == 1 {
            for i in 0..<bytesNum {
                let readAddr = addr + i
                toreconstitute[i] = Int(content[readAddr])
            }
            reconstituted = toreconstitute[0]! & 0xff
        }
        
        return reconstituted
    }
    
    
    
    func blockPattern(index: Int, maxFlashIndex: Int, nullBytes: Int) -> String {
        
        let lastindex = endOfBlock(initial_index: index, max_flash_index: maxFlashIndex, null_bytes: nullBytes)
        let pattern2Count = addPatternNumbers(string: pattern2)
        
        if (lastindex - index) == (pattern2Count - 1) {
            return pattern2
        } else {
            return pattern1
        }
    }
    
    
    
    func selectFile() -> URL? {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText), String(kUTTypePlainText)], in: .import)
        documentPicker.shouldShowFileExtensions = true
        documentPicker.allowsMultipleSelection = false
        documentPicker.directoryURL = URL(fileURLWithPath: "/")
        
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        viewController.present(documentPicker, animated: true, completion: nil)
        
        return nil
    }
    
    func readFile(atURL url: URL) -> [String] {
        let fileManager = FileManager.default

        // Check if the file exists at the given URL
        if fileManager.fileExists(atPath: url.path) {
            do {
                // Read the contents of the file
                let fileContents = try String(contentsOf: url, encoding: .utf8)

                // Split the file contents into an array using a newline delimiter
                let lines = fileContents.components(separatedBy: .newlines)
                //print("lines \(lines)")
                return lines
            } catch {
                print("Failed to read file at URL: \(url), error: \(error)")
                return []
            }
        } else {
            print("File does not exist at URL: \(url)")
            return []
        }
    }




    
    func printData(trackingNum: Int) {
    
        let flashData = readFlash(flashTrackingNumber: trackingNum - 1, nullBytes: 3)

        if !table_data2[1].isEmpty {
            var first = table_data2[1][0]
            var dec = 0.1
            var indexTime = 0
            // table 2
            for (index2, row2) in table_data2[1].enumerated() {
                // table 1
                for (index1, row1) in table_data1[1].enumerated() {
                    if table_data2[1][index2] == table_data1[1][index1] {
                        table_data2[1][index2] = String(Double(table_data2[1][index2])! + dec)
                        dec += 0.1
                    }
                }
                dec = 0.1
            }
        }

        
        // Get the file URL for the Documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access Documents directory.")
            return
        }
        

        // Append the desired file name to the Documents directory URL
        let fileURL = documentsDirectory.appendingPathComponent("unsorted.txt")

        // Create the file if it doesn't exist
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        
        // Create a FileHandle in append mode
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            fileHandle.seekToEndOfFile()

            // Save and print the data simultaneously
            for i in 0..<table_data2[1].count {
                let row = table_data2[1][i]
                let rowData2 = table_data2[3][i]
                let rowData3 = table_data2[5][i]
                let rowData4 = table_data2[7][i]

                let rowString = row.map { String($0) }.joined(separator: ",")
                let rowData2String = rowData2.map { String($0) }.joined(separator: ",")
                let rowData3String = rowData3.map { String($0) }.joined(separator: ",")
                let rowData4String = rowData4.map { String($0) }.joined()


                // Write the data to the file
                let line = "\(row),\(rowData2),\(rowData3),\(rowData4)\n"
                if let data = line.data(using: .utf8) {
                    fileHandle.write(data)
                }
            }

            // Close the file handle
            fileHandle.closeFile()
        } catch {
            print("Error writing file: \(error.localizedDescription)")
        }

        // Print table_data1 to the console and save it to the file
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            fileHandle.seekToEndOfFile()

            for i in 0..<table_data1[1].count {
                let row = table_data1[1][i]
                let rowData2 = table_data1[3][i]

                let rowString = row.map { String($0) }.joined(separator: ",")
                let rowData2String = rowData2.map { String($0) }.joined(separator: ",")

                // Write the data to the file
                let line = "\(row),\(rowData2)\n"
                if let data = line.data(using: .utf8) {
                    fileHandle.write(data)
                }
            }

            // Close the file handle
            fileHandle.closeFile()
        } catch {
            print("Error writing file: \(error.localizedDescription)")
        }
        
        
    }//print data
    
    
    func addPatternNumbers(string: String) -> Int {
        let patternNumbers = string
            .split(separator: " ")
            .filter { $0.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil }
            .map { Int($0) ?? 0 }
        let total = patternNumbers.reduce(0, +)
        return total
    }//addPatternNumbers
    
    
    func readFlash(flashTrackingNumber: Int, nullBytes: Int) {
        
        
        var index = 0
        var endOfBlockVar = 0

        while index <= flashTrackingNumber {
           
            endOfBlockVar = endOfBlock(initial_index: index, max_flash_index: flashTrackingNumber, null_bytes: nullBytes)
            let bytePattern = blockPattern(index: index, maxFlashIndex: flashTrackingNumber, nullBytes: nullBytes)
            readBlock(initialIndexValue: index, addressTracker: endOfBlockVar, bytePattern: bytePattern)
            index = endOfBlockVar + nullBytes + 1
            //print("bytePattern:  \(bytePattern)")
            
            
        }
    }//readFlash
    
    
    func readBlock(initialIndexValue: Int, addressTracker: Int, bytePattern: String) {
        
        var bytesNum = [Int](repeating: 0, count: 50)
        var iterationIndex = 0
        var iterator = 0
        let s = bytePattern.split(separator: " ")
        var headers: [String] = []
        var bytesAccum = [Int](repeating: 0, count: 50)
        bytesAccum[0] = 0
        var accum = 0
        
        if bytePattern == pattern1 {
            headers = ["time1", "Sensor 1 unfiltered high gain"] // consider a global header for flexibility
        }
        
        if bytePattern == pattern2 {
            headers = ["time2", "Sensor 1 unfiltered high gain2", "temperature", "sniff"]
        }
        
        for k in s {
            if let aux = Int(k) {
                iterationIndex += aux
                bytesNum[iterator] = aux
                iterator += 1
            }
        }
        
        for l in 0..<(bytePattern.count + 1) / 2 {
            accum += bytesNum[l]
            bytesAccum[l + 1] = accum
        }
    
        
        for j in 0..<(bytePattern.count + 1) / 2 {
            let indexValue = bytesAccum[j] + initialIndexValue

                        
            for i in stride(from: indexValue, through: addressTracker, by: iterationIndex) {
                let dataOutput = String(flashRead(addr: i, bytesNum: bytesNum[j]))
                
                
                save(info: dataOutput, column_name: headers[j])
                
                
            }
        }
    }//readBlock


    func redirectStdout(toFile filePath: String) {
        // Open the file for writing
        let file = fopen(filePath, "w")
        
        // Get the file descriptor of the file
        let fileDescriptor = fileno(file)
        
        // Duplicate the file descriptor onto stdout
        if dup2(fileDescriptor, STDOUT_FILENO) == -1 {
            fatalError("Failed to redirect stdout")
        }
        
        // Close the file stream
        fclose(file)
    }

    
}//Main
    



