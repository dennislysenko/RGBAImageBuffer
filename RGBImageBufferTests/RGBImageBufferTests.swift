//
//  RGBImageBufferTests.swift
//  RGBImageBufferTests
//
//  Created by Dennis Lysenko on 4/26/16.
//  Copyright © 2016 Riff Digital. All rights reserved.
//

import XCTest
@testable import RGBImageBuffer

class RGBImageBufferTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let image = UIImage(named: "hunger")!
        let buffer = RGBImageBuffer(image: image)
        
        for x in 0..<buffer.width {
            for y in 0..<buffer.height {
                let rgba = buffer.rgbaAt(x, y)
                XCTAssertNotNil(rgba)
                let (r, g, b, a) = rgba!
                XCTAssertEqual(1, a)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
