//
//  BasicCardTemplatesView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 11/16/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// define tepalte view styles of the same family
enum CardTemplateStyle: Int {
    case match                      = 1
    case multipleChoiceVertical
    case multipleChoiceHorizontal
    case valueInput
}

// type of input control (slider, dial, circle or text input etc)
enum InputControlStyle {
    case slider
    case dial
    case circle
    case textInput
}

class MatchView: CardTemplateView {
    override func key() -> String {
        return MatchView.styleKey()
    }
    
    class func styleKey() -> String {
        return "3ca72cc2-9aeb-11e6-9f33-a24fc0d9649c"
    }
}

class MultipleChoicesHorizontalView: CardTemplateView{
    override func key() -> String {
        return MultipleChoicesHorizontalView.styleKey()
    }
    
    class func styleKey() -> String {
        return "3ca7306e-9aeb-11e6-9f33-a24fc0d96d"
    }
}

class MultipleChoicesVerticalView: CardTemplateView {
    override func key() -> String {
        return MultipleChoicesVerticalView.styleKey()
    }
    
    class func styleKey() -> String {
        return "3ca73258-9aeb-11e6-9f33-a24fc0d9649b"
    }
}

class ValueInputView: CardTemplateView {
    override func key() -> String {
        return ValueInputView.styleKey()
    }
    
    class func styleKey() -> String {
        return "3ca7341a-9aeb-11e6-9f33-a24fc0d964dc"
    }
}

class BasicCardTemplatesView : CardTemplateView, UITableViewDataSource, UITableViewDelegate {
    // properites used to set layout or read
    var cornerProportion:CGFloat = 0.06
    var matchProportion: CGFloat = 0.15
    var iconMargin: CGFloat = 1
    
    // private properties
    fileprivate var headerView: UIView!
    fileprivate var categoryLabel: UILabel!
    fileprivate var textLabel: UILabel!
    fileprivate var infoLabel: UILabel!
    
    // special
    // for matchCard
    fileprivate var statementLabel: UILabel!
    
    fileprivate var widthPro: CGFloat = 0.75
    fileprivate var heightPro: CGFloat = 0.93
    
    // Universal
    fileprivate var centerViewCornerRadius: CGFloat {
        return cornerProportion * centerBackView.bounds.height
    }
    fileprivate var buttonCornerRadius: CGFloat {
        return cornerProportion * 4 * confirmButton.bounds.height
    }
    
    fileprivate var matchCardImageView: UIImageView!
    fileprivate var currentIndex: Int = 0 // for both multiple and inputValue
    // for multipleChoicesCard
    
    fileprivate var displayNameLabel: UILabel!
    fileprivate var multipleChoicesTableView: UITableView!
    
    // for valueInput
    fileprivate var inputControl: UIView! // maybe UIControl or view with gestures or controls, so, use UIView, not UIControl
    fileprivate var inputValueView: UIView!
    
    var cardTemplate: CardTemplateStyle = .multipleChoiceHorizontal
    
    // here to create one of the basic view template
    func createCardTemplateView(_ key : String) -> CardTemplateView? {
        
        if key == MultipleChoicesHorizontalView.styleKey(){
            return BasicCardTemplatesView.createCardTemplateViewWithStyle(.multipleChoiceHorizontal)
        }
        if key == MultipleChoicesVerticalView.styleKey(){
            return BasicCardTemplatesView.createCardTemplateViewWithStyle(.multipleChoiceVertical)
        }
        if key == ValueInputView.styleKey(){
            return BasicCardTemplatesView.createCardTemplateViewWithStyle(.valueInput)
        }
 
        return nil
    }
    
    // MARK: ---------- methods ---------------
    ///////////////////////////////////////////////////////////
    // create card
    ///////////////////////////////////////////////////////////
    
    // check if is part of this card view template family
    class func isTemplateViewFamily(_ styleKey: String) ->Bool {
        if (MatchView.styleKey() == styleKey) {
            return true
        }else if (MultipleChoicesHorizontalView.styleKey() == styleKey) {
            return true
        }else if (MultipleChoicesVerticalView.styleKey() == styleKey) {
            return true
        }else if (ValueInputView.styleKey() == styleKey) {
            return true
        }else {
            return false
        }
    }
    
    // card based on VCard.style.style.
    class func createCardTemplateViewWithVCard(_ vCard: CardInfoObjModel, defaultOption: CardOptionObjModel?) -> CardTemplateView{
        let cardView = BasicCardTemplatesView()
        cardView.resetTemplateViewWithVCard(vCard, defaultOption: defaultOption)
        //        // need to do this in order to avoid looking "jagged"
        //        cardView.layer.shouldRasterize = true
        // This code is written in "func updateBasicUIForStyle(cardTemplateStyle: CardTemplateStyle)", which is called in the func up
        return cardView
    }
    
