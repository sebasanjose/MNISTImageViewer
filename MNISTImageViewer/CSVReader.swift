//
//  CSVReader.swift
//  MNISTImageViewer
//
//  Created by Sebastian Juarez on 10/28/24.
//


import Foundation

func readCSV(filename: String) -> [[Int]]? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "csv") else {
        print("Error: File not found")
        return nil
    }
    print("File found at: \(url)")

    do {
        let data = try String(contentsOf: url)
        print("Successfully read file contents")
        
        // Handling line endings
        let rows = data.components(separatedBy: .newlines).filter { !$0.isEmpty }

        return rows.compactMap { row in
            // Correct splitting by commas
            let columns = row.split(separator: ",").compactMap { Int($0) }
            
            // Ensure that row has 785 values (1 label + 784 pixels)
            if columns.count == 785 {
                return columns
            } else {
                print("Skipped a row due to incorrect number of columns")
                return nil
            }
        }
    } catch {
        print("Error reading CSV file: \(error)")
        return nil
    }
}


