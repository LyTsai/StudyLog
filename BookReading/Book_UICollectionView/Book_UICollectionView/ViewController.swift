//
//  ViewController.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/10/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

// MARK: ------------------- One -----------------------
class SampleOneViewController: UIViewController {
    let kCellIdentifier = "Cell Identifier"
    
    @IBOutlet var collectionView: UICollectionView!

    var colorArray: [UIColor]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
//        view = collectionView
        var tempArray = [UIColor]()
        for _ in 0..<100 {
            let redValue = CGFloat(arc4random())%255/255.0
            let greenValue = CGFloat(arc4random())%255/255.0
            let blueValue = CGFloat(arc4random())%255/255.0
            
            tempArray.append(UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1))
        }
        
        colorArray = tempArray
        print(colorArray)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = colorArray[indexPath.item]
        
        return cell
    }
}


// MARK: ------------------- Two -----------------------
class SampleTwoCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = "Hello World"
    }
    
    var text = "Hello World" {
        willSet{
            textLabel.text = newValue
        }
    }
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        textLabel.frame = bounds
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
        backgroundColor = UIColor.whiteColor()
    }
}

class SampleTwoViewController: UICollectionViewController {
    let CellIdentifier = "Cell Identifier"
    var datesArray = [NSDate]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 40
        flowLayout.minimumLineSpacing = 40
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 150, height: 80)
        collectionView?.indicatorStyle = .White
        
        collectionView?.registerClass(SampleTwoCell.self, forCellWithReuseIdentifier: CellIdentifier)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("h:mm:ss a", options: 0, locale: NSLocale.currentLocale())
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! SampleTwoCell
        cell.text = dateFormatter.stringFromDate(datesArray[indexPath.item])
        
        return cell
    }
    
    @IBAction func userTappedAddButton(sender: AnyObject) {
        collectionView?.performBatchUpdates({ 
            let dateNow = NSDate()
            self.datesArray.insert(dateNow, atIndex: 0)
            
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 0)])// (0, 0)
            }, completion: nil)
    }
}

// MARK: ------------------- Three -----------------------
class SampleThreeViewController: UICollectionViewController {
    let CellIdentifier = "Cell Identifier"
    
    var imageArray = [UIImage?]()
    var colorArray = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModels()
        setupLayout()
        
        collectionView?.registerClass(SampleThreeCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView?.allowsMultipleSelection = true
        collectionView?.indicatorStyle = .White
        
//        collectionView?.canCancelContentTouches = false
//        collectionView?.delaysContentTouches = false
    }
    
    func setupModels() {
        for i in 0..<12 {
            let image = UIImage(named: "icon\(i)")
            imageArray.append(image)
        }
        
        for _ in 0..<10 {
            let redValue = CGFloat(arc4random())%255/255.0
            let greenValue = CGFloat(arc4random())%255/255.0
            let blueValue = CGFloat(arc4random())%255/255.0
            colorArray.append(UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1))
        }
    }
    
    func setupLayout() {
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.headerReferenceSize = CGSize(width: 60, height: 50)
    }
    
    // dataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return colorArray.count
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! SampleThreeCell
        
        cell.image = imageArray[indexPath.row]
        cell.backgroundColor = colorArray[indexPath.section]
        
        return cell
    }
}

class SampleThreeCell: UICollectionViewCell {
    var image: UIImage! {
        willSet{
            imageView.image = newValue
        }
    }
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.whiteColor()
        
        imageView.frame = CGRectInset(bounds, 10, 10)
        contentView.addSubview(imageView)
        
        let selectedBackgroundView = UIView(frame: CGRectZero)
        selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override var highlighted: Bool {
        willSet{
            if newValue == true {
                imageView.alpha = 0.8
            }else {
                imageView.alpha = 1
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = UIColor.whiteColor()
        image = nil
    }
}

// MARK: ------------------- Four -----------------------
class SampleFourPhotoModel {
    var name = "Leaves"
    var image: UIImage!
    
    class func photeModelWithName(name: String, image: UIImage) -> SampleFourPhotoModel {
        let photeModel = SampleFourPhotoModel()
        photeModel.name = name
        photeModel.image = image
        
        return photeModel
    }
}

class SampleFourSectionModel {
    var selectionModelNoSelectionIndex: Int!
    
    var photoModels = [SampleFourPhotoModel]() // readonly
    var selectedPhotoModelIndex: Int = 0
    var hasBeenSelected = true // readonly
    
    class func selectionModelWithPhotoModels(photoModels: [SampleFourPhotoModel]) -> SampleFourSectionModel {
        let sectionModel = SampleFourSectionModel()
        sectionModel.photoModels = photoModels
        
        return sectionModel
    }
    
}

class SampleFourHeaderView: UICollectionReusableView {
    var text = " " {
        willSet {
            textLabel.text = newValue
        }
    }
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        textLabel.frame = CGRectInset(bounds, 30, 10)
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textColor = UIColor.whiteColor()
        textLabel.font = UIFont.boldSystemFontOfSize(16)
        textLabel.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//        backgroundColor = UIColor.greenColor()
        
        addSubview(textLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = " "
    }
}

class SampleFourCell: UICollectionViewCell {
    var image: UIImage! {
        willSet{
            imageView.image = newValue
        }
    }
    
    func setDisabled(disabled: Bool) {
        contentView.alpha = disabled ? 0.5 : 1
        backgroundColor = disabled ? UIColor.grayColor() : UIColor.whiteColor()
    }
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        imageView.frame = CGRectZero
        imageView.backgroundColor = UIColor.cyanColor()
        contentView.addSubview(imageView)
        
        let selectedBackgroundView = UIView(frame: CGRectZero)
        selectedBackgroundView.backgroundColor = UIColor.orangeColor()
        self.selectedBackgroundView = selectedBackgroundView
        
        backgroundColor = UIColor.whiteColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
        selected = false
    }
    
    override func layoutSubviews() {
        imageView.frame = CGRectInset(bounds, 10, 10)
    }
    
}

// VC
let kMaxItemSize =  CGSize(width: 100, height: 100)
class SampleFourViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let CellIdentifier = "Cell Identifier"
    let HeaderIdentifier = "HeaderIdentifier"
    
