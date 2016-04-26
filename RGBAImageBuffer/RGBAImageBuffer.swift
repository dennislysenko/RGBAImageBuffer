//
//  RGBAImageBuffer.swift
//  RGBAImageBuffer
//
//  Created by Dennis Lysenko on 4/26/16.
//  Copyright © 2016 Riff Digital. All rights reserved.
//

import UIKit

public class RGBAImageBuffer {
    static let bitsPerPixel = 32
    static let bitsPerComponent = 8
    private let bytesPerRow: Int
    
    /// Raw buffer for RGB data. Publicly readable in case you need to do advanced/component-level operations with it. You can convert an (x, y) coordinate to an index in this array using `rawIndexForPixelAt(x:y:)`.
    public private(set) var rgbData: [UInt8]
    
    /// The width of the underlying raw image. If the buffer was created from a retina/scaled `UIImage`, this will differ from the original `UIImage`'s `size.width`.
    public let width: Int
    
    /// The height of the underlying raw image. If the buffer was created from a retina/scaled `UIImage`, this will differ from the original `UIImage`'s `size.height`.
    public let height: Int
    
    /// Reads a CGImage into an RGB image buffer.
    ///
    /// - Returns: A buffer if raw RGBA data was loaded successfully, **or nil if**: the `CGImage` was nil, it could not create a device RGB color space, it could not allocate enough memory to store the bitmap data buffer, it could not create a bitmap context over that data buffer in order to fill it with data, or it could not get the bitmap data after rendering it to the known memory buffer.
    init?(image: CGImage?) {
        // Not throwing NSErrors because we're still not fully clear on the future role of NSError in error handling in Swift. Simply a failable initializer for now.
        guard let image = image else {
            print("CGImage was nil")
            return nil
        }
        
        self.width = CGImageGetWidth(image)
        self.height = CGImageGetHeight(image)
        
        let bytesPerPixel = RGBAImageBuffer.bitsPerPixel / RGBAImageBuffer.bitsPerComponent
        
        self.bytesPerRow = self.width * bytesPerPixel
        
        let bufferLength = self.bytesPerRow * self.height
        
        guard let colorSpace = CGColorSpaceCreateDeviceRGB() else {
            print("Could not create device RGB color space")
            return nil
        }
        
        let bitmapDataInputBuffer = malloc(bufferLength)
        
        if bitmapDataInputBuffer == nil {
            print("Could not allocate bitmap data buffer")
            return nil
        }
        
        guard let context = CGBitmapContextCreate(bitmapDataInputBuffer, width, height, RGBAImageBuffer.bitsPerComponent, self.bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue) else {
            print("Could not create bitmap context for buffer")
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        CGContextDrawImage(context, rect, image)
        
        let bitmapData = UnsafeMutablePointer<UInt8>(CGBitmapContextGetData(context))
        guard bitmapData != nil else {
            print("Could not get bitmap data from graphics context")
            return nil
        }
        
        var rgbData = [UInt8]()
        for i in 0..<bufferLength {
            let value = bitmapData.advancedBy(i).memory
            rgbData.append(value)
        }
        
        free(bitmapData)
        
        self.rgbData = rgbData
    }
    
    /// Reads a UIImage into an RGB image buffer.
    ///
    /// - Returns: A buffer if all operations completed successfully, **or nil if**: the `CGImage` was nil, it could not create a device RGB color space, it could not allocate enough memory to store the bitmap data buffer, it could not create a bitmap context over that data buffer in order to fill it with data, or it could not get the bitmap data after rendering it to the known memory buffer.
    convenience init?(UIImage image: UIImage) {
        self.init(image: image.CGImage)
    }
    
    func rawIndexForPixelAt(x x: Int, y: Int) -> Int {
        return y * self.bytesPerRow + x * 4
    }
    
    func colorAt(x x: Int, y: Int) -> UIColor? {
        let pixelIndex = rawIndexForPixelAt(x: x, y: y)
        
        guard pixelIndex >= 0 else {
            return nil
        }
        
        guard pixelIndex + 3 < rgbData.count else {
            return nil
        }
        
        let r = CGFloat(self.rgbData[pixelIndex + 0]) / 255
        let g = CGFloat(self.rgbData[pixelIndex + 1]) / 255
        let b = CGFloat(self.rgbData[pixelIndex + 2]) / 255
        let a = CGFloat(self.rgbData[pixelIndex + 3]) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    subscript(x: Int, y: Int) -> UIColor? {
        return self.colorAt(x: x, y: y)
    }
}