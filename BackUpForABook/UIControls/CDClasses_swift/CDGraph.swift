//
//  CDGraph.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

// struct for show ring slice detail
struct RingSlice {
    var left: CGFloat! // angle in degree of left
    var right: CGFloat! // angle in degree of right
    var top: CGFloat! // radius of outerCircle
    var bottom: CGFloat! // raidus of innerCircle
}

// struct for saving hitting object information 
struct HitCDObj {
    var hitObject: CDObjs!
    var ringIndex: Int!
    var sliceIndex: Int!
    var cellIndex: Int!
    var pcnn: AnyObject!
}

// chord graph hit test result
// structure for chord graph objects used for hit test 
enum CDObjs: Int{
    case none = 1
    case title  // ring slice title
    case axis   // axis label
    case ring   // ring index
    case slice  // ring slice
    case cell   // ring index
    case cnn    // connector
}

class CDGraph: UIControl {
    // device points of one font unit size
    fileprivate var oneUnitSize: CGFloat!
    fileprivate var titleRadiusPosition: CGFloat!
    fileprivate var edgeRadiusPosition: CGFloat!
    fileprivate var axisRadiusPosition: CGFloat!
    
    //show title text
    var showText: Bool!
    var showAxis: Bool!
    
    //set value at (initWithFrame)
    var radius: CGFloat!
    var title: CDTitleRing!
    var edge: CDEdge!
    var axis: CDAxisRing!
    var tipMsg: CDTip!
    var rings: NSMutableArray!
    var connectors: NSMutableSet!
    var ringPositions: NSMutableArray!
    var archor_ring: Int!
    var archor_slice: Int!
    var bezierText: ANBezierText!
    
    var origin: CGPoint!
    var hostFrame: CGRect!
    
    var ptBegin: CGPoint!
    var ptEnd: CGPoint!
    var hitObject = HitCDObj()
   
    // MARK: -------- init --------
    override init(frame: CGRect) {
        print("1")
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // initialization code
        showText = true
        showAxis = true
        radius = min(frame.size.width, frame.size.height) - 100
        title = CDTitleRing.init()
        edge = CDEdge.init()
        axis = CDAxisRing.init()
        tipMsg = CDTip.init()
        rings = NSMutableArray.init(capacity: 10)
        connectors = NSMutableSet()
        ringPositions = NSMutableArray()
        
        archor_ring = 0
        archor_slice = 0
        bezierText = ANBezierText.init()
        
        oneUnitSize = 1.0
        titleRadiusPosition = 0.0
        edgeRadiusPosition = 0.0
        axisRadiusPosition = 0.0
    }
    
