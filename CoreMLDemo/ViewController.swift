//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Markus Mühlberger on 10/25/17.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var vggClassificationLabel : UILabel!
    @IBOutlet weak var squeezeClassificationLabel : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    
    lazy var vggModel : VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: VGG16().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] (request, error) in
                self?.displayClassification(for: request, error: error, label: self!.vggClassificationLabel)
            })
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError()
        }
    }()
    
    lazy var squeezeModel : VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: SqueezeNet().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] (request, error) in
                self?.displayClassification(for: request, error: error, label: self!.squeezeClassificationLabel)
            })
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateClassifications(for image: UIImage) {
        vggClassificationLabel.text = "Classifying..."
        squeezeClassificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { return }
        
        performClassification(for: ciImage, orientation: orientation, with: vggModel)
        performClassification(for: ciImage, orientation: orientation, with: squeezeModel)
    }
    
    func performClassification(for image: CIImage, orientation: CGImagePropertyOrientation, with request: VNCoreMLRequest) {
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: image, orientation: orientation)
            
            do {
                try handler.perform([request])
            } catch {
                
            }
        }
    }
    
    func displayClassification(for request: VNRequest, error: Error?, label: UILabel) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                label.text = "Couldn't classify"
                return
            }
            
            let classifications = (results as! [VNClassificationObservation]).prefix(2)
            
            if classifications.isEmpty {
                label.text = "Nothing found"
            } else {
                let descriptions = classifications.map { classification in
                    return String(format: "(%.2f) %@", classification.confidence, classification.identifier)
                }
                label.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }

    @IBAction func takePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        updateClassifications(for: image)
    }
}
