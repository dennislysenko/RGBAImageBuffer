//
//  ViewController.swift
//  RGBImageBuffer
//
//  Created by Dennis Lysenko on 4/26/16.
//  Copyright © 2016 Riff Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    let image = UIImage(named: "sample_photo")!
    var rgbBuffer: RGBImageBuffer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rgbBuffer = RGBImageBuffer(image: self.image)
        self.imageView.image = self.image
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapImage(_:))))
        self.imageView.userInteractionEnabled = true
    }
    
    func didTapImage(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(self.imageView)
        let x = Int(location.x / self.imageView.bounds.width * self.image.size.width * self.image.scale)
        let y = Int(location.y / self.imageView.bounds.height * self.image.size.height * self.image.scale)
        
        let color = self.rgbBuffer[x, y]!
        self.view.backgroundColor = color
    }
}

