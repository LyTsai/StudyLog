//
//  FacialDetectiveTool.swift
//  Demo_testUI
//
//  Created by L on 2019/6/4.
//  Copyright © 2019 LyTsai. All rights reserved.
//

/*
 CoreImage
 自从 iOS 5（大概在2011年左右）之后，iOS 开始支持人脸识别，只是用的人不多。人脸识别 API 让开发者不仅可以进行人脸检测，还能识别微笑、眨眼等表情。

 Vision
 Vision 是 Apple 在 WWDC 2017 推出的图像识别框架，它基于 Core ML，所以可以理解成 Apple 的工程师设计了一种算法模型，然后利用 Core ML 训练，最后整合成一个新的框架。
 https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml
 Ex: https://www.raywenderlich.com/1163620-face-detection-tutorial-using-the-vision-framework-for-ios
 OpenCV
 OpenCV 起始于 1999 年 Intel 的一个内部研究项目。从那时起，它的开发就一直很活跃。进化到现在，它已支持如 OpenCL 和 OpenGL 等现代技术，也支持如 iOS 和 Android 等平台。
 ex: https://blog.csdn.net/minstyrain/article/details/97531797
 https://blog.csdn.net/minstyrain/article/details/97612637

 AVFoundation
 AVFoundation照片和视频捕捉功能是从框架搭建之初就是它的强项。 从iOS 4.0 我们就可以直接访问iOS的摄像头和摄像头生成的数据（照片、视频）。
 https://www.jianshu.com/p/61ca3a917fe5

 */

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
