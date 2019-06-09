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
//
            // callback
            completion(featureData)
        }
        
        DispatchQueue.global().async {
            do {
                try requestHandle.perform([landmarksRequest])
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getConvertedPoints(_ landmarkRegion2D: VNFaceLandmarkRegion2D, boundingBox: CGRect, imageFrame: CGRect) -> [CGPoint] {
        var points = [CGPoint]()
        for point in landmarkRegion2D.normalizedPoints {
            points.append(CGPoint(x: imageFrame.minX + point.x * imageFrame.width, y: imageFrame.height - point.y * imageFrame.height + imageFrame.minY))
        }
        
        return points
    }
}
