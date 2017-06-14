//
//  MHLineChartView.swift
//  ANBookPad
//
//  Created by dingf on 16/9/27.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
//和CGPathElement对应的类
public class PathElement {
    var type :bezierPathPointType!
    var pointsArr :[CGPoint]!
    init(element: CGPathElement) {
        switch element.type {
        case .MoveToPoint:
            type = bezierPathPointType.MoveToPoint
            pointsArr = [element.points[0]]
        case .AddLineToPoint:
            type = bezierPathPointType.AddLineToPoint
            pointsArr = [element.points[0]]
        case .AddQuadCurveToPoint:
            type = bezierPathPointType.AddQuadCurveToPoint
            pointsArr = [element.points[0],element.points[1]]
        case .AddCurveToPoint:
            type = bezierPathPointType.AddCurveToPoint
            pointsArr = [element.points[0],element.points[1],element.points[2]]
        case .CloseSubpath:
            type = bezierPathPointType.CloseSubpath
            pointsArr = nil
        }
    }
}
public enum bezierPathPointType {
    case MoveToPoint
    case AddLineToPoint
    case AddQuadCurveToPoint
    case AddCurveToPoint
    case CloseSubpath
}
//获取bezierPath上面的点,要想获取全曲线点，要先创建一个path的dash copy再进行读取
extension UIBezierPath {
    var elements: [PathElement] {
        var pathElements = [PathElement]()
        withUnsafeMutablePointer(&pathElements) { elementsPointer in
            CGPathApply(CGPath, elementsPointer) { (userInfo, nextElementPointer) in
                let nextElement = PathElement(element: nextElementPointer.memory)
                let elementsPointer = UnsafeMutablePointer<[PathElement]>(userInfo)
                elementsPointer.memory.append(nextElement)
            }
        }
        return pathElements
    }
}

class MHLineChartView: UIView {
    private var personView :UIView!
    private var movedCenter :  CGPoint!
    private var pathPointIndex = 0
    private var pathPointCount :Int!
    private var pathPointsArr = [CGPoint]()
    private var personLayer: CALayer!
    private var contextRef :CGContext!
    //各边偏移量
    private var leftOffset:CGFloat!
    private var rightOffset:CGFloat!
    private var topOffset:CGFloat!
    private var bottomOffset:CGFloat!
    //横竖轴的行数
    private var horizontalNumber :Int = 10
    private var verticalNumber :Int = 12
    /** 实线颜色*/
    private var lineColor = UIColor.lightGrayColor()
    /** 虚线颜色*/
    private var dashLineColor = UIColor.grayColor()
    /** y轴 轴上文字数组 依次减小*/
    private var yAxisNumbers = ["100","90","80","70","60","50","40","30","20","10"]
    /** x轴 轴上表征文字宽度字符串*/
    private var yAxisWidthString = "10000"
    /** y轴 轴上文字大小*/
    //private var yAxisFont = UIFont.systemFontOfSize(18)
    /** y轴上文字与y轴的间距*/
    private var yStringOffset:CGFloat = 10
    /** x轴 轴上文字数组 依次增大*/
    private var xAxisNumbers = ["0","10","20","30","40","50","60","70","80","90","100","110"]
    /** x轴 轴上表征文字宽度字符串*/
    private var xAxisWidthString = "10000"
    /** x轴 轴上文字大小*/
    //private var xAxisFont = UIFont.systemFontOfSize(18)
    /** x轴最大值*/
    private var xMaxValue :CGFloat = 110
    /** y轴最大值*/
    private var yMaxValue :CGFloat = 100
    /** x轴最小值*/
    private var xMinValue :CGFloat = 0
    /** y轴最小值*/
    private var yMinValue :CGFloat = 10
    /** 文本框文字大小*/
    private var textLabelFontSize :CGFloat = 16
    /** 头像注解文字大小*/
    private var tipFontSize :CGFloat = 20
    /** 曲线文字大小*/
    private var curveTextFontSize :CGFloat = 16
    private var unitOffset:CGFloat = 30
    private var xUnitString = "AGE"
    private var yUnitString = "%Vitality"
    private var tipString = "You are here"
    