    var currentModelArrayIndex: Int = 0 // which section we’re currently prompting the user for
    var selectionModelArray = [SampleFourSectionModel]()
    var isFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setModel()
        
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.headerReferenceSize = CGSize(width: 60, height: 50)
        
        collectionView?.registerClass(SampleFourCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView?.registerClass(SampleFourHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderIdentifier)
        
        collectionView?.allowsMultipleSelection = true
        collectionView?.indicatorStyle = .White
    }
    
    func setModel() {
        for j in 0..<4 {
            var photoArray = [SampleFourPhotoModel]()
            for i in j*3..<3*(j+1) {
                photoArray.append(SampleFourPhotoModel.photeModelWithName("icon\(i)", image: UIImage(named: "icon\(i)")!))
            }
            let sectionArray = SampleFourSectionModel.selectionModelWithPhotoModels(photoArray)
            
            selectionModelArray.append(sectionArray)
        }

    }
    
    func photoModelForIndexPath(indexPath: NSIndexPath) -> SampleFourPhotoModel {
        return selectionModelArray[indexPath.section].photoModels[indexPath.item]
    }
    
    func configureCell(cell: SampleFourCell, forIndexPath indexPath: NSIndexPath) {
        cell.image = photoModelForIndexPath(indexPath).image
        
        // default
        cell.selected = false
        cell.setDisabled(false)
        
        if indexPath.section < currentModelArrayIndex {
            cell.setDisabled(true)
            
            if indexPath.row == selectionModelArray[indexPath.section].selectedPhotoModelIndex {
                cell.selected = true
            }
        }
    }


    // header
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HeaderIdentifier, forIndexPath: indexPath) as! SampleFourHeaderView
        
        if indexPath.section == 0 {
            headerView.text = "Tap on a photo to start the recommendation engine."
        }else if indexPath.section <= currentModelArrayIndex {
            let selectionModel = selectionModelArray[indexPath.section - 1]
            let selectedPhotoModel = photoModelForIndexPath(NSIndexPath(forItem: selectionModel.selectedPhotoModelIndex, inSection: indexPath.section - 1))
            headerView.text = "Because you liked \(selectedPhotoModel.name) ..."
        }
        
        return headerView
    }
    
    // dataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return min(currentModelArrayIndex + 1, selectionModelArray.count)
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionModelArray[currentModelArrayIndex].photoModels.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! SampleFourCell
        configureCell(cell, forIndexPath: indexPath)
     
        return cell
    }
    
    // delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // no matter what, deselect that cell
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        if currentModelArrayIndex >= selectionModelArray.count - 1 {
//            UIAlertController(title: "Recommendation Engine", message: "Based on your selections, we have concluded you have excellent taste in photography", preferredStyle: .Alert)
           isFinished = true
            print("yes")
            
            return
        }
        
        selectionModelArray[currentModelArrayIndex].selectedPhotoModelIndex = indexPath.item
        collectionView.performBatchUpdates({ 
            self.currentModelArrayIndex += 1
            collectionView.insertSections(NSIndexSet(index: self.currentModelArrayIndex))
            collectionView.reloadSections(NSIndexSet(index: self.currentModelArrayIndex-1))
            }) { (true) in
                collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: self.currentModelArrayIndex), atScrollPosition: .Top, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let photoModel = photoModelForIndexPath(indexPath)
        let photoSize = photoModel.image.size
        let aspectRatio = photoSize.width / photoSize.height
        
        var itemSize = kMaxItemSize
        if aspectRatio < 1 {
            itemSize = CGSize(width: kMaxItemSize.width * aspectRatio, height: kMaxItemSize.height)
        }else if aspectRatio > 1 {
            itemSize = CGSize(width: kMaxItemSize.width, height: kMaxItemSize.height/aspectRatio)
        }
        
        return itemSize
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == currentModelArrayIndex && !isFinished
    }
    
    // menu
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if NSStringFromSelector(action) == "copy" {
            return true
        }
        return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if NSStringFromSelector(action) == "copy" {
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = photoModelForIndexPath(indexPath).name
            
        }
    }
}

// MARK: ------------------- Five -----------------------
class SampleFiveCollectionFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArray = super.layoutAttributesForElementsInRect(rect)
        for attributes in attributesArray! {
            applyLayoutAttributes(attributes)
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        applyLayoutAttributes(attributes!)
        
        return attributes
    }
    
    private func applyLayoutAttributes(attributes: UICollectionViewLayoutAttributes){
        
    }
}
