//
//  ActToChangeCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by Lydire on 17/1/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let greenColor = UIColorFromRGB(0, green: 200, blue: 83)


// MARK: --------- metric collection view cell (Panel and metric)
let panelInfoCellID = "Panel Info Cell ID"
class PanelInfoCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
         }
    }
    
    var text: String! {
        didSet {
            if text != oldValue { textLabel.text = text }
        }
    }
    
    var selectedKeys = [String]()
    
    fileprivate var imageView = UIImageView()
    fileprivate var textLabel = UILabel()
    fileprivate var panelView: PanelView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate var fanShape = CAShapeLayer()
    fileprivate func updateUI() {
        backgroundColor = UIColor.white
        
        let selectedBackgroundView = UIView(frame: CGRect.zero)
        selectedBackgroundView.backgroundColor = greenColor.withAlphaComponent(0.1)
        self.selectedBackgroundView = selectedBackgroundView
        
        // panel: risks
        panelView = PanelView.creatPanelWithFrame(CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.6))
        
        // metric image and name
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
    
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        addSubview(panelView)
        addSubview(imageView)
        addSubview(textLabel)
        
        // fanShape
        fanShape.strokeColor = greenColor.cgColor
        fanShape.fillColor = UIColor.clear.cgColor
        layer.addSublayer(fanShape)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let XGap = 0.02 * bounds.width
        let YGap = 0.02 * bounds.height
        
        let radius = min(bounds.width / 2 - XGap, bounds.height * 0.6)
    
        panelView.frame = CGRect(x: bounds.midX - radius, y: YGap, width: radius * 2, height: radius)

        let imageCenter = CGPoint(x: bounds.midX, y: radius + YGap)
        imageView.frame = CGRect(center: imageCenter, length: radius * 0.5)
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.layer.borderWidth = min(XGap, YGap)
        imageView.layer.masksToBounds = true
        
        let textY = imageView.frame.maxY + YGap
        textLabel.frame = CGRect(x: 0, y: textY, width: bounds.width, height: bounds.height - textY)
        textLabel.font = UIFont.systemFont(ofSize: textLabel.bounds.height / 2.28)

        let path = UIBezierPath(arcCenter: imageCenter, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        path.addLine(to: CGPoint(x: imageView.frame.minX ,y: imageView.frame.midY))
        let innerArc = UIBezierPath(arcCenter: imageCenter, radius: imageView.frame.width / 2, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        path.append(innerArc)
        path.addLine(to: CGPoint(x: panelView.frame.maxX ,y: imageView.frame.midY))

        fanShape.path = path.cgPath
        fanShape.lineWidth = min(XGap, YGap)
        
        panelView.contentOffset.x = frame.width * 0.15
    }
}

// MARK: --------- metric collection view ---------------
class MetricInfoCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var metrics = [MetricObjModel]()
    fileprivate var selectedMetric: MetricObjModel!
    var scrollDirection = UICollectionViewScrollDirection.horizontal
    
    class func createCollectionViewWithFrame(_ frame: CGRect, autoCellSize: Bool, scrollDirection: UICollectionViewScrollDirection) -> MetricInfoCollectionView {
        // layout
        let maxNumber: CGFloat = 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        
        let gap = 0.01 * frame.width
        flowLayout.minimumInteritemSpacing = 0

        flowLayout.minimumLineSpacing = gap
        let itemWidth = (frame.width - gap * 4) / maxNumber
        
        if autoCellSize {
            let whRatio: CGFloat = 1.2
            flowLayout.itemSize = CGSize(width: itemWidth , height: min(itemWidth / whRatio, frame.height))
        }else {
            flowLayout.itemSize = CGSize(width: itemWidth , height: frame.height - 8)
        }
        
//        
//        if scrollDirection == .vertical {
//            flowLayout.minimumLineSpacing = gap
//            let itemWidth = (frame.width - gap * 4) / maxNumber
//            flowLayout.itemSize = CGSize(width: itemWidth , height: itemWidth / whRatio)
//        } else {
//            let sizeWidth = frame.height * whRatio
//            let lineGap = (frame.width - maxNumber * sizeWidth) / (maxNumber + 1)
//            if lineGap < 0 {
//                print("need adjust")
//            }
//            gap = lineGap
//            flowLayout.minimumLineSpacing = lineGap
//            flowLayout.itemSize = CGSize(width: sizeWidth, height: frame.height)
//        }

        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: gap, bottom: 0, right: gap)
        // create
        let collection = MetricInfoCollectionView(frame: frame, collectionViewLayout: flowLayout)
        let metricKeys = AIDMetricCardsCollection.standardCollection.getMetrics()
        for key in metricKeys {
            collection.metrics.append(AIDMetricCardsCollection.standardCollection.getMetric(key)!)
        }

        collection.register(PanelInfoCell.self, forCellWithReuseIdentifier: panelInfoCellID)
        collection.dataSource = collection
        collection.delegate = collection
        
        // UI
        collection.backgroundColor = UIColor.white
        collection.scrollDirection = scrollDirection
        
        return collection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metrics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: panelInfoCellID, for: indexPath) as! PanelInfoCell
        // set up cell
        let metric = metrics[indexPath.item]
        
        let risks = AIDMetricCardsCollection.standardCollection.getMetricRelatedRiskModels(metric.key!)
        var usedKeys = [String]()
        if risks != nil{
            for risk in risks! {
                usedKeys.append(risk.metricKey!)
            }
        }
  
        cell.image = metric.imageObj
        cell.text = metric.name
        cell.panelView.usedKeys = usedKeys
        cell.isSelected = false
        
        let oddGray = UIColorFromRGB(248, green: 248, blue: 248)
        let evenGray = UIColorFromRGB(240, green: 241, blue: 243)
        cell.backgroundColor = (indexPath.item % 2 == 0 ? evenGray : oddGray)
        
        if selectedMetric != nil && selectedMetric == metric {
            cell.isSelected = true
        }
  
        return cell
    }
    
    // selected metric
    func scrollCollectionToMetric(_ metricKey: String!) {
        var index: Int!
        var oldIndex: Int!
        
        if metricKey == nil {
            return
        }
        
        if selectedMetric != nil {
            for (i, metric) in metrics.enumerated() {
                if metric.key == selectedMetric.key {
                    oldIndex = i
                    break
                }
            }
        }
        
        for (i, metric) in metrics.enumerated() {
            if metric.key == metricKey {
                index = i
                selectedMetric = metric
                break
            }
        }
        
        if index == nil {
            print("wrong, no such metric")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        performBatchUpdates({
            let targetState: UICollectionViewScrollPosition = (self.scrollDirection == .vertical ? .centeredVertically : .centeredHorizontally)
            self.scrollToItem(at: indexPath, at: targetState, animated: true)
            self.reloadItems(at: [indexPath])
            if oldIndex != nil && oldIndex != index {
                let oldIndexPath = IndexPath(item: oldIndex, section: 0)
                self.reloadItems(at: [oldIndexPath])
            }
        }, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let metric = metrics[indexPath.item]
        scrollCollectionToMetric(metric.key)
    }
}
