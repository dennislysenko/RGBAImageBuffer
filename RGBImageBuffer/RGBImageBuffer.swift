//
//  RGBImageBuffer.swift
//  RGBImageBuffer
//
//  Created by Dennis Lysenko on 4/26/16.
//  Copyright © 2016 Riff Digital. All rights reserved.
//

import UIKit

class RGBImageBuffer {
    let image: UIImage
    let buffer: [UInt8]
    let bytesPerRow: Int
    let width: Int
    let height: Int
    
    init(image: UIImage) {
        self.image = image
        
        guard let cgImage = self.image.CGImage else {
            preconditionFailure("passed image had no CGImageRef")
        }
        
        self.width = CGImageGetWidth(cgImage)
        self.height = CGImageGetHeight(cgImage)
        
        let bitsPerPixel = 32
        let bitsPerComponent = 8
        let bytesPerPixel = bitsPerPixel / bitsPerComponent
        
        self.bytesPerRow = width * bytesPerPixel
        let bufferLength = bytesPerRow * height
        
        guard let colorSpace = CGColorSpaceCreateDeviceRGB() else {
            fatalError("Could not create device RGB color space")
        }
        
        let bitmapDataInputBuffer = malloc(bufferLength)
        
        if bitmapDataInputBuffer == nil {
            fatalError("Could not allocate bitmap data buffer")
        }
        
        guard let context = CGBitmapContextCreate(bitmapDataInputBuffer, width, height, bitsPerComponent, self.bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue) else {
            fatalError("Could not create bitmap context for buffer")
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        CGContextDrawImage(context, rect, cgImage)
        
        let bitmapData = UnsafeMutablePointer<UInt8>(CGBitmapContextGetData(context))
        guard bitmapData != nil else {
            fatalError("Could not get bitmap data from graphics context")
        }
        
        var buffer = [UInt8]()
        for i in 0..<bufferLength {
            let value = bitmapData.advancedBy(i).memory
            buffer.append(value)
        }
        
        free(bitmapData)
        
        self.buffer = buffer
    }
    
    func rgbaAt(x: Int, _ y: Int) -> (CGFloat, CGFloat, CGFloat, CGFloat)? {
        let pixelIndex = y * self.bytesPerRow + x * 4
        
        guard pixelIndex >= 0 else {
            return nil
        }
        
        guard pixelIndex + 3 < buffer.count else {
            return nil
        }
        
        let r = CGFloat(self.buffer[pixelIndex + 0]) / 255
        let g = CGFloat(self.buffer[pixelIndex + 1]) / 255
        let b = CGFloat(self.buffer[pixelIndex + 2]) / 255
        let a = CGFloat(self.buffer[pixelIndex + 3]) / 255
        
        return (r, g, b, a)
    }
    
    subscript(x: Int, y: Int) -> UIColor? {
        guard let (r, g, b, a) = self.rgbaAt(x, y) else {
            return nil
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}