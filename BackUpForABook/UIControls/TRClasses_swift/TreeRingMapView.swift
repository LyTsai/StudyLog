//
//  TreeRingMapView.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TreeRingMapView: UIView {
    var treeRingMap: TRMap?
    var dataTableSource: TRDataTableFactory?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        treeRingMap = TRMap(frame: frame)
        dataTableSource = TRDataTableFactory()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // return the rect of one letter with given font size
    func fontPointSize(_ fontSize: CGFloat) -> CGRect{
        let lbFont = CTFontCreateWithName("Helvetica" as CFString?, fontSize, nil)
        let attString = NSAttributedString(string: "a", attributes: [NSFontAttributeName : lbFont])
        let txtSize = attString.boundingRect(with: CGSize.init(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
        return txtSize
    }
    
    // load two data table
    func testForShow(_ dataTableA: TRMetricDataTable, dataTableB: TRMetricDataTable) {
        if treeRingMap == nil {return}
        let pointSize = fontPointSize(1.0)
        treeRingMap?.fontSize = Float(pointSize.size.height)
        
        // 1.two slices tree ring map
        addTwoSlices(0.0, mid: 60.0, end: 180.0)
        
        // 2.set slice styles
        treeRingMap?.allSlices?[0].setStyle(SliceViewStyle.style_1)
        treeRingMap?.allSlices?[0].pointsPerFontSize = Float(pointSize.size.height)
        treeRingMap?.allSlices?[0].rightBorderStyle = .metal
        treeRingMap?.allSlices?[0].angleAxis?.fishyEye = false
        treeRingMap?.allSlices?[0].ringAxis?.fishyEye = false
        treeRingMap?.allSlices?[0].angleAxis?.title?.setStringAttributes("Helvetica-Bold", size: 14.0, foregroundColor: UIColor.init(red: 0, green: 0, blue: 1.0, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4), strokeWidth: -3.0)
        treeRingMap?.allSlices?[0].grid?.evenRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        treeRingMap?.allSlices?[0].grid?.oddRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        treeRingMap?.allSlices?[0].grid?.rowFocus = 5
        
        treeRingMap?.allSlices?[1].setStyle(SliceViewStyle.style_1)
        treeRingMap?.allSlices?[1].pointsPerFontSize = Float(pointSize.size.height)
        treeRingMap?.allSlices?[1].rightBorderStyle = .metal
        treeRingMap?.allSlices?[1].angleAxis?.fishyEye = false
        treeRingMap?.allSlices?[1].ringAxis?.fishyEye = false
        treeRingMap?.allSlices?[1].angleAxis?.title?.setStringAttributes("Helvetica-Bold", size: 14.0, foregroundColor: UIColor.init(red: 0, green: 0, blue: 1.0, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4), strokeWidth: -3.0)
        treeRingMap?.allSlices?[1].grid?.evenRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        treeRingMap?.allSlices?[1].grid?.oddRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        treeRingMap?.allSlices?[1].grid?.rowFocus = 5
        treeRingMap?.allSlices?[1].grid?.columnFocus = 3
        
        // set tree ring map inital size
        setTmapSize(treeRingMap!, frame: self.bounds)
        
        // load test data into two slices
        loadDataTableIntoSlice(dataTableA, slice: treeRingMap!.allSlices![1])
        loadDataTableIntoSlice(dataTableB, slice: treeRingMap!.allSlices![0])
        
        treeRingMap?.onDirtyView()
        
        self.addSubview(treeRingMap!)
        
    }
    
    // load one table
    func loadOneTableOnly(_ dataTable: TRMetricDataTable){
        if treeRingMap == nil {return}
        let pointSize = fontPointSize(1.0)
        
        // font size
        treeRingMap?.fontSize = Float(pointSize.size.height)
        
        // 1. one slice tree ring map
        addOneSlice(0.0, end: 180)
        
        // 2. set slice style
        treeRingMap?.allSlices?[0].setStyle(.style_1)
        treeRingMap?.allSlices?[0].pointsPerFontSize = Float(pointSize.size.height)
        treeRingMap?.allSlices?[0].rowLabelOnLeft = false
        treeRingMap?.allSlices?[0].leftBorderStyle = .metal
        treeRingMap?.allSlices?[0].rightBorderStyle = .metal
        treeRingMap?.allSlices?[0].angleAxis?.fishyEye = false
        treeRingMap?.allSlices?[0].ringAxis?.fishyEye = false
        treeRingMap?.allSlices?[0].angleAxis?.title?.setStringAttributes("Helvetic-Bold", size: 14.0, foregroundColor: UIColor.init(red: 0, green: 0, blue: 1, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4), strokeWidth: -3.0)
        treeRingMap?.allSlices?[0].grid?.evenRowBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        treeRingMap?.allSlices?[0].grid?.oddRowBackgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        treeRingMap?.allSlices?[0].grid?.rowFocus = 5
        
        // 3. set tree ring map inital size
        setSize(bounds)
        
        // 4. load table data
        loadDataTableIntoSlice(dataTable, slice: treeRingMap!.allSlices![0])
        
        // set center label info
        setCenterLabel(treeRingMap!)
        
        // set labels
        setLT_Labels(treeRingMap!)
        
        // set date label
        setDateLabel(treeRingMap!)
        
        // 5. make sure to call for view update
        treeRingMap?.onDirtyView()
        
        addSubview(treeRingMap!)
    }
    
    
    // load many tables into tree ring map
    func loadTables(_ dataTables: [TRMetricDataTable]) {
        if treeRingMap == nil {return}
        let pointSize = fontPointSize(1.0)
        
        // font size
        treeRingMap?.fontSize = Float(pointSize.size.height)
        
        // 1. one slice tree ring map
        let angle: Float = Float(180.0) / Float(dataTables.count)
        var points = [Float]()
        for i in 0..<dataTables.count {
            points.append(Float(i) * angle)
        }
        addManySlices(points)
        
        // 2. set slice style
        for i in 0..<treeRingMap!.allSlices!.count{
            treeRingMap?.allSlices?[i].setStyle(.style_1)
            treeRingMap?.allSlices?[i].pointsPerFontSize = Float(pointSize.size.height)
            treeRingMap?.allSlices?[i].rowLabelOnLeft = false
            if i == 0 {
                treeRingMap?.allSlices?[i].rightBorderStyle = .metal
            }
            if i == treeRingMap!.allSlices!.count - 1{
                treeRingMap?.allSlices?[i].leftBorderStyle = .metal
            }
            treeRingMap?.allSlices?[i].angleAxis?.fishyEye = false
            treeRingMap?.allSlices?[i].ringAxis?.fishyEye = false
            treeRingMap?.allSlices?[i].angleAxis?.title?.setStringAttributes("Helvetic-Bold", size: 14.0, foregroundColor: UIColor.init(red: 0, green: 0, blue: 1, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4), strokeWidth: -3.0)
            treeRingMap?.allSlices?[i].grid?.evenRowBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1.0)
            treeRingMap?.allSlices?[i].grid?.oddRowBackgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            treeRingMap?.allSlices?[i].grid?.rowFocus = 5
        }
        
        // 3. set tree ring map inital size
        setSize(bounds)
        
        // 4. load table data
        for i in 0..<dataTables.count {
            loadDataTableIntoSlice(dataTables[i], slice: treeRingMap!.allSlices![i])
        }

        // set center label info
        setCenterLabel(treeRingMap!)
        
        // set labels
        setLT_Labels(treeRingMap!)
        
        // set date label
        setDateLabel(treeRingMap!)
        
        // 5. make sure to call for view update
        treeRingMap?.onDirtyView()
        
        addSubview(treeRingMap!)
    }
    
    // add one slice for treeRingMap
    func addOneSlice(_ begin: Float, end: Float){
        if treeRingMap == nil {return}
        
        // create two ring slices:
        var slicePositions = [NSNumber]()
        
        // degree ranges for two slices: 0 - 180
        slicePositions.append(NSNumber.init(value: begin))
        slicePositions.append(NSNumber.init(value: end))
        
        // compose tree ring map with specified ring slices
        treeRingMap?.composeTreeRingMap(slicePositions)
    }
    
    // add two slice for treeRingMap
    func addTwoSlices(_ begin: Float, mid: Float, end: Float){
        if treeRingMap == nil {return}
        
        var slicePositions = [NSNumber]()
        slicePositions.append(NSNumber.init(value: begin))
        slicePositions.append(NSNumber.init(value: mid))
        slicePositions.append(NSNumber.init(value: end))
        
        treeRingMap?.composeTreeRingMap(slicePositions)
    }
    
    // add many slice for treeRingMap
    func addManySlices(_ points: [Float]) {
        if treeRingMap == nil {return}
        
        var slicePositions = [NSNumber]()
        for point in points {
            slicePositions.append(NSNumber.init(value: point))
        }
        treeRingMap?.composeTreeRingMap(slicePositions)
    }
    
    func setSize(_ frame: CGRect){
        setTmapSize(treeRingMap!, frame: frame)
    }
    
    func setTmapSize(_ treeRingMap: TRMap, frame: CGRect){
        treeRingMap.fontSize = Float(fontPointSize(1.0).size.height)
        treeRingMap.frame = frame
        treeRingMap.autoResize(frame)
        treeRingMap.setNeedsDisplay()
    }
    
    func loadDataTableIntoSlice(_ dataTable: TRMetricDataTable, slice: TRSlice){
        slice.showMetricDataTable(dataTable)
    }
    
    // MARK: test function for show trmap
    func test_VTD_GAME_OF_SCORE_Static_Dynamic(){
        if treeRingMap == nil {return}
        let pointSize = fontPointSize(1.0)
        treeRingMap?.fontSize = Float(pointSize.size.height)
        
        // 1.two slices tree ring map
        addTwoSlices(0.0, mid: 60.0, end: 180.0)
        // 2.set slice styles
        // slice 0
        treeRingMap?.allSlices?[0].setStyle(SliceViewStyle.style_1)
        treeRingMap?.allSlices?[0].pointsPerFontSize = Float(pointSize.size.height)
        treeRingMap?.allSlices?[0].rightBorderStyle = .metal
        treeRingMap?.allSlices?[0].angleAxis?.fishyEye = false
        treeRingMap?.allSlices?[0].ringAxis?.fishyEye = false
        treeRingMap?.allSlices?[0].angleAxis?.title?.setStringAttributes("Helvetica-Bold", size: 14.0, foregroundColor: UIColor.init(red: 0, green: 0, blue: 1.0, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4), strokeWidth: -3.0)
        treeRingMap?.allSlices?[0].grid?.evenRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        treeRingMap?.allSlices?[0].grid?.oddRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        treeRingMap?.allSlices?[0].grid?.rowFocus = 5
        
        // slice 1
        treeRingMap?.allSlices?[1].setStyle(SliceViewStyle.style_1)
        treeRingMap?.allSlices?[1].pointsPerFontSize = Float(pointSize.size.height)
        treeRingMap?.allSlices?[1].leftBorderStyle = .metal
        treeRingMap?.allSlices?[1].angleAxis?.fishyEye = false
        treeRingMap?.allSlices?[1].ringAxis?.fishyEye = false
        treeRingMap?.allSlices?[1].angleAxis?.title?.setStringAttributes("Helvetica-Bold", size: 14.0, foregroundColor: UIColor.init(red: 0, green: 0, blue: 1.0, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4), strokeWidth: -3.0)
        treeRingMap?.allSlices?[1].grid?.evenRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        treeRingMap?.allSlices?[1].grid?.oddRowBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        treeRingMap?.allSlices?[1].grid?.rowFocus = 5
        treeRingMap?.allSlices?[1].grid?.columnFocus = 3
        
        // set tree ring map inital size
        setTmapSize(treeRingMap!, frame: self.bounds)
        
        // load test data into two slices
        let tableOne = dataTableSource?.createLowVitDGameOfScoresTable(true)
        let tableTwo = dataTableSource?.createLowVitDGameOfScoresTable(false)
        
        loadDataTableIntoSlice(tableOne!, slice: treeRingMap!.allSlices![0])
        loadDataTableIntoSlice(tableTwo!, slice: treeRingMap!.allSlices![1])
        
        // set center label info
        setCenterLabel(treeRingMap!)
        
        // set labels
        setLT_Labels(treeRingMap!)
        
        // set date label
        setDateLabel(treeRingMap!)
        
        treeRingMap?.onDirtyView()
        
        self.addSubview(treeRingMap!)
        
    }
    
    func setCenterLabel(_ trmap: TRMap){
        trmap.centerLabel?.metricInfo?.text = "Your Heart Years: "
        trmap.centerLabel?.metricInfo?.textAttributeDic![NSForegroundColorAttributeName] = UIColor.black
        trmap.centerLabel?.metricInfo?.textAttributeDic![NSStrokeColorAttributeName] = UIColor.darkGray
        
        trmap.centerLabel?.metricValue?.text = "-20"
        trmap.centerLabel?.metricValue?.textAttributeDic![NSForegroundColorAttributeName] = UIColor.red
        trmap.centerLabel?.metricValue?.textAttributeDic![NSStrokeColorAttributeName] = UIColor.black
        
//        trmap.centerLabel?.title?.text = "Tree Of Life"
//        trmap.centerLabel?.title?.textAttributeDic![NSForegroundColorAttributeName] = UIColor.darkGray
//        trmap.centerLabel?.title?.textAttributeDic![NSStrokeColorAttributeName] = UIColor.gray
    
    }
    
    func setLT_Labels(_ treeRingMap: TRMap){
        // labels:
        // title
        treeRingMap.labels?.addLabel("title", label: ANNamedText.init("Helvetica-Bold", size: 12.0, shadow: false, underline: true, name: "", text: "Annielyticx")) //Healthspan Assurance Tree of Life
        
        // name
        treeRingMap.labels?.addLabel("name", label: ANNamedText.init("Helvetica", size: 12.0, shadow: false, underline: false, name: "Name: ", text: "Peter Pan"))
        
        // race
        treeRingMap.labels?.addLabel("race", label: ANNamedText.init("Helvetica", size: 12.0, shadow: false, underline: false, name: "Race: ", text: "American"))
        
        // smoke
        treeRingMap.labels?.addLabel("smoke", label: ANNamedText.init("Helvetica", size: 12.0, shadow: false, underline: false, name: "Smoke: ", text: "Moderate"))
        treeRingMap.labels?.getLabel("smoke").textAttrDic?[NSForegroundColorAttributeName] = UIColor.red.cgColor
        treeRingMap.labels?.getLabel("smoke").textAttrDic?[NSStrokeColorAttributeName] = UIColor.darkGray.cgColor
        
        // leisure
//        treeRingMap.labels?.addLabel("leisure", label: ANNamedText.init("Helvetica", size: 12.0, shadow: false, underline: false, name: "Physical Activity: ", text: "Low"))
//        treeRingMap.labels?.getLabel("leisure").textAttrDic?[NSForegroundColorAttributeName] = UIColor.orange.cgColor
//        treeRingMap.labels?.getLabel("leisure").textAttrDic?[NSStrokeColorAttributeName] = UIColor.darkGray.cgColor
        
    }
    
    func setDateLabel(_ treeRingMap: TRMap){
        // date
        treeRingMap.date?.addLabel("title", label: ANNamedText.init("Helvetica-Bold", size: 12.0, shadow: false, underline: true, name: "", text: "Issue date"))
        
        // today's date
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMMM d, YYYY"
        let dateString = dateFormat.string(from: date)
        
        treeRingMap.date?.addLabel("date", label: ANNamedText.init("Helvetica", size: 12.0, shadow: false, underline: false, name: "", text: dateString))
    }
    
    func testForShowOneSlice(){
        let tableOne = dataTableSource?.createLowVitDGameOfScoresTable(true)
        loadOneTableOnly(tableOne!)
    }
   
}
