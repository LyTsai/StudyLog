//
//  FacialDetectiveTool.swift
//  Demo_testUI
//
//  Created by L on 2019/6/4.
//  Copyright © 2019 LyTsai. All rights reserved.
//

import Foundation
import Vision

class FacialDetectiveTool {
    typealias FacialDetectHandle = ((_ featureData: [(CGRect, VNFaceLandmarks2D)]) -> ())
    func detectFaceLandmarksInImage(_ image: UIImage, completion: @escaping FacialDetectHandle) {
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        // detect requst
        let requestHandle = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        let landmarksRequest = VNDetectFaceLandmarksRequest { (request, error) in
            guard let observations = request.results as? [VNFaceObservation] else {
                return
            }
            
            var featureData = [(CGRect, VNFaceLandmarks2D)]()
            for feature in observations {
                if let landmarks = feature.landmarks {
                    featureData.append((feature.boundingBox, landmarks))
                }
            }
            // callback
            completion(featureData)
        }
        
        // handle
        DispatchQueue.global().async {
            do {
                try requestHandle.perform([landmarksRequest])
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // get points on image
    func getConvertedPoints(_ landmarkRegion2D: VNFaceLandmarkRegion2D, boundingBox: CGRect, imageDisplayFrame: CGRect) -> [CGPoint] {
        var points = [CGPoint]()
        for point in landmarkRegion2D.normalizedPoints {
            let convertedX = (point.x * boundingBox.width + boundingBox.minX) * imageDisplayFrame.width + imageDisplayFrame.minX
            let convertedY = (1 - (point.y * boundingBox.height + boundingBox.minY)) * imageDisplayFrame.height + imageDisplayFrame.minY
            points.append(CGPoint(x: convertedX, y: convertedY))
        }
        
        return points
    }
    
    
    //        if let image = faceImageView.image {
    //            let detectiveTool = FacialDetectiveTool()
    //            detectiveTool.detectFaceLandmarksInImage(image) { (featureData) in
    //                DispatchQueue.main.async {
    //                    let path = UIBezierPath()
    //                    for (boundingBox, landmark) in featureData {
    //                        if let face = landmark.allPoints {
    //                            let points = detectiveTool.getConvertedPoints(face, boundingBox: boundingBox, imageDisplayFrame: self.faceImageView.frame)
    //                            path.move(to: points.first!)
    //                            for point in points {
    //                                path.addLine(to: point)
    //                            }
    //                        }
    //                    }
    //
    //                }
    //            }
    //        }
}
