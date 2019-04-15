//
//  CardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/9.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// type of card, vCard.style.style
enum CardTemplateStyle: Int {
    case Match                      = 1
    case MultipleChoiceVertical
    case MultipleChoiceHorizontal
    case ValueInput
//    case Information
}

// type of input control (slider, dial, circle or text input etc)
enum InputControlStyle {
    case Slider
    case Dial
    case Circle
    case TextInput
}

class CardTemplateView: UIView, UITableViewDataSource, UITableViewDelegate,CardTemplateProtocol {
    
    func key() -> String {
        return "56477a46-94cc-4c73-83ae-3ea1d96c6c7e"
    }
    
    // MARK: ------ IBOutlet
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var centerBackView: UIView!
//    @IBOutlet weak var textLabel: UILabel!
//    @IBOutlet weak var infoLabel: UILabel!
//    @IBOutlet var matchButtons: [UIButton]!
//    @IBOutlet weak var detailsButton: UIButton!
//    
//    var indexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    // MARK: ------ code properties ----------
    private var headerView = UIView()
    private var categoryLabel = UILabel()
    private var centerBackView = UIView()
    private var textLabel = UILabel()
    private var infoLabel = UILabel()
    private var  matchButtons = [UIButton]()
    private var  detailsButton = UIButton()
    
    private var widthPro: CGFloat = 0.75
    private var heightPro: CGFloat = 0.93
    
    // MARK: ------- properties
    private var result = VOptionModel()
    private var userMadeSelection = false
    
    // readonly
    private var cardStyle = CardTemplateStyle.MultipleChoiceHorizontal
    var cardTemplateStyle: CardTemplateStyle {
        return cardStyle
    }
    
    private var vCard = VCardModel()
    var vCardOfView: VCardModel {
        return vCard
    }
    
    // Universal
    var cornerProportion:CGFloat = 0.06
    
    var centerViewCornerRadius: CGFloat {
        return cornerProportion * centerBackView.bounds.height
    }
    var buttonCornerRadius: CGFloat {
        return cornerProportion * 4 * matchButtons.first!.bounds.height
    }
    
    // special
    // for matchCard
    var statementLabel: UILabel!
    var matchCardImageView: UIImageView!
    var matchProportion: CGFloat = 0.15

    private var currentIndex: Int = 0 // for both multiple and inputValue
    // for multipleChoicesCard
    var iconMargin: CGFloat = 1
    var displayNameLabel: UILabel!
    var iconImageView: UIImageView!
    var multipleChoicesTableView: UITableView!
    
    // for valueInput
    var inputControl: UIView! // maybe UIControl or view with gestures or controls, so, use UIView, not UIControl
    var inputValueView: UIView!
    private var inputStyle: CardStyleModel!
    
    // delegate to other classes
    
