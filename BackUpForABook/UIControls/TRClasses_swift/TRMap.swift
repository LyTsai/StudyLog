//
//  TRMap.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

// main components of trmap all in here: very important class


import UIKit

class TRMap: UIControl {
    // off Screen drawing
    var offScreen = false
    // index of obj being hit
    var idxObj: Int = -1
    var hitObj = HitObj()
    var fontSize: Float?
    var allSlices: [TRSlice]?
    var innerSpace: Float?
    var outerSpace: Float?
    var origin: CGPoint?
    var min: Float?
    var max: Float?
    // begin touch point
    var ptBegin: CGPoint?
    // end touch point
    var ptEnd: CGPoint?
    
    // label in the center
    var centerLabel: TRCenterLabel?
    // labels on left_top
    var labels: TRMLabels?
    // date label
    var date: TRMLabels?
    var lastScale: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear//(red: 151.0/255.0, green: 190/255.0, blue: 76/255.0, alpha: 1.0)
        // 
        if offScreen == true{
        
        }else{
        
        }
        
        // labels 
        labels = TRMLabels.init()
        
        // center label
        centerLabel = TRCenterLabel.init()
        
        // date label
        date = TRMLabels.init()
        
        hitObj.hitObject = .none
        fontSize = 1.0
        innerSpace = 70.0
        outerSpace = 60.0
        origin = CGPoint(x: 0, y: 0)
        min = 0
        max = 0
        