    /** 系统字体*/
    private var coordinateSystemFont = UIFont.systemFontOfSize(18)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        coordinateSystemFont = UIFont.systemFontOfSize(18 - (7.5 - frame.size.width / 100.0) * 2)
        leftOffset = frame.size.width / 8.0
        rightOffset = frame.size.width / 8.0
        bottomOffset = frame.size.width / 12.0
        topOffset = frame.size.width / 12.0
    }
    func pointIsPanned(recognizer:UIPanGestureRecognizer){
        switch recognizer.state {
        case UIGestureRecognizerState.Began:
            movedCenter = personView.center
        default:
            //偏移量
            let translation = recognizer.translationInView(self)
            movedCenter.x += translation.x
            movedCenter.y += translation.y
            //随意移动到的点
            moveToPoint(movedCenter)
        }
        recognizer.setTranslation(CGPointZero, inView: self)
    }
    func moveToPoint(point:CGPoint){
        let distanceToPreviousPoint = distanceToPoint(point, offset: -1)
        let distanceToLatePoint = distanceToPoint(point, offset: 1)
        let distanceToNowPoint = distanceToPoint(point, offset: 0)
        //垂直平移
        if distanceToNowPoint <= distanceToPreviousPoint && distanceToNowPoint <= distanceToLatePoint{
            return
        }
        let direction :Int
        var distance :CGFloat
        if distanceToPreviousPoint < distanceToLatePoint{
            direction = -1
            distance = distanceToPreviousPoint
        }else{
            direction = 1
            distance = distanceToLatePoint
        }
        var  offset = direction
        while true {
            let nextOffset = offset + direction
            let nextDistance = distanceToPoint(point, offset: nextOffset)
            if nextDistance >= distance{
                break
            }
            distance = nextDistance
            offset = nextOffset
        }
        pathPointIndex += offset
        if pathPointIndex < 0{
            pathPointIndex += pathPointCount
        }else if pathPointIndex > pathPointCount{
            pathPointIndex -= pathPointCount
        }
        personView.center = pathPointsArr[pathPointIndex]
        //personLayer.position = pathPointsArr[pathPointIndex]
        print("index:\(pathPointIndex)-point:\(personView.center)")
        
        
    }
    //求得相邻index的两点之间的间距
    func distanceToPoint(nowPoint:CGPoint,offset:Int) -> CGFloat{
        var index = pathPointIndex + offset
        if index < 0{
            index += pathPointCount
        }else if index >= pathPointCount{
            index -= pathPointCount
        }
        let point = pathPointsArr[index]
        return CGFloat(hypotf(Float(nowPoint.x - point.x), Float(nowPoint.y - point.y)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK:drawRect
    override func drawRect(rect: CGRect) {
        let sublayers = self.layer.sublayers
        if sublayers != nil {
            for i in 0..<sublayers!.count {
                sublayers![i].removeFromSuperlayer()
            }
        }
        let subviews = self.subviews
        for i in 0..<subviews.count {
                subviews[i].removeFromSuperview()
            }
        
        contextRef = UIGraphicsGetCurrentContext()
        creatCoordinateSystem()
        addDataCurve()
        tipAndlineMeaningText()
    }
    //将chart中的坐标值转换成在view中的point值
    func convertRealValueToCoordinate(valueX:CGFloat,valueY:CGFloat) -> CGPoint{
        let xRangeValue = xMaxValue - xMinValue
        let xRealRangeValue = valueX - xMinValue
        let coordinateX = xRealRangeValue / xRangeValue * (self.frame.size.width - leftOffset - rightOffset) + leftOffset
        let yRangeValue = yMaxValue - yMinValue
        let yRealRangeValue = valueY - yMinValue
        let coordinateY = ((yRangeValue - yRealRangeValue) / yRangeValue) * (self.frame.size.height - topOffset - bottomOffset) + topOffset
        return CGPointMake(coordinateX, coordinateY)
    }
    //取得两点的中点
    func getMidPointOfTwoPoint(pointA:CGPoint, pointB:CGPoint) -> CGPoint{
        return CGPointMake((pointA.x + pointB.x) / 2, (pointA.y + pointB.y) / 2)
    }
    //MARK:创建坐标系中的线和单元标识
    func creatCoordinateSystem(){
        //横
        for i in 0..<horizontalNumber{
            if i != horizontalNumber - 1 {
                //画虚线
                if i != 0 {
                    //                    CGContextSetStrokeColorWithColor(contextRef, dashLineColor.CGColor)
                    //                    CGContextSetLineWidth(contextRef, 2.0)
                    //                    let lengths:[CGFloat] = [3,3]
                    //                    CGContextSetLineDash(contextRef, 0, lengths, 2)
                    //                    CGContextMoveToPoint(contextRef, leftOffset, topOffset + CGFloat(i) * (self.frame.size.height - topOffset - bottomOffset) / (CGFloat(horizontalNumber) - 1))
                    //                    CGContextAddLineToPoint(contextRef, self.frame.size.width - rightOffset, topOffset + CGFloat(i) * (self.frame.size.height - topOffset - bottomOffset) / (CGFloat(horizontalNumber) - 1))
                    //                    CGContextStrokePath(contextRef)
                    //
                    let textLayer = CATextLayer.init()
                    textLayer.fontSize = coordinateSystemFont.pointSize
                    let rect = yAxisWidthString.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
                    if i % 2 != 0 {
                        textLayer.frame = rect
                        textLayer.font = "HiraKakuProN-W3"
                        textLayer.anchorPoint = CGPointMake(0.5, 0.5)
                        textLayer.alignmentMode = kCAAlignmentRight
                        textLayer.backgroundColor = UIColor.clearColor().CGColor
                        textLayer.foregroundColor = UIColor.blackColor().CGColor
                        textLayer.position = CGPointMake(leftOffset - rect.size.width / 2 - yStringOffset, topOffset + CGFloat(i) * (self.frame.size.height - topOffset - bottomOffset) / (CGFloat(horizontalNumber) - 1))
                        textLayer.string = yAxisNumbers[i]
                        self.layer.addSublayer(textLayer)
                    }
                }else{
                    let textLayer = CATextLayer.init()
                    textLayer.fontSize = coordinateSystemFont.pointSize
                    let rect = yAxisWidthString.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
                    textLayer.frame = rect
                    textLayer.font = "HiraKakuProN-W3"
                    textLayer.anchorPoint = CGPointMake(0.5, 0.5)
                    textLayer.alignmentMode = kCAAlignmentRight
                    textLayer.backgroundColor = UIColor.clearColor().CGColor
                    textLayer.foregroundColor = UIColor.blackColor().CGColor
                    textLayer.position = CGPointMake(leftOffset - rect.size.width / 2 - yStringOffset, topOffset)
                    textLayer.string = yAxisNumbers[0]
                    self.layer.addSublayer(textLayer)
                }
                //x轴线,画实线
            }else{
                CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor)
                CGContextSetLineWidth(contextRef, 3.0)
                let lengths:[CGFloat] = [3,3]
                CGContextSetLineDash(contextRef, 0, lengths, 0)
                let tx = self.frame.size.height - topOffset - bottomOffset
                CGContextMoveToPoint(contextRef, leftOffset, topOffset + CGFloat(i) * tx / (CGFloat(horizontalNumber) - 1))
                CGContextAddLineToPoint(contextRef, self.frame.size.width - rightOffset, topOffset + CGFloat(i) * (self.frame.size.height - topOffset - bottomOffset) / (CGFloat(horizontalNumber) - 1))
                CGContextStrokePath(contextRef)
                //
                let textLayer = CATextLayer.init()
                textLayer.fontSize = coordinateSystemFont.pointSize
                let rect = yAxisWidthString.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
                textLayer.frame = rect
                textLayer.font = "HiraKakuProN-W3"
                textLayer.anchorPoint = CGPointMake(0.5, 0.5)
                textLayer.alignmentMode = kCAAlignmentRight
                textLayer.backgroundColor = UIColor.clearColor().CGColor
                textLayer.foregroundColor = UIColor.blackColor().CGColor
                textLayer.position = CGPointMake(leftOffset - rect.size.width / 2 - yStringOffset, topOffset + CGFloat(i) * (self.frame.size.height - topOffset - bottomOffset) / (CGFloat(horizontalNumber) - 1))
                textLayer.string = yAxisNumbers.last
                self.layer.addSublayer(textLayer)
                
            }
        }
        let yUnitTextLayer = CATextLayer.init()
        yUnitTextLayer.fontSize = coordinateSystemFont.pointSize
        let rect = (yUnitString+"A").boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
        let yNumberRect = (yAxisNumbers.first! + "A").boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
        
        yUnitTextLayer.frame = rect
        //            unitTextLayer.font = "HiraKakuProN-W3"
        yUnitTextLayer.anchorPoint = CGPointMake(0.5, 0.5)
        yUnitTextLayer.alignmentMode = kCAAlignmentCenter
        yUnitTextLayer.backgroundColor = UIColor.clearColor().CGColor
        yUnitTextLayer.foregroundColor = UIColor.blackColor().CGColor
        var yUnitPositionX = leftOffset - yNumberRect.width - rect.height / 2 - yStringOffset
        if yUnitPositionX < (rect.size.height / 2.0) {
            yUnitPositionX = (rect.size.height / 2.0)
        }
        let yUnitPositionY = topOffset + CGFloat(yAxisNumbers.count / 2) * (self.frame.size.height - topOffset - bottomOffset) / (CGFloat(horizontalNumber) - 1)
        yUnitTextLayer.position = CGPointMake(yUnitPositionX,yUnitPositionY)
        yUnitTextLayer.string = yUnitString
        yUnitTextLayer.contentsScale = UIScreen.mainScreen().scale
        yUnitTextLayer.transform = CATransform3DRotate(yUnitTextLayer.transform, CGFloat(-M_PI_2), 0, 0, 1)
        self.layer.addSublayer(yUnitTextLayer)
        //竖
        for i in 0..<verticalNumber{
            if i != 0 {
                if i != verticalNumber - 1  {
                    //                    CGContextSetStrokeColorWithColor(contextRef, dashLineColor.CGColor)
                    //                    CGContextSetLineWidth(contextRef, 2.0)
                    //                    let lengths:[CGFloat] = [3,3]
                    //                    CGContextSetLineDash(contextRef, 0, lengths, 2)
                    //                    CGContextMoveToPoint(contextRef,leftOffset + CGFloat(i) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1), topOffset)
                    //                    CGContextAddLineToPoint(contextRef, leftOffset + CGFloat(i) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1), self.frame.size.height - bottomOffset)
                    //                    CGContextStrokePath(contextRef)
                    
                    //
                    let textLayer = CATextLayer.init()
                    textLayer.fontSize = coordinateSystemFont.pointSize
                    let rect = xAxisWidthString.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
                    textLayer.frame = rect
                    textLayer.font = "HiraKakuProN-W3"
                    textLayer.anchorPoint = CGPointMake(0.5, 0.5)
                    textLayer.alignmentMode = kCAAlignmentCenter
                    textLayer.backgroundColor = UIColor.clearColor().CGColor
                    textLayer.foregroundColor = UIColor.blackColor().CGColor
                    textLayer.position = CGPointMake(leftOffset + CGFloat(i) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1),self.frame.size.height - bottomOffset + rect.size.width / 2)
                    textLayer.string = xAxisNumbers[i]
                    self.layer.addSublayer(textLayer)
                }else{
                    let textLayer = CATextLayer.init()
                    textLayer.fontSize = coordinateSystemFont.pointSize
                    let rect = xAxisWidthString.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
                    textLayer.frame = rect
                    textLayer.font = "HiraKakuProN-W3"
                    textLayer.anchorPoint = CGPointMake(0.5, 0.5)
                    textLayer.alignmentMode = kCAAlignmentCenter
                    textLayer.backgroundColor = UIColor.clearColor().CGColor
                    textLayer.foregroundColor = UIColor.blackColor().CGColor
                    textLayer.position = CGPointMake(leftOffset + CGFloat(i) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1),self.frame.size.height - bottomOffset + rect.size.width / 2)
                    textLayer.string = xAxisNumbers[i]
                    self.layer.addSublayer(textLayer)
                }
            }else if i == 0{
                CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor)
                CGContextSetLineWidth(contextRef, 3.0)
                let lengths:[CGFloat] = [3,3]
                CGContextSetLineDash(contextRef, 0, lengths, 0)
                CGContextMoveToPoint(contextRef,leftOffset + CGFloat(i) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1), topOffset)
                CGContextAddLineToPoint(contextRef, leftOffset + CGFloat(i) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1), self.frame.size.height - bottomOffset)
                CGContextStrokePath(contextRef)
            }
            let unitTextLayer = CATextLayer.init()
            unitTextLayer.fontSize = coordinateSystemFont.pointSize
            let rect = (xUnitString + "A").boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
            unitTextLayer.frame = rect
