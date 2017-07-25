//
//  MHPieChartView.swift
//  ANBookPad
//
//  Created by dingf on 16/9/19.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
//required and optional 依赖oc？
@objc protocol MHPieChartViewDataSource {
    func numberOfSliceInPieChart(pieChart: MHPieChartView) -> Int
    func valueInSliceOfChartAtIndex(chart:MHPieChartView ,index: Int) -> Double
    optional func colorForSliceOfChartAtIndex(chart:MHPieChartView ,index: Int) -> UIColor
    optional func textForSliceOfChartAtIndex(chart:MHPieChartView ,index: Int) -> String
}

@objc protocol MHPieChartViewDelegate {
    optional func willSelectChartAtIndex(chart:MHPieChartView, index:Int)
    optional func didSelectChartAtIndex(chart:MHPieChartView, index:Int)
    optional func willDeselectChartAtIndex(chart:MHPieChartView, index:Int)
    optional func didDeselectChartAtIndex(chart:MHPieChartView, index:Int)
}

class pieSliceLayer: CAShapeLayer {
    var value :Double!
    var percentage :Double!
    var startAngle :Double!
    var endAngle :Double!
    var isSelected  = false
    var text :String!
    func creatArcAnimationForKey(key:String, fromValue:NSNumber, toValue:NSNumber, delegate:AnyObject){
        let arcAnimation = CABasicAnimation.init(keyPath: key)
        arcAnimation.fromValue = fromValue
        arcAnimation.toValue = toValue
        arcAnimation.delegate = delegate
        //控制动画节奏
        arcAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        self.addAnimation(arcAnimation, forKey: key)
        self.setValue(toValue, forKey: key)
    }
}

func CGPathCreatArc(center:CGPoint ,radius:CGFloat ,startAngle:CGFloat ,endAngle:CGFloat) -> CGPathRef {
    let path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, center.x, center.y)
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, false)
    CGPathCloseSubpath(path)
    return path
}

class MHPieChartView: UIView,UIGestureRecognizerDelegate {
    //私有属性
    private var _pieCenter = CGPointMake(0, 0)
    private var _pieRadius:CGFloat = 0
    private var _rotationAngle:Double = 0
    private var _whetherShowName = true
    private var isRotating = false
    private var pieView :UIView!
    private var centerView :UIView!
    private var selectedSliceIndex :Int!
    //和屏幕刷新率相同的定时器
    private var displayLink :CADisplayLink?
    private var animations = [CAAnimation]()
    private var _centerLabelText = ""
    