     // MARK: ---------- methods ---------------
    func updateBasicUI() {
        backgroundColor = UIColor.purpleColor()
        
        headerView.backgroundColor = UIColor.clearColor()
        categoryLabel.backgroundColor = UIColor.clearColor()
        categoryLabel.textAlignment = .Right
        categoryLabel.numberOfLines = 0
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.numberOfLines = 0
        infoLabel.backgroundColor = UIColor.clearColor()
        infoLabel.numberOfLines = 0
        
        addSubview(headerView)
        addSubview(categoryLabel)
        addSubview(textLabel)
        addSubview(infoLabel)
        
        centerBackView.backgroundColor = UIColor.cyanColor()
        addSubview(centerBackView)
        matchButtons = [UIButton(), UIButton()]
        for button in matchButtons {
            addSubview(button)
            button.backgroundColor = UIColor.cyanColor()
        }
        matchButtons[0].addTarget(self, action: #selector(firstButtonClicked(_:)), forControlEvents: .TouchUpInside)
        matchButtons[1].addTarget(self, action: #selector(secondButtonClicked(_:)), forControlEvents: .TouchUpInside)
        detailsButton.backgroundColor = UIColor.cyanColor()
        detailsButton.addTarget(self, action: #selector(moreDetails), forControlEvents: .TouchUpInside)
        addSubview(detailsButton)
    }
    
    // card based on VCard.style.style.
    class func createCardTemplateViewWithVCard(vCard: VCardModel) -> CardTemplateView{
        let cardView = CardTemplateView()
        cardView.updateBasicUI()
        cardView.resetTemplateViewWithVCard(vCard)
        return cardView
    }
    
    func resetTemplateViewWithVCard(vCard: VCardModel) {
        var type = vCard.style?.style?.integerValue
        
        if type == nil || type < 1 || type > 4 {
            type = 1
        }
        let enumDictionary: [Int: CardTemplateStyle] = [1: .Match, 2: .MultipleChoiceVertical, 3: .MultipleChoiceHorizontal, 4: .ValueInput]
        
        let cardTemplateStyle = enumDictionary[type!]
        setCardTemplateViewWithStyle(cardTemplateStyle!, vCard: vCard)
    }

    class func createCardTemplateViewWithStyle(cardTemplateStyle: CardTemplateStyle) -> CardTemplateView {
        let cardView = CardTemplateView()
        cardView.updateBasicUI()
//        let cardView = NSBundle.mainBundle().loadNibNamed("CardTemplateView", owner: self, options: nil).last as! CardTemplateView
        cardView.reloadWithStyle(cardTemplateStyle)
        
        return cardView
    }
    
    class func createCardTemplateViewWithStyle(cardTemplateStyle: CardTemplateStyle, vCard: VCardModel) -> CardTemplateView{
//        let cardView = NSBundle.mainBundle().loadNibNamed("CardTemplateView", owner: self, options: nil).last as! CardTemplateView
        let cardView = CardTemplateView()
        cardView.updateBasicUI()
        cardView.setCardTemplateViewWithStyle(cardTemplateStyle, vCard: vCard)

        return cardView
    }

    func setCardTemplateViewWithStyle(cardStyle: CardTemplateStyle, vCard: VCardModel) {
        reloadWithStyle(cardStyle)
        reloadWithVCardData(vCard)
    }
    
    func reloadWithStyle(cardStyle: CardTemplateStyle)  {
        self.cardStyle = cardStyle
        for view in headerView.subviews {view.removeFromSuperview()}
        for view in centerBackView.subviews {view.removeFromSuperview()}

        setHeaderView()
        setCenterView()
    }
    
    func reloadWithVCardData(vCard: VCardModel) {
        self.vCard = vCard
        switch cardStyle {
        case .Match: setMatchCardData()
        case .ValueInput: setValueInputCardData()
        default: setMultipleCardData()
        }
    }

    private func setHeaderView() {
        if cardStyle == .Match {
            statementLabel = UILabel()
            statementLabel.textAlignment = .Center
            statementLabel.backgroundColor = centerBackView.backgroundColor // setImage
            statementLabel.numberOfLines = 0
            headerView.addSubview(statementLabel)
        } else {
            iconImageView = UIImageView()
            displayNameLabel = UILabel()
            displayNameLabel.textAlignment = .Center
            displayNameLabel.backgroundColor = centerBackView.backgroundColor
            
            headerView.addSubview(iconImageView)
            headerView.addSubview(displayNameLabel)
        }
    }
    
    private func setCenterView() {
        switch cardStyle {
        case .Match:
            matchCardImageView = UIImageView()
            centerBackView.addSubview(matchCardImageView)
            
        case .MultipleChoiceHorizontal, .MultipleChoiceVertical:
            multipleChoicesTableView = UITableView()
            if cardStyle == .MultipleChoiceHorizontal {
                multipleChoicesTableView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI) * 0.5)
            }
            multipleChoicesTableView.backgroundColor = UIColor.clearColor()
            multipleChoicesTableView.separatorStyle = .None

            multipleChoicesTableView.delegate = self
            multipleChoicesTableView.dataSource = self

            centerBackView.addSubview(multipleChoicesTableView)
        case .ValueInput:
            inputControl = UIView()
            inputValueView = UIView()
            inputStyle = vCard.style
            
//             setUp views according to style
            centerBackView.addSubview(inputControl)
            centerBackView.addSubview(inputValueView)
        }
    }
    
    private func setValueInputViewsWithStyle(inputStyle: CardStyleModel){

    }
    private func setMatchCardData(){
        // two buttons
        matchButtons.first?.setTitle("Yes", forState: .Normal)
        matchButtons.last?.setTitle("No", forState: .Normal)

        let matchOptions = vCard.matchOptions
        if matchOptions == nil {
            return
        }
        let matchOption = convertNSSetToArray(matchOptions)?.first as! VOptionModel
        
        statementLabel.text = matchOption.statement
        categoryLabel.text = vCard.title
        matchCardImageView.image = convertDataObjectToImage(matchOption.image!)
        textLabel.text = matchOption.text
        infoLabel.text = matchOption.info
        
    }
    
    private func setMultipleCardData(){
        displayNameLabel.text = vCard.displayName
        iconImageView.image = convertDataObjectToImage(vCard.icon)
        categoryLabel.text = vCard.title
        
        let matchOptions = vCard.matchOptions
        let matchOption = convertNSSetToArray(matchOptions)?[currentIndex] as! VOptionModel
        
        textLabel.text = matchOption.text
        infoLabel.text = matchOption.info
        multipleChoicesTableView.reloadData()
        
        matchButtons.first?.setTitle("Apply", forState: .Normal)
        matchButtons.last?.setTitle("Cancel", forState: .Normal)
    }
    
    private func setValueInputCardData(){
        displayNameLabel.text = vCard.displayName
        iconImageView.image = convertDataObjectToImage(vCard.icon!)
        categoryLabel.text = vCard.title
        
        let matchOption = convertNSSetToArray(vCard.matchOptions)?.first as! VOptionModel
        //let classifiers = matchOption.metric?.classifiers
        //let classifier = convertNSSetToArray(classifiers)?[currentIndex] as! ClassifierModel
        let classifier = matchOption.match
        
        // {color,image, displayName, info},
        textLabel.text = "\(classifier.withClassification)"
        infoLabel.text = classifier.info
        
        // buttons' data  = VCard.matchOptions[0].metric
        matchButtons.first?.setTitle("Done", forState: .Normal)
        matchButtons.last?.setTitle("Cancel", forState: .Normal)
    }

    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupBasicLayout()
        layoutHeaderSubViews()
        layoutCenterSubviews()
        drawDetailButton()
        updateUI()
        updateFonts()
    }

