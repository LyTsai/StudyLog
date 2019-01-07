//
//  ANTreeGraphSlowAgingByDesignPlayBookController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: Model - information of this view block, may from JSON of XML
class PlayBookModel {
    // design the model
    
    // backgroundImages, leftImage(& boolean?), texts, attributes(??),
    var headerText: String? // attributed??
    var headerBackgroundImage: UIImage?
    var leftImage: UIImage?
    
    var bodyText: String?
    var bodyBackgroundImage: UIImage?
}

// MARK: the views, move to other files later if necessary
// assume the pictures are given as round, if not, do addClip later
class SimpleView : UIButton {

    let textLabel = UILabel()
    var textLabelEdgeInsets = UIEdgeInsetsZero
    
    let backgroundImageView = UIImageView()
    var backgroundEdgeInsets = UIEdgeInsetsZero
    
    func showWithText(text: NSAttributedString?, textLabelEdgeInsets: UIEdgeInsets, backgroundImage: UIImage?, backgroundEdgeInsets: UIEdgeInsets) {
        self.textLabelEdgeInsets = textLabelEdgeInsets
        self.backgroundEdgeInsets = backgroundEdgeInsets
        
        // addBackgroundImageView
        backgroundImageView.image = backgroundImage?.stretchedImage()
        addSubview(backgroundImageView)
        
        // addLabel
        textLabel.textAlignment = .Center
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2) // default
        textLabel.attributedText = text
        backgroundImageView.addSubview(textLabel)
    }
    
    // layout
    override func layoutSubviews() {
        backgroundImageView.frame = CGRect(x: backgroundEdgeInsets.left, y: backgroundEdgeInsets.top, width: bounds.width - backgroundEdgeInsets.left - backgroundEdgeInsets.right, height: bounds.height - backgroundEdgeInsets.top - backgroundEdgeInsets.bottom)
        textLabel.frame = CGRect(x: textLabelEdgeInsets.left, y: textLabelEdgeInsets.top, width: backgroundImageView.bounds.width - textLabelEdgeInsets.left - textLabelEdgeInsets.right, height: backgroundImageView.bounds.height - textLabelEdgeInsets.top - textLabelEdgeInsets.bottom)
    }
}

class PlayBookView : UIButton {
    private var width : CGFloat {
        return bounds.width
    }
    private var height : CGFloat {
        return bounds.height
    }
    
    // readonly
    let backView = SimpleView()
    let leftImageView = UIImageView()
    
    /** the top margin of SimpleView */
    var gap: CGFloat = 10.0

    var labelEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: height - 2 * gap, bottom: 0, right: 0)
    }

    func showWithleftImage(leftImage: UIImage?, text:  NSAttributedString?, labelBackgroundImage: UIImage?) {
        backView.showWithText(text, textLabelEdgeInsets: labelEdgeInsets, backgroundImage: labelBackgroundImage, backgroundEdgeInsets: UIEdgeInsets(top: gap, left: 2 * gap, bottom: gap, right: 0))
        addSubview(backView)

        backView.userInteractionEnabled = false
        
        // addImage
        leftImageView.image = leftImage
        addSubview(leftImageView)
    }
    
    // layout
    override func layoutSubviews() {
        leftImageView.frame = CGRect(x: 0, y: 0, width: height, height: height)
        backView.textLabelEdgeInsets = labelEdgeInsets
        backView.frame = self.bounds
    }
}

class CombinedView: UIButton {
    var playBookView = PlayBookView()
    var simpleView = SimpleView()
    