        // pinch 
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        addGestureRecognizer(pinchRecognizer)
        
    }
    
    func pinchAction(_ sender: UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            lastScale = 1.0
            return
        }
        let scale = 1.0 - (lastScale - sender.scale)
        let currentTransform = self.transform
        let newTransform = currentTransform.scaledBy(x: scale, y: scale)
        self.transform = newTransform
        lastScale = sender.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func composeTreeRingMap(_ slicePositions: [NSNumber]){
        if slicePositions.count <= 1 {return}
        
        if allSlices == nil{
            allSlices = [TRSlice]()
        }else{
            allSlices?.removeAll()
        }
        
        // create tree slices
        var b = slicePositions[0].floatValue
        var e: Float
        
        for i in 0..<slicePositions.count - 1{
            e = slicePositions[i + 1].floatValue
            let sliceObj = TRSlice.init()
            sliceObj.parent = self.layer
            sliceObj.size.left = e
            sliceObj.size.right = b
            
            // right most slice
            if i == 0 {
                sliceObj.background!.style = .colorFill
                sliceObj.rowBarStyle = .rightOrBottom
                sliceObj.rowLabelOnLeft = false
                sliceObj.rowLabelOnRight = true
                sliceObj.leftBorderStyle = .line
                sliceObj.rightBorderStyle = .metal
            }else if i == (slicePositions.count - 2){
                sliceObj.background!.style = .colorFill
                sliceObj.rowBarStyle = .rightOrBottom
                sliceObj.rowLabelOnLeft = true
                sliceObj.rowLabelOnRight = false
                sliceObj.leftBorderStyle = .metal
                sliceObj.rightBorderStyle = .line
            }else{
                sliceObj.background!.style = .colorFill
                sliceObj.rowBarStyle = BarPosition.none
                sliceObj.rowLabelOnLeft = false
                sliceObj.rowLabelOnRight = false
                sliceObj.leftBorderStyle = .line
                sliceObj.rightBorderStyle = .line
                sliceObj.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            
            allSlices?.append(sliceObj)

            b = e
        
        }
      
    }
    
    func autoResize(_ size: CGRect){
        let rmin = innerSpace! * fontSize!
        var rmax: Float = 0.5 * Float(size.size.width)
        var origin  = CGPoint(x: size.size.width / 2.0, y: size.size.height / 2.0)
        var d: Float = 0.0
        if allSlices!.count >= 1{
            let oneSlice = allSlices![0]
            let value = abs(sinf(DEGREETORADIANS(degree: oneSlice.size.right!))) > d
            if (oneSlice.size.right! < Float(0.0) || oneSlice.size.right! > Float(180.0)) && (value == true){
                d = abs(sinf(DEGREETORADIANS(degree: oneSlice.size.right!)))
            }
            let lastSlice = allSlices!.last
            let value1 = abs(sinf(DEGREETORADIANS(degree: oneSlice.size.left!))) > d
            if ((lastSlice?.size.left!)! < Float(0.0) || (lastSlice?.size.left!)! > Float(180.0)) && (value1 == true){
                d = abs(sinf(DEGREETORADIANS(degree: (lastSlice?.size.left!)!)))
            }
        }else{
            d = 1.0
        }
        
        if (1.0 + d) * Float(rmax) > Float(size.size.height){
            rmax = Float(size.size.height) / (1.0 + d)
        }
        
        origin.y = size.origin.y + CGFloat(rmax)
        let dR: Float = outerSpace! * fontSize!
        rmax -= dR
        origin.y += 0.5 * CGFloat(dR)
        setTRsize(origin , min: rmin, max: rmax)
        onDirtyView()
        onSize()
      
    }
    
    func setTRsize(_ origin: CGPoint, min: Float, max: Float){
        for i in 0..<allSlices!.count{
            allSlices![i].hostFrame = bounds
            allSlices![i].origin = origin
            allSlices![i].size.bottom = min
            allSlices![i].size.top = max
          
        }
        self.origin = origin
        self.min = min
        self.max = max
    }
    
    func onDirtyView(){
        for i in 0..<allSlices!.count{
            allSlices![i].onDirtyView()
        }
        
    }
    
    func onSize(){
        for i in 0..<allSlices!.count{
            allSlices![i].onSize()
        }
    }
   
    // MARK: draw begin
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        // 1. paint background
        ctx?.setFillColor(backgroundColor!.cgColor)
        ctx?.fill(rect)
        
        // 2. draw all slices
        for i in 0..<allSlices!.count{
            self.allSlices?[i].paint(ctx!)
        }
        
        // 3. paint center label
        centerLabel!.paint(ctx!, radius: (min! - 10 * fontSize!), origin: origin!,borderWidth: 10 * fontSize!)
        
        // 4. paint labels on left_top
        let ltPosition = CGPoint(x: rect.origin.x + CGFloat(10 * fontSize!), y: 0.5 * (rect.origin.y + origin!.y - CGFloat(max!)))
       
        var pos = labels?.paint(ctx!, orderByKeys: labels!.keys!, alignment: TRMTextAlignment.left_top, lineSpace: 2.0, position: ltPosition)
        
        // 5. paint date label
        pos = ltPosition
        pos?.x = rect.origin.x + rect.size.width - 10 * CGFloat(fontSize!)
        print("-----note: pos\(date?.keys)-----")
        let _ = date?.paint(ctx!, orderByKeys: date!.keys!, alignment: TRMTextAlignment.right_top, lineSpace: 2.0, position: pos!)
    }
    
    // MARK: touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        // hit position 
        ptBegin = touch?.location(in: self)
        
        // object hit test
        hitTest(ptBegin!)
        
        // did we hit the axis?
        var hitSlice: TRSlice
        if idxObj >= 0 && (hitObj.hitObject == TRObjs.column_axis || hitObj.hitObject == TRObjs.row_axis){
            // slice object 
            hitSlice = allSlices![idxObj]
            
            // center position
            let center = hitSlice.origin
            
            // {angle, radius} point position
            let r = hypotf(Float(ptBegin!.x - center!.x), Float(ptBegin!.y - center!.y))
            var endAngle = 180.0 * atan(-(ptBegin!.y - center!.y) / (ptBegin!.x - center!.x)) / 3.14
            if ptBegin!.x - center!.x < 0 {
                endAngle += 180
            }
            
            if hitObj.hitObject == TRObjs.column_axis{
                // the column bar hit event should be handled inside the slice and ask for update display after
                moveSliceColumnSliderBar(hitSlice, barPositon: Float(endAngle))
                setNeedsDisplay()
            }else if hitObj.hitObject == TRObjs.row_axis{
                // the row bar hit event should be handled inside the slice and ask for update display after
                moveSliceRowSliderBar(hitSlice, barPosition: r)
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        ptEnd = touch?.location(in: self)
        
        if idxObj < 0 || hitObj.hitObject == TRObjs.none{return}
        
        var hitSlice: TRSlice
        if hitObj.hitObject == TRObjs.arrows_begin || hitObj.hitObject == TRObjs.arrows_end || hitObj.hitObject == TRObjs.columnBar || hitObj.hitObject == TRObjs.rowBar{
            hitSlice = allSlices![idxObj]
            // center position
            let center = hitSlice.origin
            
            // {angle, radius} point position
            let r = hypotf(Float(ptEnd!.x - center!.x), Float(ptEnd!.y - center!.y))
            
            var endAngle: Float = 180.0 * Float(atan(-(ptEnd!.y - center!.y) / (ptEnd!.x - center!.x))) / Float(3.14)
            if (ptEnd!.x - center!.x) < 0 {
                endAngle += 180
            }
            var size = hitSlice.size
            
            if hitObj.hitObject == TRObjs.arrows_begin{
            
                // change the size of hitted slice first 
                size.right = endAngle
                setSliceSize(hitSlice, sliceSize: size)
                
                // divider between two slices
                if idxObj >= 1{
                    hitSlice = allSlices![idxObj - 1]
                    size = hitSlice.size
                    size.left = endAngle
                    setSliceSize(hitSlice, sliceSize: size)
                }
                autoResize(bounds)
                layer.setNeedsDisplay()
            }else if (hitObj.hitObject == TRObjs.arrows_end){
                // change the size of hitted slice first
                size.left = endAngle
                setSliceSize(hitSlice, sliceSize: size)
                
                // divider between two slices
                if idxObj < allSlices!.count - 1{
                    hitSlice = allSlices![idxObj + 1]
                    size = hitSlice.size
                    size.right = endAngle
                    setSliceSize(hitSlice, sliceSize: size)
                }
                autoResize(bounds)
                layer.setNeedsDisplay()
            }else if hitObj.hitObject == TRObjs.columnBar{
                moveSliceColumnSliderBar(hitSlice, barPositon: endAngle)
                setNeedsDisplay()
            }else if hitObj.hitObject == TRObjs.rowBar{
                // the row bar hit event should be handled inside the slice and ask for update display after
                moveSliceRowSliderBar(hitSlice, barPosition: r)
                setNeedsDisplay()
            }
            
        }
        ptBegin = ptEnd
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        hitObj.hitObject = TRObjs.none
        touchesEnded(touches, with: event)
    }
    
    // hit test will walk down the object list . idxObj will be -1 if hit no object
    fileprivate func hitTest(_ hitPt: CGPoint){
        idxObj = -1
        
        // go over object list(ring slices)
        for i in 0..<allSlices!.count{
            hitObj = allSlices![i].hitTest(ptBegin!)
            
            if hitObj.hitObject != TRObjs.none{
                idxObj = i
                hitObj.sliceIndex = i
                return
            }
        }
        
    }
    
    // move slice column slider bar
    func moveSliceColumnSliderBar(_ slice: TRSlice, barPositon: Float){
        slice.setColumnAxisSliderBarPosition(barPositon)
    }
    
    // move slice row slider bar
    func moveSliceRowSliderBar(_ slice: TRSlice, barPosition: Float){
        slice.setRowAxisSliderBarPosition(barPosition)
    }
    
    // set slice size
    func setSliceSize(_ slice: TRSlice, sliceSize: Slice){
        // hosting frame bound for coordinate conversion
        slice.hostFrame = self.bounds
        slice.size = sliceSize
        slice.onDirtyView()
    }
     
    
}