    private func setupBasicLayout()  {
        let viewWidth = bounds.width
        let viewHeight = bounds.height
        
        let stackWidth = viewWidth * widthPro
        let minX = viewWidth * (1 - widthPro) * 0.5
        let minY = viewHeight * (1 - heightPro) * 0.5
        
        var headerHeight = 0.1 * viewHeight
        let categoryHeight = 0.05 * viewHeight
        var infoHeight = 0.125 * viewHeight
        
        var yGap = (viewHeight * heightPro - 2 * headerHeight - stackWidth - categoryHeight - infoHeight) / 4
        if yGap < 0 {
            print("please reset the size of frame, or change the proportion")
            headerHeight = 0.08 * viewHeight
            infoHeight = 0.1 * viewHeight
            yGap = (viewHeight * heightPro - 2 * headerHeight - stackWidth - categoryHeight - infoHeight) / 4
        }
        
        headerView.frame = CGRect(x: minX, y: minY, width: stackWidth, height: headerHeight)
        categoryLabel.frame = CGRect(x: minX, y: headerView.frame.maxY + yGap, width: stackWidth, height: categoryHeight)
        centerBackView.frame = CGRect(x: minX, y: categoryLabel.frame.maxY + yGap, width: stackWidth, height: stackWidth)
        textLabel.frame = CGRect(x: minX, y: centerBackView.frame.maxY + yGap, width: stackWidth, height: headerHeight)
        infoLabel.frame = CGRect(x: minX, y: textLabel.frame.maxY + yGap, width: 0.54 * stackWidth, height: infoHeight)
        
        let buttonHeight = 0.5 * infoHeight
        let buttonWidth = 0.5 * stackWidth * 0.38
        let detailWidth = buttonHeight * sqrt(3) * 0.5
        let buttonY = infoLabel.frame.midY - buttonHeight * 0.5
        
        let xGap = (stackWidth * 0.5 - 2 * buttonWidth - detailWidth) * 0.5
        
        matchButtons[0].frame = CGRect(x: infoLabel.frame.maxX + xGap, y: buttonY, width: buttonWidth, height: buttonHeight)
        matchButtons[1].frame = CGRect(x: matchButtons[0].frame.maxX + xGap, y: buttonY, width: buttonWidth, height: buttonHeight)
        detailsButton.frame = CGRect(x: matchButtons[1].frame.maxX + xGap, y: buttonY, width: detailWidth, height: buttonHeight)
    }
    
