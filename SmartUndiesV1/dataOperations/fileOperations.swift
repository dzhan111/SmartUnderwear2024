//
//  writeToFile.swift
//  BLE_dataSend
//
//  Created by David on 7/12/23.
//

import Foundation


//clearFile function
//clears all relevant files
func clearFile() {
    do {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access Documents directory.")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("rawData.txt")
        let fileUnsorted = documentsDirectory.appendingPathComponent("unsorted.txt")
        let fileSorted = documentsDirectory.appendingPathComponent("sorted.txt")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
                // Create the file if it doesn't exist
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        
        if !FileManager.default.fileExists(atPath: fileUnsorted.path) {
                // Create the file if it doesn't exist
            FileManager.default.createFile(atPath: fileUnsorted.path, contents: nil, attributes: nil)
        }
        
        if !FileManager.default.fileExists(atPath: fileSorted.path) {
                // Create the file if it doesn't exist
            FileManager.default.createFile(atPath: fileSorted.path, contents: nil, attributes: nil)
        }
        
        // Open the file in write mode and truncate its contents
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        fileHandle.truncateFile(atOffset: 0)
        
        let fileHandle2 = try FileHandle(forWritingTo: fileUnsorted)
        fileHandle2.truncateFile(atOffset: 0)
        
        let fileHandle3 = try FileHandle(forWritingTo: fileSorted)
        fileHandle3.truncateFile(atOffset: 0)
        
        
        // Close the file handle
        fileHandle.closeFile()
        fileHandle2.closeFile()
        fileHandle3.closeFile()
        
        print("File cleared successfully.")
    } catch {
        print("Error clearing file: \(error.localizedDescription)")
    }
}

