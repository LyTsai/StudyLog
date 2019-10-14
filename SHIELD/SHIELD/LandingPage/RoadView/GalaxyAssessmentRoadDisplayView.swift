//
//  GalaxyAssessmentRoadDisplayView.swift
//  AnnielyticX
//
//  Created by Lydire on 2019/5/11.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class GalaxyAssessmentRoadDisplayView: UIView {
    fileprivate let topLabel = StrokeLabel()
    fileprivate let subLabel = UILabel()
    fileprivate var roadView: GroupsRoadCollectionView!
    class func createWithFrame(_ frame: CGRect, appTopic: AppTopic) -> GalaxyAssessmentRoadDisplayView {
        let display = GalaxyAssessmentRoadDisplayView(frame: frame)
        
        if let applicationClassKey = appTopic.getTopicKey() {
            var title = ""
            var prompt = ""
            switch appTopic {
            case .AssessmentAppsBySubjectAreas:
                title = "Individualized Assessment"
                prompt = "Assessment Apps by Subject Areas"
            case .VisualizerAppsBySubjectAreas:
                title = "Visualizer"
                prompt = "Visualizer Apps by Subject Areas"
            default: break
            }
            display.loadAsLandingWithFrame(frame, title: title, prompt: prompt, groups: LandingModel.loadDataForApplicationClassKey(applicationClassKey))
        }
        
        return display
    }
    
    
    fileprivate func loadAsLandingWithFrame(_ frame: CGRect, title: String, prompt: String, groups: [(MetricGroupObjModel,[MetricObjModel])]) {
        self.frame = frame
        self.backgroundColor = UIColor.clear
        
        // top
        topLabel.strokeColor = UIColor.white
        topLabel.frontColor = UIColorFromHex(0x173890)
        topLabel.text = title
        topLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .bold)
        
        // title
        subLabel.text = prompt
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 0
        subLabel.textColor = UIColorFromHex(0xCAEFFF)
        subLabel.font = UIFont.systemFont(ofSize: 20 * fontFactor, weight: .semibold)
        
        // frames
        topLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 24 * fontFactor)
        subLabel.frame = CGRect(x: 15 * fontFactor, y: topLabel.frame.maxY, width: bounds.width - 30 * fontFactor, height: 55 * fontFactor)
        
        addSubview(topLabel)
        addSubview(subLabel)
        
        // road
        roadView = GroupsRoadCollectionView.createWithFrame(CGRect(x: 0, y: subLabel.frame.maxY, width: bounds.width, height: bounds.height - subLabel.frame.maxY), data: groups)
        addSubview(roadView)
    }
    
}

// Model
extension LandingModel {
    class func loadDataForApplicationClassKey(_ applicationClassKey: String) -> [(MetricGroupObjModel, [MetricObjModel])] {
        var landing = [(MetricGroupObjModel, [MetricObjModel])]()
        let allGroups = collection.getMetricGroupsForApplicationClassKey(applicationClassKey)
        for group in allGroups {
            var metrics = [MetricObjModel]()
            for metricKey in group.metricKeys {
                if let metric = collection.getMetric(metricKey) {
                    metrics.append(metric)
                }
            }
            
            metrics.sort(by:{$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
            landing.append((group, metrics))
        }
        
        return landing
    }
}
