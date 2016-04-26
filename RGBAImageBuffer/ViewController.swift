//
//  ViewController.swift
//  RGBAImageBuffer
//
//  Created by Dennis Lysenko on 4/26/16.
//  Copyright © 2016 Riff Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var rgbaBuffer: RGBAImageBuffer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "sample_photo")!
        self.imageView.image = image
        
        // Create the buffer: it's that easy.
        // NB: if your image is big, you will want to do this in the background.
        self.rgbaBuffer = RGBAImageBuffer(image: image.CGImage)
        
        // Make the image view color the background of our whole view when you move around on it to demonstrate that the RGBAImageBuffer works
        self.imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewController.extractColorFromImage(_:))))
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.extractColorFromImage(_:))))
        self.imageView.userInteractionEnabled = true
    }
    
    func extractColorFromImage(gesture: UIGestureRecognizer) {
        let location = gesture.locationInView(self.imageView)
        
        // rescale coordinates from the imageView's coordinate space to the raw image / rgba buffer's coordinate space
        let x = Int(location.x / self.imageView.bounds.width * CGFloat(self.rgbaBuffer.width))
        let y = Int(location.y / self.imageView.bounds.height * CGFloat(self.rgbaBuffer.height))
        
        if let color = self.rgbaBuffer[x, y] {
            self.view.backgroundColor = color
        }
    }
}