    private func layoutHeaderSubViews(){
        let headerHeight = headerView.bounds.height
        let iconHeight = headerHeight - iconMargin * 2
        
        switch cardStyle {
        case .Match:
            statementLabel.frame = headerView.bounds
            statementLabel.adjustsFontSizeToFitWidth = true
            statementLabel.baselineAdjustment = .AlignCenters
        default:
            iconImageView.frame = CGRect(x: 0, y: iconMargin, width: iconHeight, height: iconHeight)
            displayNameLabel.frame = CGRect(x: iconHeight, y: 0, width: headerView.bounds.width - iconHeight, height: headerHeight)
//            displayNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            displayNameLabel.adjustsFontSizeToFitWidth = true
            displayNameLabel.baselineAdjustment = .AlignCenters
            displayNameLabel.numberOfLines = 0
        }
    }
    
    private func layoutCenterSubviews(){
        switch cardStyle {
        case .Match:
            let matchImageMargin = matchProportion * centerBackView.bounds.height
            matchCardImageView.frame = CGRectInset(centerBackView.bounds, matchImageMargin, matchImageMargin)
        case .ValueInput: layoutInputControls()
        default:
            let tableViewMargin:(top: CGFloat, left: CGFloat) = (cornerProportion * centerBackView.bounds.height, 3 * cornerProportion * centerBackView.bounds.height)
            multipleChoicesTableView.frame = CGRectInset(centerBackView.bounds, tableViewMargin.left, tableViewMargin.top)
        }
    }
    
    private func layoutInputControls(){
        
    }
    
    private func drawDetailButton() {
        let detailBounds = detailsButton.bounds
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addLineToPoint(CGPoint(x: 0, y: detailBounds.height))
        path.addLineToPoint(CGPoint(x: detailBounds.maxX, y: detailBounds.midY))
        path.closePath()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = detailBounds
        maskLayer.path = path.CGPath
        maskLayer.lineWidth = 0.01
        maskLayer.fillColor = UIColor.redColor().CGColor
        detailsButton.layer.mask = maskLayer
    }
    
    // UI and layout
    func updateUI() {
        centerBackView.layer.cornerRadius = centerViewCornerRadius
        matchButtons.first?.layer.cornerRadius = buttonCornerRadius
        matchButtons.last?.layer.cornerRadius = buttonCornerRadius
    }
    
    func updateFonts() {
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.baselineAdjustment = .AlignCenters
        textLabel.adjustsFontSizeToFitWidth = true
        infoLabel.adjustsFontSizeToFitWidth = true
        for button in matchButtons {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.baselineAdjustment = .AlignCenters
        }
    }
    
