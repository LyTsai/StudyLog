//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image =  UIImage(named: "faceTest")!
        let imageView = UIImageView(frame: view.bounds.insetBy(dx: 20, dy: 100))
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        let imageFrame = CGRect(center: CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY), width: imageView.frame.width, height: imageView.frame.width / (image.size.width / image.size.height))
        
        let detectiveTool = FacialDetectiveTool()
        detectiveTool.detectFaceLandmarksInImage(image) { (featureData) in
            DispatchQueue.main.async {
                let path = UIBezierPath()
                for (boundingBox, landmark) in featureData {
                    if let face = landmark.allPoints {
                        let points = detectiveTool.getConvertedPoints( face, boundingBox: boundingBox, imageDisplayFrame: imageFrame)
                        
                        path.move(to: points.first!)
                        for point in points {
                            path.addLine(to: point)
                        }
                    }
                }
                
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.strokeColor = UIColor.red.cgColor
                shape.fillColor = UIColor.clear.cgColor
                imageView.layer.addSublayer(shape)
            }
        }
    }
    
    func detectFacesOnImage(_ image: UIImage?) -> [CIFaceFeature] {
        guard image != nil, let cIImage = CIImage(image: image!) else {
            print("Wrong image type")
            return []
        }

        // detect
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyLow])
        let faces = faceDetector?.features(in: cIImage) as? [CIFaceFeature]
        return faces ?? []
    }
    
    func detectFacesOnImageView(_ imageView: UIImageView) -> [CGRect] {
        guard imageView.image != nil, let cIImage = CIImage(image: imageView.image!) else {
            print("Wrong image type")
            return []
        }
        
        // detect
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyLow])
        let faces = faceDetector?.features(in: cIImage) as? [CIFaceFeature]
        if faces == nil || faces!.isEmpty {
            return []
        }
        
        // get real frame
        let ciToUITransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // convert
        let imageSize = imageView.image!.size
        let imageViewSize = imageView.bounds.size
        
        let scale = min(imageViewSize.width / imageSize.width, imageViewSize.height / imageSize.height)
        let offsetX = (imageViewSize.width - imageSize.width * scale) * 0.5
        let offsetY = (imageViewSize.height - imageSize.height * scale) * 0.5
        let aspectFitTransform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: offsetX, y: offsetY)
        
        var faceFrames = [CGRect]()
        for face in faces! {
            var faceBounds = face.bounds.applying(ciToUITransform)
            faceBounds = faceBounds.applying(aspectFitTransform)
            faceFrames.append(faceBounds)
        }
        
        return faceFrames
       
    }
    
    func covertFrame(_ frame: CGRect, fromSuper: CGRect) {
        
    }
    
    
    @IBAction func actionForButton(_ sender: Any) {
//        let vc = AbookHintViewController()
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.focusOnFrame(CGRect(x: 40, y: 160, width: 100, height: 200), hintText: "this is a test string") 
//        present(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}

// methods tested
extension ViewController {
    //        getCSVDataFromFile("时间安排+清单+当天工作安排")
    func getCSVDataFromFile(_ fileName: String?) {
        if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "csv") {
            do {
                let dataString = try String(contentsOf: fileUrl, encoding: .utf8)
                let lineBreakArray = dataString.components(separatedBy: "\r") // by return
                var eachDetail = [[String]]()
                for line in lineBreakArray {
                    let oneData = line.components(separatedBy: ",")
                    eachDetail.append(oneData)
                    print(oneData)
                }
                
                //            openTimArr.removeFirst()
                //            for i in openTimArr{
                //                let openDict = ["lotterycode":i[0],"issue_no":i[1],"single_letter":i[2],"open_time":i[3]]
                //                //插入数据库
                //                dataBase.insert(tableName: "tc_lottery_open_time", dataDic: openDict as NSDictionary)
                //            }
                //        }catch let error as NSError {
                //            QL1(error)
                //        }
            }catch {
                print("error")
            }
        }else {
            print("file not exist in bundle")
        }
    }

}