    class func createCardTemplateViewWithStyle(_ cardTemplateStyle: CardTemplateStyle) -> BasicCardTemplatesView {
        let cardView = BasicCardTemplatesView()
        cardView.reloadWithStyle(cardTemplateStyle)
        
        return cardView
    }
    
    class func createCardTemplateViewWithStyle(_ cardTemplateStyle: CardTemplateStyle, vCard: CardInfoObjModel, defaultOption: CardOptionObjModel?) -> CardTemplateView{
        let cardView = BasicCardTemplatesView()
        cardView.setCardTemplateViewWithStyle(cardTemplateStyle, vCard: vCard, defaultOption: defaultOption)
        return cardView
    }
    
    class func reloadTemplateView(_ view: BasicCardTemplatesView, key: String) {
        switch key {
        case MultipleChoicesVerticalView().key():
            view.reloadWithStyle(.multipleChoiceVertical)
        case MultipleChoicesHorizontalView().key():
            view.reloadWithStyle(.multipleChoiceHorizontal)
        case ValueInputView().key():
            view.reloadWithStyle(.valueInput)
        default:
            view.reloadWithStyle(.match)
        }
    }

    // protocol function for resetting the content
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        resetTemplateViewWithVCard(card, defaultOption: defaultSelection)
    }
    
    ///////////////////////////////////////////////////////////
    // set card content
    ///////////////////////////////////////////////////////////
    func resetTemplateViewWithVCard(_ vCard: CardInfoObjModel, defaultOption: CardOptionObjModel?) {
        var type = vCard.cardStyle?.style
        
        if type == nil || type < 1 || type > 5 {
            type = 1
        }
        let enumDictionary: [Int: CardTemplateStyle] = [1: .match, 2: .multipleChoiceVertical, 3: .multipleChoiceHorizontal, 4: .valueInput]
        
        let cardTemplateStyle = enumDictionary[type!]
        setCardTemplateViewWithStyle(cardTemplateStyle!, vCard: vCard, defaultOption: defaultOption)
    }
    
    func setCardTemplateViewWithStyle(_ cardStyle: CardTemplateStyle, vCard: CardInfoObjModel, defaultOption: CardOptionObjModel?) {
        reloadWithStyle(cardStyle)
        reloadWithVCardData(vCard, defaultOption: defaultOption)
    }

    // basic method of creating a blank card
    func reloadWithStyle(_ cardTemplateStyle: CardTemplateStyle)  {
        self.cardTemplate = cardTemplateStyle
        updateBasicUIForStyle(cardTemplateStyle)
        loadView()
    }
    
    // setup GUI
    func loadView() {
        for view in headerView.subviews {view.removeFromSuperview()}
        for view in centerBackView.subviews {view.removeFromSuperview()}
        setHeaderView(cardTemplate == .match)
        setCenterView()
    }
    
    // add data to the blank card without changing style
    // if the style needs to change, call  "resetTemplateViewWithVCard(_:_)"
    func reloadWithVCardData(_ vCard: CardInfoObjModel, defaultOption: CardOptionObjModel?) {
        self.vCard = vCard
        switch cardTemplate {
        case .match: setMatchCardData(defaultOption)
        case .valueInput: setValueInputCardData()
        default: setMultipleCardData()
        }
    }

    // MARK: ---------------- private methods to arrange layout and data
    fileprivate func updateBasicUIForStyle(_ cardTemplateStyle: CardTemplateStyle) {
        
        // TODO: --------bitmap, if this is added, when click the detail button, the flip animation will not show the information card, but the card view
        // need to do this in order to avoid looking "jagged"
//        layer.shouldRasterize = true
        
        cardTemplate = cardTemplateStyle
        updateBasicUIForNormalCards()
    }
    
    func updateBasicUIForNormalCards(){
        backgroundColor = UIColor.purple
        
        // create objects
        headerView = UIView()
        categoryLabel = UILabel()
        centerBackView = UIView()
        textLabel = UILabel()
        infoLabel = UILabel()
        
        // views
        headerView.backgroundColor = UIColor.clear
        categoryLabel.backgroundColor = UIColor.clear
        categoryLabel.adjustFontToFit()
        categoryLabel.textAlignment = .right
        textLabel.backgroundColor = UIColor.clear
        textLabel.adjustFontToFit()
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.adjustFontToFit()
        centerBackView.backgroundColor = UIColor.cyan
        
        addSubview(headerView)
        addSubview(categoryLabel)
        addSubview(textLabel)
        addSubview(infoLabel)
        addSubview(centerBackView)
        
        // buttons
        setupBasic()
        
        skipButton = UIButton(type: .custom)
        addSubview(skipButton)
        confirmButton.backgroundColor = UIColor.cyan
        denyButton.backgroundColor = UIColor.cyan
        skipButton.backgroundColor = UIColor.cyan
    }
        
    func setHeaderView(_ bMatch:Bool) {
        if bMatch {
            statementLabel = UILabel()
            statementLabel.backgroundColor = centerBackView.backgroundColor // setImage
            statementLabel.adjustFontToFit()
            headerView.addSubview(statementLabel)
        } else {
            iconImageView = UIImageView()
            displayNameLabel = UILabel()
            displayNameLabel.textAlignment = .center
            displayNameLabel.backgroundColor = centerBackView.backgroundColor
            
            headerView.addSubview(iconImageView)
            headerView.addSubview(displayNameLabel)
        }
    }
    
    fileprivate func setCenterView() {
        switch cardTemplate {
        case .match:
            matchCardImageView = UIImageView()
            centerBackView.addSubview(matchCardImageView)
            
        case .multipleChoiceHorizontal, .multipleChoiceVertical:
            multipleChoicesTableView = UITableView()
            if cardTemplate == .multipleChoiceHorizontal {
                multipleChoicesTableView.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI) * 0.5)
            }
            multipleChoicesTableView.backgroundColor = UIColor.clear
            multipleChoicesTableView.separatorStyle = .none
            
            multipleChoicesTableView.delegate = self
            multipleChoicesTableView.dataSource = self
            
            centerBackView.addSubview(multipleChoicesTableView)
        case .valueInput:
            inputControl = UIView()
            inputValueView = UIView()
            
            // setUp views according to style
            centerBackView.addSubview(inputControl)
            centerBackView.addSubview(inputValueView)
            
            break
        }
    }
    
    fileprivate func setMatchCardData(_ option: CardOptionObjModel?){
        if option == nil {
            return
        }
        
        statementLabel.text = option!.match?.statement
        textLabel.text = option!.match?.text
        infoLabel.text = option!.match?.info
        matchCardImageView.image = convertDataObjectToImage(option!.match?.imageObj!)
        categoryLabel.text = vCard?.title
    }
    
    // TODO: ------- maybe not used, keep for template
    fileprivate func setMatchCardData(_ optionIndex: Int){
        let matchOption = vCard?.cardOptions
        if matchOption == nil || matchOption!.count == 0{
            print("no options")
            return
        }
        
        var index = optionIndex
        
        if index < 0 || index > matchOption!.count - 1 {
            index = 0
        }
        
        let option = matchOption![index]
        statementLabel.text = option.match?.statement
        textLabel.text = option.match?.text
        infoLabel.text = option.match?.info
        matchCardImageView.image = convertDataObjectToImage(option.match?.imageObj!)
        categoryLabel.text = vCard?.title
    }
    //------------------------------------
    
    fileprivate func setMultipleCardData(){
        displayNameLabel.text = vCard?.displayName

        iconImageView.image = vCard?.imageObj
        categoryLabel.text = vCard?.title
        
        if let matchOption = vCard?.cardOptions.first{ // !!! To Do for now
            textLabel.text = matchOption.match?.text
            infoLabel.text = matchOption.match?.info
        }
        
        multipleChoicesTableView.reloadData()
        
        confirmButton.setTitle("Apply", for: UIControlState())
        denyButton.setTitle("Cancel", for: UIControlState())
        skipButton.setTitle("skip", for: UIControlState())
    }
    
    fileprivate func setValueInputCardData(){
        displayNameLabel.text = vCard?.displayName
        iconImageView.image = convertDataObjectToImage(vCard?.imageObj!)
        categoryLabel.text = vCard?.title
        
        if let matchOption = vCard?.cardOptions.first{ // !!! To Do for now
            if let match = matchOption.match {
            // {color,image, displayName, info},
            textLabel.text = match.classification?.displayName
            infoLabel.text = match.info
            }
        }
        
        // buttons' data  = VCard.matchOptions[0].metric
        
    }
    
    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupBasicLayout()
        layoutHeaderSubViews()
        layoutCenterSubviews()
        drawTriangleButton(skipButton)
    }
    
    func setupBasicLayout()  {
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
        
        let ratio: CGFloat = 444 / 117
//        let buttonHeight = 0.56 * infoHeight
        let buttonWidth = 0.56 * stackWidth * 0.38
        let buttonHeight = buttonWidth / ratio
        
        let detailWidth = buttonHeight * sqrt(3) * 0.5
        let buttonY = infoLabel.frame.midY - buttonHeight * 0.5
        
        let xGap = (stackWidth * 0.56 - 2 * buttonWidth - detailWidth) * 0.5
        
        confirmButton.frame = CGRect(x: infoLabel.frame.maxX + xGap * 0.5, y: buttonY, width: buttonWidth, height: buttonHeight)
        denyButton.frame = CGRect(x: confirmButton.frame.maxX + xGap, y: buttonY, width: buttonWidth, height: buttonHeight)
        skipButton.frame = CGRect(x: denyButton.frame.maxX + xGap, y: buttonY, width: detailWidth, height: buttonHeight)
        
        centerBackView.layer.cornerRadius = centerViewCornerRadius
        confirmButton.layer.cornerRadius = buttonCornerRadius
        denyButton.layer.cornerRadius = buttonCornerRadius
        skipButton.layer.cornerRadius = buttonCornerRadius
    }
    
    fileprivate func layoutHeaderSubViews(){
        let headerHeight = headerView.bounds.height
        let iconHeight = headerHeight - iconMargin * 2
        
        switch cardTemplate {
        case .match:
            statementLabel.frame = headerView.bounds
            statementLabel.adjustFontToFit()
        default:
            iconImageView.frame = CGRect(x: 0, y: iconMargin, width: iconHeight, height: iconHeight)
            displayNameLabel.frame = CGRect(x: iconHeight, y: 0, width: headerView.bounds.width - iconHeight, height: headerHeight)
            displayNameLabel.adjustFontToFit()
        }
    }
    
    fileprivate func layoutCenterSubviews(){
        switch cardTemplate {
        case .match:
            let matchImageMargin = matchProportion * centerBackView.bounds.height
            matchCardImageView.frame = centerBackView.bounds.insetBy(dx: matchImageMargin, dy: matchImageMargin)
        case .valueInput: layoutInputControls()
        default:
            let tableViewMargin:(top: CGFloat, left: CGFloat) = (cornerProportion * centerBackView.bounds.height, cornerProportion * centerBackView.bounds.height)
            multipleChoicesTableView.frame = centerBackView.bounds.insetBy(dx: tableViewMargin.left, dy: tableViewMargin.top)
        }
    }
    
    fileprivate func layoutInputControls(){
        
    }
    

    
    // MARK: -------- tableView dataSource ------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vCard == nil || vCard!.cardOptions.isEmpty {
            return 0
        }
        return vCard!.cardOptions.count
    }
    
    fileprivate var cellID: String {
        return cardTemplate == .multipleChoiceHorizontal ? "Horizontal" : "Vertical"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let choicesCell = ChoiceCell.cellWithTableView(tableView, reuseIdentifier: cellID)
        if let option = vCard?.cardOptions[indexPath.row]{
            choicesCell.setWithImage(convertDataObjectToImage(option.match?.imageObj), text: option.match?.statement)
        }
        
        return choicesCell
    }
    
    // MARK: -------- tableView delegate ------------
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vCard == nil || vCard!.cardOptions.isEmpty {
            return 0
        }
        return tableView.bounds.height / CGFloat(vCard!.cardOptions.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        if let matchOption = vCard?.cardOptions[indexPath.row]{ // !!! To Do for now
            textLabel.text = matchOption.match?.text
            infoLabel.text = matchOption.match?.info
            option = matchOption
        }
    }
}

// MARK: ---------- classes for multipleChoicesCard
class ChoiceCell: UITableViewCell {
    
    fileprivate var isVertical = false
    
    class func cellWithTableView(_ tableView: UITableView, reuseIdentifier cellID: String) -> ChoiceCell {
        var choiceCell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ChoiceCell
        
        if choiceCell == nil {
            choiceCell = ChoiceCell(style: .default, reuseIdentifier: cellID)
            choiceCell!.backgroundColor = UIColor.clear
            choiceCell!.isVertical = (cellID == "Vertical")
            
            let selectedView = UIView(frame: CGRect.zero)
            selectedView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            choiceCell?.selectedBackgroundView = selectedView
        }
        
        return choiceCell!
    }
    
    func setWithImage(_ image: UIImage?, text: String?) {
        imageView?.image = image
        textLabel?.text = text
        textLabel?.adjustFontToFit()
        textLabel?.textAlignment = .center
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
