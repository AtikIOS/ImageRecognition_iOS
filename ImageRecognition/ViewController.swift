//
//  ViewController.swift
//  ImageRecognition
//
//  Created by Atik Hasan on 2/23/25.
//
import UIKit
import Vision
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        guard let image = UIImage(named: "cartoon") else{
            print("img not found")
            return
        }
        self.imageView.image = image
        classifyImage(image: image)
    }
    
        // use CoreML ও Vision (Default) for detect image recognition
    func classifyImage(image: UIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            print("There was a problem loading the model!")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                self.resultLabel.text = "Nothing found"
                return
            }
            
            
            DispatchQueue.main.async {
                var resultText = ""
                for result in results.prefix(5) { // Showing top 5 results
                    let percentage = Int(result.confidence * 100)
                    resultText += "\(result.identifier): \(percentage)%\n"
                    print(resultText)
                }
                self.resultLabel.text = resultText.isEmpty ? "Nothing found" : resultText
            }
        }
        
        guard let ciImage = CIImage(image: image) else { return }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("There was a problem while processing the image.: \(error.localizedDescription)")
        }
    }

}
