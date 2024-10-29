//
//  ContentView.swift
//  MNISTImageViewer
//
//  Created by Sebastian Juarez on 10/28/24.
//

import SwiftUI
import CoreGraphics

struct PixelImage: View {
    let pixels: [Int]
    let size: Int = 28

    var body: some View {
        VStack {
            if let cgImage = createCGImage(from: pixels) {
                Image(decorative: cgImage, scale: 1.0)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()
            } else {
                Text("Failed to create image.")
            }
        }
    }
    
    func createCGImage(from pixels: [Int]) -> CGImage? {
        let width = size
        let height = size
        
        guard pixels.count == width * height else {
            return nil
        }
        
        let data = pixels.map { UInt8($0) }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: UnsafeMutableRawPointer(mutating: data),
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        return context?.makeImage()
    }
}

struct ContentView: View {
    private var data: [[Int]] = readCSV(filename: "sign_mnist_train") ?? []

    var body: some View {
        VStack {
            // Hardcode the index of the image you want to display
            let currentIndex = 3 // Change this value to display a different image
            
            // Check if the index is valid
            if !data.isEmpty && currentIndex < data.count {
                // Get the pixel values of the current image, excluding the label
                let imagePixels = Array(data[currentIndex][1...])
                
                // Display the image
                PixelImage(pixels: imagePixels)
                    .padding()
                
                // Display the label if desired
                Text("Label: \(data[currentIndex][0])")
                    .font(.headline)
                    .padding()
            } else {
                Text("Error: No valid image data found.")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

