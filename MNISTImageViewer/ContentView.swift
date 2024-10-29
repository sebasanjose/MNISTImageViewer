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
    var body: some View {
        if let data = readCSV(filename: "sign_mnist_train") {
            if let firstImagePixels = data.first?[1...] {
                PixelImage(pixels: Array(firstImagePixels))
                    .padding()
            } else {
                Text("Error: No valid image data found.")
                    .padding()
            }
        } else {
            Text("Error: Failed to load CSV data.")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