    var pieDelegate :MHPieChartViewDelegate!
    var pieDataSource :MHPieChartViewDataSource!
    var labelStringArr = [String]()
    var centerLabelFont = UIFont.systemFontOfSize(25.0)
    var centerLabelText :String{
        set{
            _centerLabelText = newValue
            let textLayer = centerView.layer.sublayers![0] as! CATextLayer
            textLayer.string = _centerLabelText
            let size = _centerLabelText.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), options: .TruncatesLastVisibleLine, attributes: [NSFontAttributeName:centerLabelFont], context: nil)
            textLayer.frame = CGRectMake(0, 0, size.width + 20, size.height)
            textLayer.position = CGPointMake(centerView.frame.size.width / 2, centerView.frame.size.width / 2)
        }
        get{
            return _centerLabelText
        }
    }

    //初始旋转的角度
    var pieInitAngle :Double!
    //初始动画的速度
    var pieAnimationDuration :Double!
    //可以修改pieView的半径
    var pieRadius:CGFloat {
        get{
            return _pieRadius
        }
        set{
            _pieRadius = newValue
            //改pieRadius就是将pieView改成圆
            let frame = CGRectMake(pieView.frame.origin.x + pieCenter.x - _pieRadius, pieView.frame.origin.y + pieCenter.y - _pieRadius, _pieRadius * 2, _pieRadius * 2)
            pieView.frame = frame
            pieView.layer.cornerRadius = _pieRadius
        }
    }
    //可以修改pieView在视图中的中心位置
    var pieCenter:CGPoint {
        get{
            return _pieCenter
        }
        set{
            //改pieCenter就是改变pieView的center
            //输出pieCenter是pieView相对于自身的center
            pieView.center = newValue
            _pieCenter = CGPointMake(pieView.frame.size.width / 2, pieView.frame.size.height / 2)
        }
    }
    //点击偏移的边框线粗
    var offsetLineWidth :CGFloat!
    //点击偏移的距离
    var pieSelectSliceOffset :CGFloat = 0
    var whetherShowName :Bool{
        get{
            return _whetherShowName
        }
        set{
            _whetherShowName = newValue
//            for layer in pieView.layer.sublayers!{
//                let pieLayer = layer as! pieSliceLayer
//                
//                let textLayer = layer.sublayers![0] as! CATextLayer
//                textLayer.string = labelStringArr
//                
//                
//                
//            
//            
//            
//            }
        
        }
    }
    
    //    var pieIfShowLabel :Bool!
        var pieLabelFont = UIFont.systemFontOfSize(15.0)
        var pieLabelColor = UIColor.whiteColor()
        var pieLabelShadowColor = UIColor.grayColor()
    //    var pieLabelRadius :CGFloat!
    //    var pieShowPercentage :Bool!
    
    //重写初始化方法，直接生成内含圆
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.pieView = UIView.init(frame: frame)
        pieView.backgroundColor = UIColor.clearColor()
        self.addSubview(pieView)
        //初始的设定值
        pieAnimationDuration = 1.0
        pieInitAngle = M_PI_2 * 3
        offsetLineWidth = 3.0
        pieSelectSliceOffset = 20.0
        pieRadius = min(frame.size.width/2, frame.size.height/2)
        pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2)
        
        centerView = UIView.init(frame: CGRectMake(0, 0, pieRadius, pieRadius))
        centerView.center = CGPointMake(frame.size.width/2, frame.size.height/2)
        centerView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.9)
        centerView.layer.cornerRadius = centerView.frame.size.width / 2
        
        let centerTextLayer = CATextLayer.init()
        centerTextLayer.anchorPoint = CGPointMake(0.5, 0.5)
        let string = NSString.init(string: _centerLabelText)
        let size = string.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), options: .TruncatesLastVisibleLine, attributes: [NSFontAttributeName:centerLabelFont], context: nil)
        centerTextLayer.alignmentMode = kCAAlignmentCenter
        centerTextLayer.frame = CGRectMake(0, 0, size.width + 20, size.height)
        centerTextLayer.backgroundColor = UIColor.clearColor().CGColor
        centerTextLayer.fontSize = centerLabelFont.pointSize
        centerTextLayer.foregroundColor = UIColor.blackColor().CGColor
        centerTextLayer.font = "HiraKakuProN-W3"
        centerTextLayer.string = string
        //centerTextLayer.zPosition = 100
        centerView.layer.addSublayer(centerTextLayer)
        centerTextLayer.position = CGPointMake(centerView.frame.size.width / 2, centerView.frame.size.width / 2)
        self.addSubview(centerView)
        
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        if pieDataSource != nil{
            //开一个定时器,初始关
            displayLink = CADisplayLink.init(target: self, selector: #selector(update))
            displayLink!.paused = true
            displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            
            //主层
            let parentLayer = pieView.layer
            var startToAngle = 0.0
            var endToAngle = 0.0
            //总分区数
            let totalPieCount = pieDataSource.numberOfSliceInPieChart(self)
            
            //求得所有分区值的总和
            var sum = 0.0
            var valuesArr = [Double]()
            for i in 0..<totalPieCount{
                valuesArr.append(pieDataSource.valueInSliceOfChartAtIndex(self, index: i))
                sum += valuesArr[i]
            }
            
            //所有分区所占角度的数组
            var angles = [Double]()
            for i in 0..<totalPieCount{
                var percentage = 0.0
                if sum == 0 {
                    percentage = 0.0
                }else{
                    percentage = valuesArr[i] / sum
                }
                angles.append(M_PI * 2 * percentage)
            }
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(pieAnimationDuration)
            
            for i in 0..<totalPieCount{
                endToAngle += angles[i]
                let layer = self.creatSliceLayer()
                parentLayer.addSublayer(layer)
                layer.value = valuesArr[i]
                layer.percentage = (sum != 0) ? layer.value/sum : 0.0
                //每个分区的颜色
                let color = pieDataSource.colorForSliceOfChartAtIndex!(self, index: i)
                layer.fillColor = color.CGColor
                layer.creatArcAnimationForKey("startAngle", fromValue: NSNumber.init(double: pieInitAngle), toValue: NSNumber.init(double: startToAngle + pieInitAngle), delegate: self)
                layer.creatArcAnimationForKey("endAngle", fromValue: NSNumber.init(double: pieInitAngle), toValue: NSNumber.init(double: endToAngle + pieInitAngle), delegate: self)
                startToAngle = endToAngle
            }
            CATransaction.commit()
            print("结束\(CATransaction.disableActions())")
        }
    }
    //MARK: CreatSliceLayer
    func creatSliceLayer() -> pieSliceLayer{
        let pieLayer = pieSliceLayer.init()
        pieLayer.zPosition = 0
        pieLayer.strokeColor = nil
        
        let textLayer = CATextLayer.init()
        //textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.fontSize = pieLabelFont.pointSize
        textLayer.frame = CGRectMake(0, 0, 100, 50)
        textLayer.font = "HiraKakuProN-W3"
        textLayer.anchorPoint = CGPointMake(0.5, 0.5)
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.backgroundColor = UIColor.clearColor().CGColor
        textLayer.foregroundColor = pieLabelColor.CGColor
        
//        textLayer.shadowColor = pieLabelShadowColor.CGColor
//        textLayer.shadowOffset = CGSizeMake(0, -1)
//        textLayer.shadowOpacity = 1.0
//        textLayer.shadowRadius = 2.0
        
        pieLayer.addSublayer(textLayer)
        return pieLayer
    }
    
    func changePieBackgroundColor(color: UIColor){
        pieView.backgroundColor = color
    }
    //设置图层为选中状态
    func setPieAtIndexIsSelected(index:Int){
        if pieSelectSliceOffset <= 0 {
            return
        }
        //取得要设置的图层
        let layer = pieView.layer.sublayers![index] as! pieSliceLayer
        let currentPosition = layer.position
        let middleAngle = (layer.startAngle + layer.endAngle) / 2.0
        //三角函数计算新position的位置
        let newPosition = CGPointMake(currentPosition.x + pieSelectSliceOffset * CGFloat(cos(middleAngle)), currentPosition.y + pieSelectSliceOffset * CGFloat(sin(middleAngle)))
        layer.position = newPosition
        layer.isSelected = true
        
    }
    //设置图层为非选中状态
    func setPieAtIndexIsNotSelected(index: Int){
        if pieSelectSliceOffset <= 0 {
            return
        }
        let layer = pieView.layer.sublayers![index] as! pieSliceLayer
        layer.position = CGPointMake(0, 0)
        layer.isSelected = false
        
    }
    
    override func animationDidStart(anim: CAAnimation) {
        if displayLink != nil {
            displayLink!.paused = false
        }
        //动画开始，将这个animation添加到组中，方便判断动画结束
        animations.append(anim)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //动画停止，暂停定时器
        let index = animations.indexOf(anim)
        animations.removeAtIndex(index!)
        if displayLink != nil {
            displayLink!.paused = true
            //销毁定时器
            if animations.count == 0{
                displayLink!.invalidate()
                displayLink = nil
                //设置textLayer的属性
                let subLayers = pieView.layer.sublayers
                for i in 0..<subLayers!.count{
                    let layer = subLayers![i] as! pieSliceLayer
                    let textLayer = layer.sublayers![0] as! CATextLayer
                    let string = labelStringArr[i] as NSString
                    let rect = string.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options:.TruncatesLastVisibleLine, attributes: [NSFontAttributeName:pieLabelFont], context: nil)
                    textLayer.frame = CGRectMake(0, 0, rect.width + 20, rect.height)
                    textLayer.string = labelStringArr[i]
                    let presentationLayerStartAngle = layer.presentationLayer()!.valueForKey("startAngle")!.doubleValue
                    let presentationLayerEndAngle = layer.presentationLayer()!.valueForKey("endAngle")!.doubleValue
                    let midAngle = (presentationLayerStartAngle + presentationLayerEndAngle) / 2
                    textLayer.position = CGPointMake(pieCenter.x + CGFloat(2/3 * Double(pieRadius) * cos(midAngle)), pieCenter.y + CGFloat(2/3 * Double(pieRadius) * sin(midAngle)))
                }
            }
        }
    }
    //刷新
    func update(){
        print("111")
        let parentLayer = pieView.layer
        let pieLayers = parentLayer.sublayers
        if pieLayers != nil {
            for object in pieLayers!{
                let layer = object as! pieSliceLayer
                //presentationLayer是layer的显示层
                let from = layer.presentationLayer()!.valueForKey("startAngle")
                let fromAngle = from!.doubleValue
                layer.startAngle = fromAngle
                
                let to = layer.presentationLayer()!.valueForKey("endAngle")
                let toAngle = to!.doubleValue
                layer.endAngle = toAngle
                //创建pieLayerPath
                let path = CGPathCreatArc(pieCenter, radius: pieRadius, startAngle: CGFloat(fromAngle), endAngle: CGFloat(toAngle))
                layer.path = path
            }
        }
    }

    
    func setPieIfSelected(point:CGPoint){
        var transform = CGAffineTransformIdentity
        for i in 0..<pieView.layer.sublayers!.count{
            let pieLayer = pieView.layer.sublayers![i] as! pieSliceLayer
            if CGPathContainsPoint(pieLayer.path, &transform, point, false) == true{
                if pieLayer.isSelected == false {
                    pieLayer.lineWidth = offsetLineWidth
                    pieLayer.strokeColor = UIColor.whiteColor().CGColor
                    pieLayer.lineJoin = kCALineJoinBevel
                    let textLayer = pieLayer.sublayers![0] as! CATextLayer
                    textLayer.fontSize = pieLabelFont.pointSize + 6.0
                    setPieAtIndexIsSelected(i)
                }else{
                    let textLayer = pieLayer.sublayers![0] as! CATextLayer
                    textLayer.fontSize = pieLabelFont.pointSize
                    pieLayer.lineWidth = 0.0
                    setPieAtIndexIsNotSelected(i)
                }
            }else{
                let textLayer = pieLayer.sublayers![0] as! CATextLayer
                textLayer.fontSize = pieLabelFont.pointSize
                pieLayer.lineWidth = 0.0
                setPieAtIndexIsNotSelected(i)
            }
        }
    }

   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("begin")
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("move")
        if isRotating == false {
            isRotating = true
        }else{
            let touch = touches.first
            let touchLocation = touch!.locationInView(pieView)
            let previousLocation = touch!.previousLocationInView(pieView)
            let angle = atan2f(Float(touchLocation.y - pieCenter.y), Float(touchLocation.x - pieCenter.x)) - atan2f(Float(previousLocation.y - pieCenter.y), Float(previousLocation.x - pieCenter.x))
            print(angle)
            self.transform = CGAffineTransformRotate(self.transform, CGFloat(angle))
            setNeedsDisplay()
        }
    }
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isRotating == true {
            isRotating = false
//            let touch = touches.first
//            let point = touch!.locationInView(pieView)
//            let angle = atan2f(Float(point.y - pieCenter.y), Float(point.x - pieCenter.x))
//            let addAngle = angle + Float(M_PI * 0.3)
//            
//            
//            print("rotate is end")
//            let arcAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
//            print("-----\(angle)")
//            arcAnimation.fromValue = angle
//            arcAnimation.toValue = addAngle
//            arcAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
//            self.layer.addAnimation(arcAnimation, forKey: "transform.rotation.z")
          
        }else{
            let touchPoint = touches.first
            let point = touchPoint!.locationInView(pieView)
            setPieIfSelected(point)
        }
      
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print("cancel")
    }


    
    
    
    
    
    
}
