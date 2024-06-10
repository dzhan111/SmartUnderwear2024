import Foundation

func orderFile(fileURL: URL) {
    // Read data from the input file
    guard let inputString = try? String(contentsOf: fileURL, encoding: .utf8) else {
        print("Failed to read the input file.")
        return
    }
    
    // Split the input data into rows
    let rows = inputString.components(separatedBy: "\n")
    print(rows)
    // Create an array to store the parsed data
    var data: [(Double, Int, Int, Int)] = []
    
    // Parse and store the data
    for row in rows {
        let columns = row.components(separatedBy: ",")
        if columns.count == 2, let value1 = Double(columns[0].trimmingCharacters(in: .whitespacesAndNewlines)),
           let value2 = Int(columns[1].trimmingCharacters(in: .whitespacesAndNewlines)) {
            data.append((value1, value2, 0, 0))
        } else if columns.count == 4,
                  let value1 = Double(columns[0].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let value2 = Int(columns[1].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let value3 = Int(columns[2].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let value4 = Int(columns[3].trimmingCharacters(in: .whitespacesAndNewlines)){
            data.append((value1, value2, value3, value4))
        }
    }
    
    // Sort the data in ascending order based on the first column
    let sortedData = data.sorted { $0.0 < $1.0 }
    print(sortedData)
    // Prepare the output string
    var outputString = ""
    for (value1, value2, v3, v4) in sortedData {
        outputString += "\(value1) \(value2) \(v3) \(v4)\n"
    }
    
    // Get the Documents directory URL
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Unable to access Documents directory.")
        return
    }
    
    // Create the output file URL
    let outputFileName = "sorted.txt"
    let outputFilePath = documentsDirectory.appendingPathComponent(outputFileName)
    
    // Write the sorted data to the output file
    do {
        try outputString.write(to: outputFilePath, atomically: true, encoding: .utf8)
        print("Successfully wrote the sorted data to \(outputFilePath).")
    } catch {
        print("Failed to write the sorted data to \(outputFilePath): \(error)")
    }
    
    makeDataPoint(arr: data)
}