    // the inset of the view below
    var edgeInsets: UIEdgeInsets {
        get{
            let radius = playBookView.leftImageView.bounds.height * 0.5
            let gap = playBookView.gap
            
            let top: CGFloat = radius * 2 - gap - 5
            let left: CGFloat = radius + sqrt(abs(2 * gap * radius - gap * gap))
            let bottom: CGFloat = 0
            let right: CGFloat = 20
            
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
    
    func showWithleftImage(leftImage: UIImage?, headerText:  NSAttributedString?, headerBackgroundImage: UIImage?, bodyText:  NSAttributedString?, bodyBackgroundImage: UIImage?) {
        playBookView.showWithleftImage(leftImage, text: headerText, labelBackgroundImage: headerBackgroundImage)
        simpleView.showWithText(bodyText, textLabelEdgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), backgroundImage: bodyBackgroundImage, backgroundEdgeInsets: UIEdgeInsetsZero)
        simpleView.textLabel.textAlignment = .Left
        
        simpleView.userInteractionEnabled = false
        playBookView.userInteractionEnabled = false
        
        addSubview(simpleView)
        addSubview(playBookView)
    }
    
    override func layoutSubviews() {
        playBookView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 90)
        simpleView.backgroundEdgeInsets = edgeInsets
        simpleView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
}

// MARK: ViewController of "Slow Aging By Design Play Book"
class ANTreeGraphSlowAgingByDesignPlayBookController: ANTreeGraphNodeLineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view = linesView
        linesView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
    }

    // view blocks
    var views = [[UIView?]]()
    override func prepareGraphView() {
        for r in 0..<numberOfRows() {
            var nodes = [UIView?]()
            for c in 0..<numberOfColumns(r) {
                var nodeView = UIButton()
                let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(30)]
                let rowString = NSMutableAttributedString(string: "a quick brown fox jumps over the lazy dog")
                
                switch r {
                case 0:
                    let header = SimpleView()
                    header.showWithText(NSAttributedString(string: "This is the header", attributes: attributes), textLabelEdgeInsets: UIEdgeInsetsZero, backgroundImage: UIImage(named: "leftImage"), backgroundEdgeInsets: UIEdgeInsetsZero)
                    nodeView = header

                case 1, 2:
                    let changedView = PlayBookView()
                    rowString.addAttributes(attributes, range: NSMakeRange(0,10))
                    changedView.showWithleftImage(UIImage(named: "leftImage"), text: rowString,labelBackgroundImage: UIImage(named: "circle_round"))
                    nodeView = changedView
                case 3:
                    let rowView = SimpleView()
                    rowString.addAttributes([NSForegroundColorAttributeName: UIColor.brownColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(50)], range: NSMakeRange(8, 5))
                    rowView.showWithText(rowString, textLabelEdgeInsets: UIEdgeInsetsZero, backgroundImage: UIImage(named: "circle_round"), backgroundEdgeInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
                    nodeView = rowView
                case 4:
                    let rowView = CombinedView()
                    let bodyString = NSMutableAttributedString(attributedString: rowString)
                    bodyString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(0, 29))
                    rowView.showWithleftImage(UIImage.init(named: "leftImage"), headerText: rowString, headerBackgroundImage: UIImage(named: "circle_round"), bodyText: bodyString, bodyBackgroundImage: UIImage(named: "circle_round"))
                    nodeView = rowView
                default:
                    nodeView.backgroundColor = UIColor.blackColor()
                }

                nodeView.tag = r * 100 + c
                nodeView.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)

                linesView.addSubview(nodeView)
                nodes.append(nodeView)
            }
            views.append(nodes)
        }
    }
    
    // button action
    func buttonClicked(button: UIButton)  {
        print(button.tag)
    }
    
    
    // overall sets
    override func getNodeView(row row: Int, column: Int) -> AnyObject? {
        return views[row][column]
    }
    
    override func getTopMargin() -> CGFloat {
        return 40
    }
    
    override func getBottomMargin() -> CGFloat {
        return 40
    }
    
    override func numberOfRows() -> Int {
        return 6
    }
    
    override func numberOfColumns(row: Int) -> Int {
        switch row {
        case 0, 1 , 2, 5:
            return 1
        case 3:
            return 2
        default:
            return 3
        }
    }
    
    // rows' detail
    override func getRowSizeType(row: Int) -> SizeType {
        return .EvenDistributed
    }
    
    override func getWeight(row: Int) -> CGFloat {
        switch row {
        case 0:
            return 1
        case 1, 2, 5:
            return 1.5
        case 3:
            return 1.8
        default:
            return 2.5
        }
    }
    override func getRowGap() -> CGFloat {
        return 10
    }
    
    override func getAlignment(row: Int) -> Alignment {
        return .Center
    }
    
    override func getRowMaxSize(row: Int) -> CGFloat {

        return 400
    }
    
    
    // nodes' detail
    override func getNodeMaxSize(row row: Int, column: Int) -> CGFloat {
        if row == 0 {
            return self.view.bounds.size.width * 0.8
        }else if row == 5 {
            return self.view.bounds.size.width
        }
        return self.view.bounds.size.width * 0.5
    }
    
    override func getNodeSizeType(row row: Int, column: Int) -> SizeType {
        return .EvenDistributed
    }
    
    override func getNodeWeight(row row: Int, column: Int) -> CGFloat {
        return 1.0
    }
    
    override func getNodeGap(row: Int) -> CGFloat {
        switch row {
        case 3:
            return 80
        case 5:
            return 0
        default:
            return 10
        }
    }
    
    // lines
    override func updateLineCollection() -> [ABSLine] {
        var allLines = [ABSLine]()
        
        // the arrow pointing to right
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(3, beginColumn: 0, beginAnchorRef: AnchorPosition.Right_Center, beginOffset: UIOffsetZero, endRow: 3, endColumn: 0, endAnchorRef: AnchorPosition.Right_Center, endOffset: UIOffset(horizontal: getNodeGap(3) - 40, vertical: 0), type: .Straight))
        
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(1, beginColumn: 0, beginAnchorRef: AnchorPosition.Center, beginOffset: UIOffsetZero, endRow: 2, endColumn: 0, endAnchorRef: AnchorPosition.Center, endOffset: UIOffset(horizontal: 0, vertical: getRowGap()), type: .Straight))
        let line1 = graphLines.linesHangFromNode(IndexPath(row: 2, column: 0), toRow: 3, toColumns: [], proportionOfFrom: 0.8)
        let line2 = graphLines.linesHangFromNode(IndexPath(row: 3, column: 1), toRow: 4, toColumns: [], proportionOfFrom: 0.8)
        
        allLines += line1 + line2
        
        return allLines
    }
    
    override func getLineDrawingStyle(index: NSInteger) -> ANLineDrawStyle {
        if index == 0  {
            return ANLineDrawStyle(lineWidth: 20, lineColor: UIColor.greenColor(), lineCap: .Butt, lineJoin: .Bevel)
        }
        return ANLineDrawStyle(lineWidth: 2, lineColor: UIColor.blackColor(), lineCap: .Butt, lineJoin: .Bevel)
    }
    
    override func getLineEndType(index: Int) -> LineEndType {
        if index == 0 {
            return LineEndType.Triangle
        }
        
        return LineEndType.Normal
    }
    
    override func getLineColorType(index: Int) -> LineColorType {
        if index == 0 {
            return LineColorType.Gradient
        }
        
        return LineColorType.Single
    }
    
    override func getGradientColors(index: Int) -> [CGColor] {
        return [UIColor.yellowColor().CGColor, UIColor.redColor().CGColor]
    }
    
}