//            unitTextLayer.font = "HiraKakuProN-W3"
            unitTextLayer.anchorPoint = CGPointMake(0.5, 0.5)
            unitTextLayer.alignmentMode = kCAAlignmentCenter
            unitTextLayer.backgroundColor = UIColor.clearColor().CGColor
            unitTextLayer.foregroundColor = UIColor.blackColor().CGColor
            let tx = CGFloat(xAxisNumbers.count - 1) * (self.frame.size.width - leftOffset - rightOffset) / CGFloat(verticalNumber - 1)
            let xNumberRect = (xAxisNumbers.last! + "A").boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:coordinateSystemFont], context: nil)
            let x = leftOffset + xNumberRect.width / 2.0 + rect.width/2.0  + tx
            let y = self.frame.size.height - bottomOffset + rect.size.width / 2
            unitTextLayer.position = CGPointMake(x,y)
            unitTextLayer.string = xUnitString
            unitTextLayer.contentsScale = UIScreen.mainScreen().scale
            self.layer.addSublayer(unitTextLayer)
        }
    }
    //MARK:添加两条数据曲线和数据点,文字layer,连接文字layer的虚线
    func addDataCurve(){
        //画数据线1
        let bezierPath = UIBezierPath.init()
        //开始点
        let blueLineStartPoint = convertRealValueToCoordinate(1, valueY: 100)
        //四个数据点
        let blueLinePointOne = convertRealValueToCoordinate(20, valueY: 99)
        let blueLinePointTwo = convertRealValueToCoordinate(40, valueY: 95)
        let blueLinePointThree = convertRealValueToCoordinate(60, valueY: 88)
        let blueLinePointFour = convertRealValueToCoordinate(85, valueY: 75)
        //结束点
        let blueLinePointFive = convertRealValueToCoordinate(110, valueY: 60)
        let midOne = getMidPointOfTwoPoint(blueLineStartPoint, pointB: blueLinePointOne)
        let midTwo = getMidPointOfTwoPoint(blueLinePointOne, pointB: blueLinePointTwo)
        let midThree = getMidPointOfTwoPoint(blueLinePointTwo, pointB: blueLinePointThree)
        let midFour = getMidPointOfTwoPoint(blueLinePointThree, pointB: blueLinePointFour)
        let midFive = getMidPointOfTwoPoint(blueLinePointFour, pointB: blueLinePointFive)
        bezierPath.moveToPoint(blueLineStartPoint)
        bezierPath.addQuadCurveToPoint(midOne, controlPoint: getMidPointOfTwoPoint(blueLineStartPoint,pointB: midOne))
        bezierPath.addQuadCurveToPoint(midTwo, controlPoint: blueLinePointOne)
        bezierPath.addQuadCurveToPoint(midThree, controlPoint: blueLinePointTwo)
        bezierPath.addQuadCurveToPoint(midFour, controlPoint: blueLinePointThree)
        bezierPath.addQuadCurveToPoint(midFive, controlPoint: blueLinePointFour)
        bezierPath.addQuadCurveToPoint(blueLinePointFive, controlPoint: getMidPointOfTwoPoint(midFive, pointB: blueLinePointFive))
        
        let curveLayer = CAShapeLayer()
        curveLayer.frame = bounds
        curveLayer.fillColor = UIColor.clearColor().CGColor
        curveLayer.strokeColor = UIColor.blackColor().CGColor
        curveLayer.lineCap = kCALineCapRound
        curveLayer.lineWidth = convertRealValueToCoordinate(1, valueY: 10).x - leftOffset
        curveLayer.path = bezierPath.CGPath
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.init(red: 0 / 255.0, green: 191 / 255.0, blue: 255 / 255.0, alpha: 1.0).CGColor,UIColor.init(red: 30 / 255.0, green: 144 / 255.0, blue: 255 / 255.0, alpha: 1.0).CGColor,UIColor.init(red: 0 / 255.0, green: 0 / 255.0, blue: 139 / 255.0, alpha: 1.0).CGColor]
        gradientLayer.locations = [0.1, 0.5, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = curveLayer
        self.layer.addSublayer(gradientLayer)
        //        CGContextSetStrokeColorWithColor(contextRef, UIColor.blueColor().CGColor)
        //        CGContextSetFillColorWithColor(contextRef, UIColor.redColor().CGColor)
        //        CGContextSetLineWidth(contextRef, 2)
        //        CGContextAddArc(contextRef, blueLinePointOne.x, blueLinePointOne.y, 20, 0, CGFloat(M_PI * 2), 0)
        //        CGContextDrawPath(contextRef, .FillStroke)
        
        //画数据线1上的各个数据点
        let radius = convertRealValueToCoordinate(1, valueY: 10).x - leftOffset
        
        let pointLayer1 = addSolidPointInCurve(radius/3.0, fillColor: UIColor.whiteColor(), strokeColor: UIColor.init(red: 100 / 255.0, green: 149 / 255.0, blue: 237 / 255.0, alpha: 1.0), center: blueLinePointOne, radius: radius)
        self.layer.addSublayer(pointLayer1)
        let pointLayer2 = addSolidPointInCurve(radius/3.0, fillColor: UIColor.whiteColor(), strokeColor: UIColor.init(red: 100 / 255.0, green: 149 / 255.0, blue: 237 / 255.0, alpha: 1.0), center: blueLinePointTwo, radius: radius)
        self.layer.addSublayer(pointLayer2)
        let pointLayer3 = addSolidPointInCurve(radius/3.0, fillColor: UIColor.whiteColor(), strokeColor: UIColor.init(red: 100 / 255.0, green: 149 / 255.0, blue: 237 / 255.0, alpha: 1.0), center: blueLinePointThree, radius: radius)
        self.layer.addSublayer(pointLayer3)
        let pointLayer4 = addSolidPointInCurve(radius/3.0, fillColor: UIColor.whiteColor(), strokeColor: UIColor.init(red: 100 / 255.0, green: 149 / 255.0, blue: 237 / 255.0, alpha: 1.0), center: blueLinePointFour, radius: radius)
        self.layer.addSublayer(pointLayer4)
        
        //画数据线2
        let typicalBezierPath = UIBezierPath.init()
        let typicalStartPoint = convertRealValueToCoordinate(1, valueY: 100)
        let typicalPointOne = convertRealValueToCoordinate(50, valueY: 100)
        let typicalPointTwo = convertRealValueToCoordinate(70, valueY: 10)
        let typicalPointThree = convertRealValueToCoordinate(110, valueY: 11)
        typicalBezierPath.moveToPoint(typicalStartPoint)
        typicalBezierPath.addCurveToPoint(typicalPointThree, controlPoint1: typicalPointOne, controlPoint2: typicalPointTwo)
        
        let length:[CGFloat] = [1.0,1.0]
        let cgDashedPath = CGPathCreateCopyByDashingPath(typicalBezierPath.CGPath, nil, 0, length, 2)
        let pointPath = UIBezierPath.init(CGPath: cgDashedPath!)
        for i in 0..<pointPath.elements.count {
            pathPointsArr.append(pointPath.elements[i].pointsArr[0])
        }
        pathPointIndex = 0
        pathPointCount = pathPointsArr.count
        
        
        let typicalCurveLayer = CAShapeLayer()
        typicalCurveLayer.frame = bounds
        typicalCurveLayer.fillColor = UIColor.clearColor().CGColor
        typicalCurveLayer.strokeColor = UIColor.blackColor().CGColor
        typicalCurveLayer.lineCap = kCALineCapRound
        typicalCurveLayer.lineWidth = convertRealValueToCoordinate(1, valueY: 10).x - leftOffset
        typicalCurveLayer.path = typicalBezierPath.CGPath
        let typicalGradientLayer = CAGradientLayer()
        typicalGradientLayer.frame = self.bounds
        typicalGradientLayer.colors = [UIColor.init(red: 0 / 255.0, green: 191 / 255.0, blue: 255 / 255.0, alpha: 1.0).CGColor,UIColor.init(red: 255 / 255.0, green: 165 / 255.0, blue: 0 / 255.0, alpha: 1.0).CGColor,UIColor.init(red: 139 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0).CGColor]
        typicalGradientLayer.locations = [0.1, 0.5, 0.9]
        typicalGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        typicalGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        typicalGradientLayer.mask = typicalCurveLayer
        self.layer.addSublayer(typicalGradientLayer)
        
        let personViewRadius = (convertRealValueToCoordinate(7, valueY: 10).x - leftOffset) / 2.0
        personView = UIView.init(frame: CGRectMake(0, 0, personViewRadius * 2, personViewRadius * 2))

        personView.backgroundColor = UIColor.clearColor()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(pointIsPanned(_:)))
        personView.addGestureRecognizer(gesture)
        self.addSubview(personView)
        personView.center = pathPointsArr[0]
        
        //设置可以移动的个人头像
        let myPersonLayer = CALayer()
        myPersonLayer.backgroundColor = UIColor.whiteColor().CGColor
        myPersonLayer.frame = personView.bounds
        myPersonLayer.contents = UIImage.init(named: "smile")!.CGImage
        myPersonLayer.cornerRadius = personView.bounds.size.width / 2.0
        myPersonLayer.masksToBounds = false
        myPersonLayer.borderColor = UIColor.init(red: 255 / 255.0, green: 165 / 255.0, blue: 0, alpha: 1.0).CGColor
        myPersonLayer.borderWidth = personViewRadius / 10.0
        myPersonLayer.shadowOffset = CGSizeMake(0, personViewRadius / 10.0); //设置阴影的偏移量
        myPersonLayer.shadowColor = UIColor.blackColor().CGColor; //设置阴影的颜色为黑色
        myPersonLayer.shadowOpacity = 0.9; //设置阴影的不透明度
        personView.layer.addSublayer(myPersonLayer)
        
        //文本框layer
        let point1 = convertRealValueToCoordinate(25, valueY: 26)
        let point2 = convertRealValueToCoordinate(34, valueY: 26)
        let textWH1 = CGPointMake(point1.x - leftOffset, frame.size.height - point1.y - bottomOffset)
        let textWH2 = CGPointMake(point2.x - leftOffset, frame.size.height - point2.y - bottomOffset)
        
        //第一个文本框中的文字
        let textlayerOfPoint1 = creatTextLayer(textWH1, position: convertRealValueToCoordinate(15,valueY: 75), alignmentMode: kCAAlignmentCenter, textString: "Optimal Health & Vitality", fontSize: coordinateSystemFont.pointSize - 2, textColor: UIColor.blackColor(), isWrapped: true, backgroundColor: UIColor.init(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1.0), borderColor: UIColor.init(red: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 1.0),borderWidth: 3)
        self.layer.addSublayer(textlayerOfPoint1)
        //第二个文本框中的文字
        let textlayerOfPoint2 = creatTextLayer(textWH1, position: convertRealValueToCoordinate(17,valueY: 55), alignmentMode: kCAAlignmentCenter, textString: "Declining Health", fontSize: coordinateSystemFont.pointSize - 2, textColor: UIColor.blackColor(), isWrapped: true, backgroundColor: UIColor.init(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0), borderColor: UIColor.init(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0),borderWidth: 3)
        self.layer.addSublayer(textlayerOfPoint2)
        //第三个文本框中的文字
        let textlayerOfPoint3 = creatTextLayer(textWH1, position: convertRealValueToCoordinate(19,valueY: 35), alignmentMode: kCAAlignmentCenter, textString: "Poor Health", fontSize: coordinateSystemFont.pointSize - 2, textColor: UIColor.blackColor(), isWrapped: true, backgroundColor: UIColor.init(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0), borderColor: UIColor.init(red: 255/255.0, green: 185/255.0, blue: 15/255.0, alpha: 1.0),borderWidth: 3)
        self.layer.addSublayer(textlayerOfPoint3)
        //第四个文本框中的文字
        let textlayerOfPoint4 = creatTextLayer(textWH2, position: convertRealValueToCoordinate(50,valueY: 25), alignmentMode: kCAAlignmentCenter, textString: "Progressive & Chronic Disability", fontSize: coordinateSystemFont.pointSize - 2, textColor: UIColor.blackColor(), isWrapped: true,backgroundColor: UIColor.init(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1.0),borderColor: UIColor.init(red: 205/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),borderWidth: 3)//CALayer()
        self.layer.addSublayer(textlayerOfPoint4)
        
        //画连接文字label的虚线
        let lengths:[CGFloat] = [3,3]
        CGContextSetStrokeColorWithColor(contextRef, dashLineColor.CGColor)
        CGContextSetLineWidth(contextRef, 2.0)
        CGContextSetLineDash(contextRef, 0, lengths, 2)
        dottedLineOfConnection(contextRef, startPoint: blueLinePointOne, endLayer: textlayerOfPoint1)
        dottedLineOfConnection(contextRef, startPoint: blueLinePointTwo, endLayer: textlayerOfPoint2)
        dottedLineOfConnection(contextRef, startPoint: blueLinePointThree, endLayer: textlayerOfPoint3)
        dottedLineOfConnection(contextRef, startPoint: blueLinePointFour, endLayer: textlayerOfPoint4)
    }
    //MARK: 个人标注和曲线标注文字
    func tipAndlineMeaningText(){
        
        let radius = convertRealValueToCoordinate(5, valueY: 10).x - leftOffset
        let personPointLayer = addImagePointInCurve(radius, position: convertRealValueToCoordinate(75,valueY: 95), image: UIImage.init(named: "smile")!, borderColor: UIColor.init(red: 34 / 255.0, green: 139 / 255.0, blue: 34 / 255.0, alpha: 1.0))
        self.layer.addSublayer(personPointLayer)
        
        let tipRect = (tipString+"A").boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(coordinateSystemFont.pointSize + 2)], context: nil)
        let textWH1 = CGPointMake(tipRect.width, tipRect.height)
        
        
        //tip的文字说明
        let textlayerOfTip = creatTextLayer(textWH1, position: CGPointMake(personPointLayer.position.x + personPointLayer.frame.size.width / 2 + textWH1.x / 2, personPointLayer.position.y), alignmentMode: kCAAlignmentCenter, textString: "You are here", fontSize: coordinateSystemFont.pointSize + 2, textColor: UIColor.init(red: 34 / 255.0, green: 139 / 255.0, blue: 34 / 255.0, alpha: 1.0), isWrapped: false,backgroundColor: UIColor.clearColor(),borderColor: UIColor.clearColor(),borderWidth: 0)
        self.layer.addSublayer(textlayerOfTip)
        
        let curvePoint = convertRealValueToCoordinate(32, valueY: 25)
        let textWH2 = CGPointMake(curvePoint.x - leftOffset, frame.size.height - curvePoint.y - bottomOffset)
        
        //第一条曲线的文字说明
        let textlayerOfCurve1 = creatTextLayer(textWH2, position:convertRealValueToCoordinate(105.0,valueY: 50.0), alignmentMode: kCAAlignmentLeft, textString: "Blue Zone Lifeline (Aspiration)", fontSize: coordinateSystemFont.pointSize + 1, textColor: UIColor.init(red: 0 / 255.0, green: 191 / 255.0, blue: 255 / 255.0, alpha: 1.0), isWrapped: true,backgroundColor: UIColor.clearColor(),borderColor: UIColor.clearColor(),borderWidth: 0)
        self.layer.addSublayer(textlayerOfCurve1)
        //第二条曲线的文字说明
        let textlayerOfCurve2 = creatTextLayer(textWH2, position: convertRealValueToCoordinate(105.0,valueY: 25.0), alignmentMode: kCAAlignmentLeft, textString: "Typical Lifeline (Status Quo)", fontSize: coordinateSystemFont.pointSize + 1, textColor: UIColor.init(red: 220 / 255.0, green: 20 / 255.0, blue: 60 / 255.0, alpha: 1.0), isWrapped: true, backgroundColor: UIColor.clearColor(), borderColor: UIColor.clearColor(),borderWidth: 0)
        self.layer.addSublayer(textlayerOfCurve2)
    }
    //创建文字
    func creatTextLayer(weightAndHeight:CGPoint,position:CGPoint,alignmentMode:String,textString:String,fontSize:CGFloat,textColor:UIColor,isWrapped:Bool,backgroundColor:UIColor,borderColor:UIColor,borderWidth:CGFloat) -> CALayer{
        let layer = CALayer()
        layer.bounds = CGRectMake(0, 0, weightAndHeight.x,weightAndHeight.y)
        layer.position = position
        layer.backgroundColor = backgroundColor.CGColor
        layer.cornerRadius = 4
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
        let text = CATextLayer()
        text.frame = CGRectMake(borderWidth, borderWidth, layer.bounds.width - borderWidth * 2, layer.bounds.height - borderWidth * 2)
        text.alignmentMode = alignmentMode
        text.backgroundColor = UIColor.clearColor().CGColor
        text.foregroundColor = textColor.CGColor
        text.fontSize = fontSize
        text.string = textString
        text.wrapped = isWrapped
        text.truncationMode = kCATruncationEnd
        //匹配屏幕像素
        text.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(text)
        return layer
    }
    //画虚线
    func dottedLineOfConnection(context:CGContext,startPoint:CGPoint,endLayer:CALayer){
        CGContextMoveToPoint(context, startPoint.x,startPoint.y + 6)
        CGContextAddLineToPoint(contextRef, startPoint.x ,endLayer.position.y - endLayer.frame.size.height / 2.0)
        CGContextAddArc(context, startPoint.x - endLayer.frame.size.height / 6.0, endLayer.position.y - endLayer.frame.size.height / 2.0, endLayer.frame.size.height / 6.0, 0, CGFloat(M_PI_2), 0)
        CGContextAddLineToPoint(context, endLayer.position.x + endLayer.frame.size.width / 2.0, endLayer.position.y - endLayer.frame.size.height / 2.0 + endLayer.frame.size.height / 6.0)
        CGContextStrokePath(context)
    }
    //实心点
    func addSolidPointInCurve(lineWidth:CGFloat,fillColor:UIColor,strokeColor:UIColor,center:CGPoint,radius:CGFloat) -> CAShapeLayer{
        let pointLayer = CAShapeLayer()
        pointLayer.lineWidth = lineWidth
        pointLayer.fillColor = fillColor.CGColor
        pointLayer.strokeColor = strokeColor.CGColor
        let pointPath = UIBezierPath()
        pointPath.addArcWithCenter(center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        pointLayer.path = pointPath.CGPath
        pointLayer.shadowOffset = CGSizeMake(0, 2); //设置阴影的偏移量
        pointLayer.shadowColor = UIColor.blackColor().CGColor; //设置阴影的颜色为黑色
        pointLayer.shadowOpacity = 0.9; //设置阴影的不透明度
        return pointLayer
    }
    //图像点
    func addImagePointInCurve(radius:CGFloat,position:CGPoint,image:UIImage,borderColor:UIColor) -> CALayer{
        let pointLayer = CALayer()
        pointLayer.backgroundColor = UIColor.whiteColor().CGColor
        pointLayer.bounds = CGRectMake(0, 0, radius * 2, radius * 2)
        pointLayer.position = position
        pointLayer.contents = image.CGImage
        pointLayer.cornerRadius = radius
        pointLayer.masksToBounds = false
        pointLayer.borderColor = borderColor.CGColor
        pointLayer.borderWidth = radius / 10.0
        pointLayer.shadowOffset = CGSizeMake(0, 4 - radius / 10.0); //设置阴影的偏移量
        pointLayer.shadowColor = UIColor.blackColor().CGColor; //设置阴影的颜色为黑色
        pointLayer.shadowOpacity = 0.9; //设置阴影的不透明度
        return pointLayer
    }
   
}