    // MARK: -------- create test data --------
    func createTestData(){
        removeAllRings()
        
        // connector tip
        bezierText.alignment = CurveTextAlignment.center
        
        // general tip message in the center
        tipMsg.showTip = false
        
        // ring title string style
        title.style = RingTextStyle.alignMiddle//RingTextStyle(rawValue:RingTextStyle.alignBottom.rawValue | RingTextStyle.alignMiddle.rawValue)!
        
        // add one ring
        let firstRing: CDRing = addRing()
        // all rings have the same number of slices
        // first ring is placed in the out most ring position
        firstRing.createSlice(3)
        firstRing.showTop = true
        firstRing.topEdgeColor = UIColor.darkGray
        firstRing.showBottom = true
        firstRing.bottomEdgeColor = UIColor.lightGray
        
        // attributed symbol string
        var textAttributes :[String:AnyObject] = [String:AnyObject]()
        var lbFont:CTFont = CTFontCreateWithName("Helvetica" as CFString?, firstRing.size - 4, nil)
        textAttributes[NSFontAttributeName] = lbFont

        let cellBackgroundStyle = BackgroundStyle.colorGradient
        let cellHighLightStyle = HighLightStyle.fill
        
        //first slice
        if let riskFactors = firstRing.getSlice(0){
            riskFactors.label = "Risk Factors"
            riskFactors.background.bkgColor = UIColor.init(red: 0.8, green:0.2, blue: 0, alpha: 0.2)
            riskFactors.background.edgeColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.4)
            let nCells = 10
            riskFactors.createCells(nCells)
            for i in 0..<nCells {
                let cell = riskFactors.cell(i)!
                cell.showImage = false
                cell.showSymbol = true
                cell.showBackground = true
                cell.background.style = cellBackgroundStyle
                cell.background.highlightStyle = cellHighLightStyle
                cell.background.bkgColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.2)
                cell.background.edgeColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.4)
                cell.background.highlightColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.8)
                cell.symbol = NSMutableString.init(string: String(i))
                cell.symbolAttrubutes = textAttributes
                cell.sizeWeight = CGFloat(i) + 1
            }
        }
        
        //second slice
        if let risks = firstRing.getSlice(1){
            risks.label = "Diseases"
            risks.background.bkgColor = UIColor.init(red: 1.0, green:0, blue: 0, alpha: 0.2)
            risks.background.edgeColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.4)
            let nCells = 8
            risks.createCells(nCells)
            for i in 0..<nCells {
                let cell = risks.cell(i)!
                cell.showImage = false
                cell.showSymbol = true
                cell.showBackground = true
                cell.background.style = cellBackgroundStyle
                cell.background.highlightStyle = cellHighLightStyle
                cell.background.bkgColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.4)
                cell.background.edgeColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.6)
                cell.background.highlightColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.8)
                cell.symbol = NSMutableString.init(string: String(i))
                cell.symbolAttrubutes = textAttributes
                cell.sizeWeight = CGFloat(nCells) - CGFloat(i) + 1
            }
        }
        
        //third slice
        if let actions = firstRing.getSlice(2){
            actions.label = "Control Actions"
            actions.background.bkgColor = UIColor.init(red: 0.13, green:0.545, blue: 0.13, alpha: 0.2)
            actions.background.edgeColor = UIColor.init(red: 0.13, green: 0.545, blue: 0.13, alpha: 0.4)
            let nCells = 18
            actions.createCells(nCells)
            for i in 0..<nCells {
                let cell = actions.cell(i)!
                cell.showImage = false
                cell.showSymbol = true
                cell.showBackground = true
                cell.background.style = cellBackgroundStyle
                cell.background.highlightStyle = cellHighLightStyle
                cell.background.bkgColor = UIColor.init(red: 0, green: 1.0, blue: 0, alpha: 0.6)
                cell.background.edgeColor = UIColor.init(red: 0.13, green: 0.545, blue: 0.13, alpha: 0.8)
                cell.background.highlightColor = UIColor.init(red: 0, green: 1.0, blue: 0, alpha: 0.8)
                cell.symbol = NSMutableString.init(string: String(i))
                cell.symbolAttrubutes = textAttributes
                cell.sizeWeight = CGFloat(nCells) - CGFloat(i) + 1
            }
        }
        
        
        
        // add another ring
        let secondRing = addRing()
        secondRing.createSlice(3)
        secondRing.showTop = false
        secondRing.showBottom = true
        secondRing.bottomEdgeColor = UIColor.lightGray
        textAttributes = [String : AnyObject]()
        lbFont = CTFontCreateWithName("Helvetica" as CFString?, secondRing.size - 4, nil)
        textAttributes[NSFontAttributeName] = lbFont
        //first slice
        if let riskFactors = secondRing.getSlice(0){
            riskFactors.label = "Risk Factors"
            riskFactors.background.bkgColor = UIColor.init(red: 0.8, green:0.2, blue: 0, alpha: 0.2)
            riskFactors.background.edgeColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.4)
            let nCells = 10
            riskFactors.createCells(nCells)
            for i in 0..<nCells {
                let cell = riskFactors.cell(i)!
                cell.showImage = false
                cell.showSymbol = true
                cell.showBackground = true
                cell.background.style = cellBackgroundStyle
                cell.background.highlightStyle = cellHighLightStyle
                cell.background.bkgColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.2)
                cell.background.edgeColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.4)
                cell.background.highlightColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.8)
                cell.symbol = NSMutableString.init(string: String(i))
                cell.symbolAttrubutes = textAttributes
                cell.sizeWeight = CGFloat(nCells) - CGFloat(i) + 1
            }
        }
        //second slice
        if let risks = secondRing.getSlice(1){
            risks.label = "Diseases"
            risks.background.bkgColor = UIColor.init(red: 1.0, green:0, blue: 0, alpha: 0.2)
            risks.background.edgeColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.4)
            let nCells = 8
            risks.createCells(nCells)
            for i in 0..<nCells {
                let cell = risks.cell(i)!
                cell.showImage = false
                cell.showSymbol = true
                cell.showBackground = true
                cell.background.style = cellBackgroundStyle
                cell.background.highlightStyle = cellHighLightStyle
                cell.background.bkgColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.4)
                cell.background.edgeColor = UIColor.init(red: 0.8, green: 0.2, blue: 0, alpha: 0.6)
                cell.background.highlightColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.8)
                cell.symbol = NSMutableString.init(string: String(i))
                cell.symbolAttrubutes = textAttributes
                cell.sizeWeight = CGFloat(i) + 1
            }
        }
        //third slice
        if let actions = secondRing.getSlice(2){
            actions.label = "Control Actions"
            actions.background.bkgColor = UIColor.init(red: 0.13, green:0.545, blue: 0.13, alpha: 0.2)
            actions.background.edgeColor = UIColor.init(red: 0.13, green: 0.545, blue: 0.13, alpha: 0.4)
            let nCells = 18
            actions.createCells(nCells)
            for i in 0..<nCells {
                let cell = actions.cell(i)!
                cell.showImage = false
                cell.showSymbol = true
                cell.showBackground = true
                cell.background.style = cellBackgroundStyle
                cell.background.highlightStyle = cellHighLightStyle
                cell.background.bkgColor = UIColor.init(red: 0, green: 1.0, blue: 0, alpha: 0.6)
                cell.background.edgeColor = UIColor.init(red: 0.13, green: 0.545, blue: 0.13, alpha: 0.8)
                cell.background.highlightColor = UIColor.init(red: 0, green: 1.0, blue: 0, alpha: 0.8)
                cell.symbol = NSMutableString.init(string: String(i))
                cell.symbolAttrubutes = textAttributes
                cell.sizeWeight = CGFloat(i) + 1
            }
        }
        
        
        // setup connections
        let cnnTip = "20 chance a cause b while 10 chance b cause a"
        
        // (0, 0, 0) <-> (0, 1, 0) intensity = 0.1
        let _ = connectCells(cnnTip, ring_a: 0, slice_a: 0, cell_a: 0, intensity_a: 0.2, ring_b: 0, slice_b: 1, cell_b: 0, intensity_b: 0.1)
        // (0, 0, 0) <-> (1, 2, 0)
        let _ = connectCells("connection", ring_a: 0, slice_a: 0, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 2, cell_b: 0, intensity_b: 0.1)
        // (0, 1, 0) <-> (1, 2, 0)
        let _ = connectCells("connection", ring_a: 0, slice_a: 1, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 2, cell_b: 0, intensity_b: 0.1)
        // (0, 1, 0) <-> (1, 2, 8)
        let _ = connectCells("connection", ring_a: 0, slice_a: 1, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 2, cell_b: 8, intensity_b: 0.9)
        // (1, 3, 0) <-> (1, 2, 0)
        let _ = connectCells("connection", ring_a: 1, slice_a: 3, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 2, cell_b: 0, intensity_b: 0.9)
        // (1, 2, 0) <-> (1, 2, 4)
        let _ = connectCells("connection", ring_a: 1, slice_a: 2, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 2, cell_b: 4, intensity_b: 0.8)
        // (0, 1, 0) <-> (1, 2, 3)
        let _ = connectCells("connection", ring_a: 0, slice_a: 1, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 2, cell_b: 3, intensity_b: 0.1)
        // (0, 1, 0) <-> (1, 3, 8)
        let _ = connectCells("connection", ring_a: 0, slice_a: 1, cell_a: 0, intensity_a: 0.2, ring_b: 1, slice_b: 3, cell_b: 8, intensity_b: 0.9)
    }
    // remove all rings and connection objects
    func removeAllRings(){
        rings.removeAllObjects()
        connectors.removeAllObjects()
    }
    
    func setCDSizeAndRadius(_ origin:CGPoint,radius:CGFloat){
        self.origin = origin
        self.radius = radius
        self.hostFrame = self.bounds
    }
    
    
    
    func addRing() -> CDRing{
        let ring = CDRing.init()
        if rings == nil{
            rings = NSMutableArray.init(capacity:  10)
        }
        rings.add(ring)
        return ring
    }
    
    // add connection between two cells and return CDConnection
    func connectCells(_ label:String, ring_a:Int, slice_a:Int, cell_a:Int, intensity_a:CGFloat, ring_b:Int, slice_b:Int, cell_b:Int, intensity_b:CGFloat) -> AnyObject!{
        let cellA = takeOutCell(cell_a, sliceIndex: slice_a, ringIndex: ring_a)
        let cellB = takeOutCell(cell_b, sliceIndex: slice_b, ringIndex: ring_b)
        if cellA == nil || cellB == nil{
            return nil
        }
        
        let cnn = CDConnection.init(cnnLabel: label, ring_a: ring_a, slice_a: slice_a, cell_a: cell_a, intensity_a: intensity_a, ring_b: ring_b, slice_b: slice_b, cell_b: cell_b, intensity_b: intensity_b)
        cnn.node_a = cellA
        cnn.node_b = cellB
        
        connectors.add(cnn)
        
        // add cnn into cell connectors of cellA and cellB
//        if cellA!.connectorIDs == nil{
//            cellA!.connectorIDs = NSMutableArray()
//        }
//        if cellB!.connectorIDs == nil{
//            cellB!.connectorIDs = NSMutableArray()
//        }
        cellA!.connectorIDs.add(cnn)
        cellB!.connectorIDs.add(cnn)
        return cnn
    }
    
    // access to cell
    func takeOutCell(_ cellIndex:Int,sliceIndex:Int,ringIndex:Int) -> CDCell!{
        if rings == nil || ringIndex >= rings.count{
            let _ = print("access to cell fail ring\(ringIndex,sliceIndex,cellIndex)")
            return nil
        }
        if (rings.object(at: ringIndex) as! CDRing).getSlice(sliceIndex) == nil{
            let _ = print("access to cell fail slice\(ringIndex,sliceIndex,cellIndex)")
            return nil
        }
        if cellIndex >= (rings.object(at: ringIndex) as! CDRing).getSlice(sliceIndex).cells.count{
            let _ = print("access to cell fail cell\(ringIndex,sliceIndex,cellIndex)")
            return nil
        }
        return (rings.object(at: ringIndex) as! CDRing).getSlice(sliceIndex).cells.object(at: cellIndex) as! CDCell
    }
    
    // MARK: -------- paint graph --------
    func paint(_ ctx:CGContext){
        // setup ring position
        setRingPositions()
        
        // paint titles
        if showText && title != nil{
            paintTitle(ctx, radius: titleRadiusPosition, center: origin, frameHeight: hostFrame.size.height)
        }
        
        // paint edge
        if edge != nil{
            paintEdge(ctx, radius: edgeRadiusPosition, center: origin, frameHeight: hostFrame.size.height)
        }
        
        // paint axis
        if showAxis && axis != nil{
            paintAxis(ctx, radius: axisRadiusPosition, center: origin, frameHeight: hostFrame.size.height)
        }
        
        // paint all rings
        paintRings(ctx, center: origin, frameHeight: hostFrame.size.height)
        
        // paint all connections
        paintConnections(ctx, center: origin, frameHeight: hostFrame.size.height)
        
        // paint text messages for each highlighted connector ribbons along the ribbon path
        paintHighlightedConnectionTips(ctx, center: origin, frameHeight: hostFrame.size.height)
        
        // paint tip message
        paintTipMessage(ctx, center: origin, frameHeight: hostFrame.size.height)
    
    }
    
    func paintTitle(_ ctx:CGContext,radius:CGFloat,center:CGPoint,frameHeight:CGFloat){
        if title == nil || rings.count <= 0{
            return
        }
        ctx.saveGState()
        var archorRing:CDRing!
        if archor_ring >= rings.count || archor_ring < 0{
            archorRing = rings.object(at: 0) as! CDRing
        }else{
            archorRing = rings.object(at: archor_ring) as! CDRing
        }
        title.paint(ctx, archorRing: archorRing, radius: radius, center: center, frameHeight: frameHeight)
        ctx.saveGState()
    }
    func paintEdge(_ ctx:CGContext,radius:CGFloat,center:CGPoint,frameHeight:CGFloat){
        ctx.saveGState()
        var size = RingSlice()
        size.bottom = radius
        size.top = size.bottom + edge.takeOutRuntimeSize()
        size.right = 0.0
        size.left = 360.0
        edge.background?.paint(ctx, size: size, center: center)
        ctx.restoreGState()
    }
    func paintAxis(_ ctx:CGContext,radius:CGFloat,center:CGPoint,frameHeight:CGFloat){
        ctx.saveGState()
        ctx.restoreGState()
        
    }
    
    // paint rings
    func paintRings(_ ctx: CGContext,
                   center: CGPoint,
              frameHeight: CGFloat){
        
        for i in 0..<rings.count{
            let rPosition :CGFloat!
            let size :CGFloat!
            let oneRing = rings.object(at: i) as! CDRing
            rPosition = ringPositions.object(at: i) as! CGFloat
            size = oneRing.size * oneUnitSize
            
            // paint all ring slices
            for j in 0..<Int(oneRing.numberOfSlice()){
                oneRing.getSlice(j).paint(ctx, center: center, bottom: rPosition, top: (rPosition + size), frameHeight: frameHeight)
            }
            oneRing.paint(ctx: ctx, radius: rPosition, size: size, center: center)
        }
    
    }
    func paintConnections(_ ctx: CGContext,
                         center: CGPoint,
                    frameHeight: CGFloat){
        
        for object in connectors{
            let obj = object as! NSObject
            if obj.isKind(of: CDConnection.self) == false{
                continue
            }
            paintConnnection(ctx, connection: obj as! CDConnection, center: center, frameHeight: frameHeight)
        }
        
    }
    
    // paint one connection
    func paintConnnection(_ ctx: CGContext,
                     connection: CDConnection,
                         center: CGPoint,
                    frameHeight: CGFloat){
        
        ctx.saveGState()
        let node :CDCell!
        if connection.cnnNodeA.intensity > connection.cnnNodeB.intensity{
            node = connection.node_a as! CDCell!
        }else{
            node = connection.node_b as! CDCell!
        }
        if connection.highlight == true{
            ctx.setFillColor(node.background.highlightColor.cgColor)
        }else{
            ctx.setFillColor(node.background.bkgColor.cgColor)
        }
        ctx.setStrokeColor(node.background.edgeColor.cgColor)
        ctx.setLineWidth(0.5)
        ctx.beginPath()
        
        let radius_a:CGFloat = ringPositions.object(at: connection.cnnNodeA.ring) as! CGFloat
        let radius_b:CGFloat = ringPositions.object(at: connection.cnnNodeB.ring) as! CGFloat
        
        print("-------------")
        print(connection.cnnNodeA.ring,connection.cnnNodeA.slice,connection.cnnNodeA.cell)
        print(connection.cnnNodeB.ring,connection.cnnNodeB.slice,connection.cnnNodeB.cell)
        print(connection.cnnNodeA.right)
        print(connection.cnnNodeA.left)
        print(connection.cnnNodeB.right)
        print(connection.cnnNodeB.left)
        print("-------------")
        
        
        // create path and save it in connection for later hit testing
        setConnectorRibbonPath(connection, radius_a: radius_a, start_a: connection.cnnNodeA.right, end_a: connection.cnnNodeA.left, radius_b: radius_b, start_b: connection.cnnNodeB.right, end_b: connection.cnnNodeB.left, center: center)
        
        
        ctx.addPath(connection.aPath.cgPath)
        ctx.drawPath(using: .fillStroke)
        ctx.restoreGState()
    }
    
    // update visual connector path saved in connection object
    func setConnectorRibbonPath(_ connection:CDConnection?,
                                    radius_a: CGFloat,
                                     start_a: CGFloat,
                                       end_a: CGFloat,
                                    radius_b: CGFloat,
                                     start_b: CGFloat,
                                       end_b: CGFloat,
                                      center: CGPoint){
        
        if connection == nil{
            return
        }
        if connection!.aPath == nil{
            // new object
            connection!.aPath = UIBezierPath()
        }else{
            // empty all sub paths
            connection!.aPath.removeAllPoints()
        }
        
        
        // create new path into connection object
        // user coordinate of 4 points area:
        // p1 - left/top defined by node_a right
        // p2 - left/bottom defined by node_a left 
        // p3 - right/bottom defined by node_b right
        // p4 - right/top defined by node_b top
        
        // start from p3
        let p3 = CGPoint.init(x:center.x + radius_b * CGFloat(cosf(Float(DEGREE_TO_RADIANS(start_b)))), y: center.y - radius_b * CGFloat(sinf(Float(DEGREE_TO_RADIANS(start_b)))))
        let p1 = CGPoint.init(x:center.x + radius_a * CGFloat(cosf(Float(DEGREE_TO_RADIANS(start_a)))), y: center.y - radius_a * CGFloat(sinf(Float(DEGREE_TO_RADIANS(start_a)))))
        connection!.aPath.move(to: p3)
        connection!.aPath.addArc(withCenter: center, radius: radius_b, startAngle: -DEGREE_TO_RADIANS(start_b), endAngle: -DEGREE_TO_RADIANS(end_b), clockwise: false)
        connection!.aPath.addQuadCurve(to: p1, controlPoint: center)
        connection!.aPath.addArc(withCenter: center, radius: radius_a, startAngle: -DEGREE_TO_RADIANS(start_a), endAngle: -DEGREE_TO_RADIANS(end_a), clockwise: false)
        connection!.aPath.addQuadCurve(to: p3, controlPoint: center)
        connection!.aPath.close()
    
    }
    func paintHighlightedConnectionTips(_ ctx:CGContext,center:CGPoint,frameHeight:CGFloat){
        
    }
    func paintTipMessage(_ ctx:CGContext,center:CGPoint,frameHeight:CGFloat){
        
    }
    
    // reset ring radius positions ringPositions. called before painting all objects
    func setRingPositions(){
        let size = self.size(1.0)
        
        oneUnitSize = size.size.height
        translateChildernFontSize(oneUnitSize)
        
        // title ring position
        if showText == true && title != nil{
            titleRadiusPosition = radius - title.takeOutRuntimeSize()
        }
        // edge ring position
        if edge != nil{
            edgeRadiusPosition = titleRadiusPosition - edge.takeOutRuntimeSize()
        }
        // axis ring position
        if showAxis == true && axis != nil{
            axisRadiusPosition = edgeRadiusPosition - axis.takeOutRuntimeSize()
        }else{
            axisRadiusPosition = edgeRadiusPosition
        }
        // data ring position starts from axisRadiusPosition
        if ringPositions == nil{
            ringPositions = NSMutableArray()
        }else{
            ringPositions.removeAllObjects()
        }
        
        var ringPos = axisRadiusPosition

        for i in 0..<rings.count{
            if (rings.object(at: i) as AnyObject).isKind(of: CDRing.self) == false{
                continue
            }
            let oneRing = rings.object(at: i)
            ringPos = ringPos! - (oneRing as AnyObject).takeOutRuntimeSize()
            ringPositions.add(ringPos!)
        }
    }
    
    // return the rect of one letter with given font size
    func size(_ fontSize:CGFloat) -> CGRect{
        var attrDictionary = [String:AnyObject]()
        let lbFont = CTFontCreateWithName("Helvetica" as CFString?, fontSize, nil)
        attrDictionary[NSFontAttributeName] = lbFont
        let attrString = NSMutableAttributedString.init(string: "a", attributes: attrDictionary)
        return attrString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
    }
    
    // set up all child component size based on given unit font size
    func translateChildernFontSize(_ pointsPerFontSize:CGFloat){
        title.translateChildernFontSize(pointsPerFontSize)
        axis.translateChildernFontSize(pointsPerFontSize)
        edge.translateChildernFontSize(pointsPerFontSize)
        
        for obj in rings {
            let ring = obj as! CDRing
            ring.translateChildernFontSize(pointsPerFontSize)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -------- drawRect --------
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        // paint graph
        paint(ctx!)
    }
    
    // caller needs to decide when to call onDirtyView to make sure the view and data in sync
    // radius - in font size
    func setCDSize(_ origin:CGPoint,radius:CGFloat){
        self.origin = origin
        self.radius = radius
        self.hostFrame = self.bounds
    }
    func onDirtyView(){
        setSliceAnglePositions()
    
    }
    
    // set each slice real position
    func setSliceAnglePositions(){
        
        // get archorRing
        var archorRing:CDRing!
        if archor_ring >= rings.count || archor_ring < 0{
            archorRing = rings.object(at: 0) as! CDRing
        }else{
            archorRing = rings.object(at: archor_ring) as! CDRing
        }
        if archorRing == nil{
            return
        }
        if archorRing.numberOfSlice() <= 0{
            return
        }
        
        // gap between slices of this ring
        let gap = archorRing.gap
        // the rest space
        var angleSpace = 360.0 - CGFloat(archorRing.numberOfSlice()) * gap!
        
        // number of total cells at one ring
        var totalCells = 0
        for i in 0..<archorRing.numberOfSlice(){
            totalCells += archorRing.getSlice(i).numberOfCells()
        }
        var cellWidth = angleSpace / CGFloat(totalCells)
        
        // width of all slices of one ring -> array 
        // the width of slice is according to the number of it's cells,
        let sliceWidths = NSMutableArray.init(capacity: archorRing.numberOfSlice())
        for i in 0..<archorRing.numberOfSlice(){
            sliceWidths.add(NSNumber.init(value: Float(cellWidth * CGFloat(archorRing.getSlice(i).numberOfCells()))))
        }
        
        var nLargeSlices = 0
        angleSpace = 360.0 - CGFloat(archorRing.numberOfSlice() + 1) * gap!
        totalCells = 0
        for i in 0..<archorRing.numberOfSlice(){
            let num = sliceWidths.object(at: i) as! NSNumber
            if CGFloat(num.floatValue) >= archorRing.getSlice(i).maxSize{
                nLargeSlices += 1
                angleSpace -= archorRing.getSlice(i).maxSize
            }else{
                totalCells += archorRing.getSlice(i).numberOfCells()
            }
        }
        if nLargeSlices > 0{
            cellWidth = angleSpace / CGFloat(totalCells)
            for i in 0..<archorRing.numberOfSlice(){
                let num = sliceWidths.object(at: i) as! NSNumber
                if CGFloat(num.floatValue) >= archorRing.getSlice(i).maxSize{
                    sliceWidths[i] = NSNumber.init(value: Float(archorRing.getSlice(i).maxSize))
                }else{
                    sliceWidths[i] = NSNumber.init(value:Float(CGFloat(archorRing.getSlice(i).numberOfCells()) * cellWidth))
                }
            }
        }
        var start :Float = 0.0
        var end :Float = 0.0
        
        // set the left and right of each slice at one ring
        for i in 0..<archorRing.numberOfSlice(){
            let n = sliceWidths.object(at: i) as! NSNumber
            end = start + n.floatValue
            archorRing.getSlice(i).right = CGFloat(start)
            archorRing.getSlice(i).left = CGFloat(end)
            start = end + Float(archorRing.gap)
        }
        
        var archorSlice = archorRing.getSlice(archor_slice)
        if archorSlice == nil{
            archorSlice = archorRing.getSlice(0)
        }
        if archorSlice == nil{
            return
        }
        let shift = 90.0 - (archorSlice!.left! + archorSlice!.right!) * 0.5
        for i in 0..<archorRing.numberOfSlice(){
            archorRing.getSlice(i).left = archorRing.getSlice(i).left + shift
            archorRing.getSlice(i).right = archorRing.getSlice(i).right + shift
            archorRing.getSlice(i).onDirtyView()
        }
        for i in 0..<rings.count{
            if i == archor_ring || (rings.object(at: i) as AnyObject).isKind(of: CDRing.self) == false{
                continue
            }
            let oneRing = rings.object(at: i) as! CDRing
            for i in 0..<oneRing.numberOfSlice(){
                oneRing.getSlice(i).left = archorRing.getSlice(i).left
                oneRing.getSlice(i).right = archorRing.getSlice(i).right
                oneRing.getSlice(i).onDirtyView()
            }
        }
    }
    func setArchorSlice(ring:Int,slice:Int){
        archor_ring = ring
        archor_slice = slice
    }
    
    // MARK:touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        ptBegin = touch?.location(in: self)
        hitTest(ptBegin)
        if hitObject.hitObject == CDObjs.none{
            print("hit none")
            setNeedsDisplay()
            return
        }
        if hitObject.hitObject == CDObjs.axis{
            // hit axis
        
        }else if hitObject.hitObject == CDObjs.title{
            // hit title text
            // remove highlight first
            setGraphConnectorState(false)
            
            // set slice connectors
            setSliceConnectorState(true, slice: hitObject.sliceIndex)
            setNeedsDisplay()
        }else if hitObject.hitObject == CDObjs.slice{
            setGraphConnectorState(false)
            setRingSliceConnectorState(ring: hitObject.ringIndex, slice: hitObject.sliceIndex, highlight: true)
            setNeedsDisplay()
        }else if hitObject.hitObject == CDObjs.cell{
        
        }else if hitObject.hitObject == CDObjs.cnn{
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        ptEnd = touch?.location(in: self)
        if hitObject.hitObject == CDObjs.none{
            let delta = ptEnd.x - ptBegin.x
            // change graph size
            let center = origin
            let newRadius = radius + delta
            setCDSize(center!, radius: newRadius)
            onDirtyView()
            setNeedsDisplay()
            ptBegin = ptEnd
            return
        }else if hitObject.hitObject == CDObjs.title{
            var endAngle: CGFloat = 0.0
            endAngle = 180.0 * atan(-(ptEnd.y - origin.y) / (ptEnd.x - origin.x)) / 3.14
            if (ptEnd.x - origin.x) < 0{
                endAngle += 180
            }
            var beginAngle: CGFloat = 0.0
            beginAngle = 180.0 * atan(-(ptEnd.y - origin.y) / (ptEnd.x - origin.x)) / 3.14
            if (ptBegin.x - origin.x) < 0{
                beginAngle += 180.0
            }
            if endAngle > beginAngle{
                rotate(left: true)
            }else if endAngle < beginAngle{
                rotate(left: false)
            }
            onDirtyView()
            setNeedsDisplay()
            
            ptBegin = ptEnd
            hitObject.hitObject = CDObjs.none
            return
        }
    }
    
    //
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
    }
    
    //
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // object hit test .result is saved in hitObj
    func hitTest(_ hitPt:CGPoint){
        hitObject.hitObject = CDObjs.none
        hitObject.pcnn = 0 as AnyObject
        
        // (1) hit ring title
        if title != nil{
            var archorRing :CDRing!
            if archor_ring >= rings.count || archor_ring < 0{
                archorRing = rings.object(at: 0) as! CDRing
            }else{
                archorRing = rings.object(at: archor_ring)  as! CDRing
            }
            hitObject = title.hitTest(atPoint: hitPt, archorRing: archorRing, radius: titleRadiusPosition, center: center)
            if hitObject.hitObject != CDObjs.none{
                print("hit title:\(hitObject.hitObject)")
                return
            }
        }
        
        // (2) hit axis 
        if (axis != nil){
            hitObject = axis.hitTest(atPoint: hitPt, radius: axisRadiusPosition, center: center)
            if hitObject.hitObject != CDObjs.none{
                print("hit axis:\(hitObject.hitObject)")
                return
            }
        }
        
        // (3) hit ring cell
        var rPosition: CGFloat
        for i in 0..<rings.count{
            let oneRing = rings.object(at: i) as! CDRing
            let num = ringPositions.object(at: i) as! NSNumber
            rPosition = CGFloat(num.floatValue)
            hitObject = oneRing.hitTest(atPoint: hitPt, ring: i, radius: rPosition, center: center)
            if hitObject.hitObject == CDObjs.ring{
                print("hit ring:\(hitObject.hitObject)")
                return
            }else if (hitObject.hitObject != CDObjs.none){
                print("hit cell:\(hitObject.hitObject)")
                return
            }
        }
        
        // (4) hit node connectors
        for obj in connectors{
            let object = obj as AnyObject
            if object.isKind(of: CDConnection.self) == false{
                continue
            }
            let connector = object as! CDConnection
            if connector.hitTest(hitPt) == true{
                print("hit connector:\(hitObject.hitObject)")
                hitObject.hitObject = CDObjs.cnn
                hitObject.pcnn = object
                return
            }
        }
    }
    
    // all cells on the graph
    func setGraphConnectorState(_ highlight:Bool){
        var cnn: CDConnection
        // apply to entire connector set
        for obj in connectors{
            let object = obj as AnyObject
            if object.isKind(of: CDConnection.self) == false{
                continue
            }
            
            // highlight the connector
            cnn = object as! CDConnection
            cnn.highlight = highlight
            let aCell = takeOutCell(cnn.cnnNodeA.ring, sliceIndex: cnn.cnnNodeA.slice, ringIndex: cnn.cnnNodeA.cell)
            let bCell = takeOutCell(cnn.cnnNodeB.ring, sliceIndex: cnn.cnnNodeB.slice, ringIndex: cnn.cnnNodeB.cell)
            
            if aCell != nil{
                aCell?.background.highlight = highlight
            }
            if bCell != nil{
                bCell?.background.highlight = highlight
            }
            
        }
    }
    
    // highlight
    func setSliceConnectorState(_ highlight:Bool, slice:Int){
        var cnn: CDConnection
        // apply to entire connector set
        for obj in connectors{
            let object = obj as AnyObject
            if object.isKind(of: CDConnection.self) == false{
                continue
            }
            
            // highlight the connector
            cnn = object as! CDConnection
            
            if cnn.cnnNodeA.slice != slice && cnn.cnnNodeB.slice != slice{
                continue
            }
        
            cnn.highlight = highlight
            
            cnn = object as! CDConnection
            cnn.highlight = highlight
            
            
            
            let aCell = takeOutCell(cnn.cnnNodeA.ring, sliceIndex: cnn.cnnNodeA.slice, ringIndex: cnn.cnnNodeA.cell)
            let bCell = takeOutCell(cnn.cnnNodeB.ring, sliceIndex: cnn.cnnNodeB.slice, ringIndex: cnn.cnnNodeB.cell)
            
            if aCell != nil{
                aCell?.background.highlight = highlight
            }
            if bCell != nil{
                bCell?.background.highlight = highlight
            }
            
        }
    }
    
    // 
    func setRingSliceConnectorState(ring:Int,
                                   slice:Int,
                               highlight:Bool){
        
        var cnn :CDConnection
        for obj in connectors{
            let object = obj as AnyObject
            if object.isKind(of: CDConnection.self) == false{
                continue
            }
            cnn = object as! CDConnection
            if cnn.cnnNodeA.ring != ring && cnn.cnnNodeB.ring != ring{
                continue
            }
            if cnn.cnnNodeA.slice != slice && cnn.cnnNodeB.slice != slice{
                continue
            }
            cnn.highlight = highlight
            cnn = object as! CDConnection
            cnn.highlight = highlight
            let aCell = takeOutCell(cnn.cnnNodeA.ring, sliceIndex: cnn.cnnNodeA.slice, ringIndex: cnn.cnnNodeA.cell)
            let bCell = takeOutCell(cnn.cnnNodeB.ring, sliceIndex: cnn.cnnNodeB.slice, ringIndex: cnn.cnnNodeB.cell)
            if aCell != nil{
                aCell?.background.highlight = highlight
            }
            if bCell != nil{
                bCell?.background.highlight = highlight
            }
        }
    }
    
    //
    func rotate(left: Bool){
        let ring = rings.object(at: archor_ring) as! CDRing
        let nSlices = ring.numberOfSlice()
        var archorSlice = left ? (archor_slice - 1) : (archor_slice + 1)
        if archorSlice >= nSlices{
            archorSlice = archorSlice % nSlices
        }else if (archorSlice < 0){
            archorSlice += nSlices
        }
        setArchorSlice(ring: archor_ring, slice: archorSlice)
        return
    }
    
}