    // MARK: -------- tableView dataSource ------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vCard.matchOptions == nil {
            return 0
        }
        return vCard.matchOptions!.count
    }

    private var cellID: String {
        return cardStyle == .MultipleChoiceHorizontal ? "Horizontal" : "Vertical"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let option = convertNSSetToArray(vCard.matchOptions)![indexPath.row] as! VOptionModel
        let choicesCell = ChoiceCell.cellWithTableView(tableView, reuseIdentifier: cellID)
        choicesCell.setWithImage(convertDataObjectToImage(option.image), text: option.statement)

        return choicesCell
    }

    // MARK: -------- tableView delegate ------------

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(vCard.matchOptions!.count)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        let matchOption = convertNSSetToArray(vCard.matchOptions)![currentIndex] as! VOptionModel
        textLabel.text = matchOption.text
        infoLabel.text = matchOption.info
        
        result = matchOption
        userMadeSelection = true
    }
    
    // controlEvents
    @IBAction func firstButtonClicked(sender: UIButton) {
        // adding new object into “measurement” entity with VCard.matchOptions[0].match for the attached “user” object.
        let collection = AIDMetricCardsCollection.standardCollection
        let option = vCard.matchOptions?.anyObject() as! VOptionModel
        let metricKey = option.metric.key
        let deck = collection.metricToCards[metricKey]!   
        
//        if userMadeSelection == false {
//            print("Not selected Yet")
//            // use alert
//            
//            return
//        }
        
        deck.state.state = .Processed
        deck.state.value = result
        deck.saveMeasurement()
//        colletionDelegate.moveToNext(currentIndexPath: indexPath)
        // saveData and fly away this card
    }
    
    @IBAction func secondButtonClicked(sender: UIButton) {
        // cause this card to be disappeared from user  
    }
    
    
    @IBAction func moreDetails() {
        // “flip” the card to the “information” view detailed
        // vCard.details
        layer.removeAllAnimations()
        let informationView = InformationCardView(frame: bounds)
        informationView.createInformationCardTempleta()
        informationView.reloadDataWithVCard(vCard)
        addSubview(informationView)
//        informationView.relatedTemplateCard = self.copy() as! CardTemplateView
        let transition = CATransition()
        transition.type = "flip"
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.5
        
        layer.addAnimation(transition, forKey: nil)
    }

}

// MARK: ---------- classes for multipleChoicesCard
class ChoiceCell: UITableViewCell {
    
    private var isVertical = false
    
    class func cellWithTableView(tableView: UITableView, reuseIdentifier cellID: String) -> ChoiceCell {
        var choiceCell = tableView.dequeueReusableCellWithIdentifier(cellID) as? ChoiceCell
    
        if choiceCell == nil {
            choiceCell = ChoiceCell(style: .Default, reuseIdentifier: cellID)
            choiceCell!.backgroundColor = UIColor.clearColor()
            choiceCell!.isVertical = (cellID == "Vertical")
        
            let selectedView = UIView(frame: CGRectZero)
            selectedView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
            choiceCell?.selectedBackgroundView = selectedView
        }
        
        return choiceCell!
    }
    
    func setWithImage(image: UIImage?, text: String?) {
        imageView?.image = image
        textLabel?.text = text
        textLabel?.adjustsFontSizeToFitWidth = true
        textLabel?.baselineAdjustment = .AlignCenters
        textLabel?.textAlignment = .Center
        textLabel?.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellHeight = bounds.height
        let cellWidth = bounds.width
        let margin: CGFloat = 2
        
        imageView?.frame = CGRect(x: margin, y: margin, width: cellHeight - 2 * margin, height: cellHeight - 2 * margin)
        textLabel?.frame = CGRect(x: cellHeight + margin, y: margin, width: cellWidth - cellHeight - margin * 3, height: cellHeight - margin * 2)
        
        if !isVertical {
            let textFrame = textLabel?.frame
            let imageFrame = imageView?.frame
            
            imageView?.frame = textFrame!
            textLabel?.frame = imageFrame!
        }
    }
}