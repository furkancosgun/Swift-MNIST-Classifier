//
//  ViewController.swift
//  iOS-CoreML-MNIST
//
//  Created by Furkan on 22/09/22.
//  Copyright © 2022 Furkan COSGUN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var predictLabel: UILabel!
    
    
    let model = MNISTClassifier()
    let context = CIContext()
    var pixelBuffer: CVPixelBuffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictLabel.isHidden = true
        
     
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            28,
                            28,
                            kCVPixelFormatType_OneComponent8,
                            attrs,
                            &pixelBuffer)
    }

    @IBAction func tappedClear(_ sender: Any) {
        drawView.lines = []
        drawView.setNeedsDisplay()
        predictLabel.isHidden = true
    }
    
    @IBAction func tappedDetect(_ sender: Any) {
       
        if drawView.lines.count <= 0 {
            
            return
        }
        
        let viewContext = drawView.getViewContext()
        let cgImage = viewContext?.makeImage()
        let ciImage = CIImage(cgImage: cgImage!)
        context.render(ciImage, to: pixelBuffer!)
        let output = try? model.prediction(image: pixelBuffer!)
        predictLabel.text = output?.classLabel.description
        predictLabel.isHidden = false
    }
}


