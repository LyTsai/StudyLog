//
//  ViewController.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/10/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

class PhotoModel {
    var name = "icon"
    var image: UIImage!
    
    class func photoModelWithName(_ name: String, image: UIImage) -> PhotoModel {
        let photeModel = PhotoModel()
        photeModel.name = name
        photeModel.image = image
        
        return photeModel
    }
    
    class func defaultModel() -> [PhotoModel]{
        var model = [PhotoModel]()
        
        for i in 0..<3 {
            let name = "back\(i)"
            model.append(PhotoModel.photoModelWithName(name, image: UIImage(named: name)!))
        }
        
        for i in 0..<12 {
            let name = "icon\(i)"
            model.append(PhotoModel.photoModelWithName(name, image: UIImage(named: name)!))
        }
        
        return model
    }
    
}

// MARK: ------------------- One -----------------------
class SampleOneViewController: UIViewController {
    let kCellIdentifier = "Cell Identifier"
    
    @IBOutlet var collectionView: UICollectionView!

    var colorArray: [UIColor]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)

        var tempArray = [UIColor]()
        for _ in 0..<100 {
            let redValue = CGFloat(arc4random()).truncatingRemainder(dividingBy: 255)/255.0
            let greenValue = CGFloat(arc4random()).truncatingRemainder(dividingBy: 255)/255.0
            let blueValue = CGFloat(arc4random()).truncatingRemainder(dividingBy: 255)/255.0
            
            tempArray.append(UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1))
        }
        
        colorArray = tempArray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
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
    
    fileprivate let textLabel = UILabel()
    
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
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
        backgroundColor = UIColor.white
    }
}

class SampleTwoViewController: UICollectionViewController {
    let CellIdentifier = "Cell Identifier"
    var datesArray = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 40
        flowLayout.minimumLineSpacing = 40
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 150, height: 80)
        collectionView?.indicatorStyle = .white
        
        collectionView?.register(SampleTwoCell.self, forCellWithReuseIdentifier: CellIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "h:mm:ss a", options: 0, locale: Locale.current)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! SampleTwoCell
        cell.text = dateFormatter.string(from: datesArray[indexPath.item])
        
        return cell
    }
    
    @IBAction func userTappedAddButton(_ sender: AnyObject) {
        collectionView?.performBatchUpdates({ 
            let dateNow = Date()
            self.datesArray.insert(dateNow, at: 0)
            
            self.collectionView?.insertItems(at: [IndexPath.init(row: 0, section: 0)])// (0, 0)
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
        
        collectionView?.register(SampleThreeCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView?.allowsMultipleSelection = true
        collectionView?.indicatorStyle = .white
        
//        collectionView?.canCancelContentTouches = false
//        collectionView?.delaysContentTouches = false
    }
    
    func setupModels() {
        for i in 0..<12 {
            let image = UIImage(named: "icon\(i)")
            imageArray.append(image)
        }
        
        for _ in 0..<10 {
            let redValue = CGFloat(arc4random()).truncatingRemainder(dividingBy: 255)/255.0
            let greenValue = CGFloat(arc4random()).truncatingRemainder(dividingBy: 255)/255.0
            let blueValue = CGFloat(arc4random()).truncatingRemainder(dividingBy: 255)/255.0
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
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colorArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! SampleThreeCell
        
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
    fileprivate let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.white
        
        imageView.frame = bounds.insetBy(dx: 10, dy: 10)
        contentView.addSubview(imageView)
        
        let selectedBackgroundView = UIView(frame: CGRect.zero)
        selectedBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override var isHighlighted: Bool {
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
        backgroundColor = UIColor.white
        image = nil
    }
}

// MARK: ------------------- Four -----------------------
class SampleFourPhotoModel {
    var name = "Leaves"
    var image: UIImage!
    
    class func photeModelWithName(_ name: String, image: UIImage) -> SampleFourPhotoModel {
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
    
    class func selectionModelWithPhotoModels(_ photoModels: [SampleFourPhotoModel]) -> SampleFourSectionModel {
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
    
    fileprivate let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        textLabel.frame = bounds.insetBy(dx: 30, dy: 10)
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
    
    func setDisabled(_ disabled: Bool) {
        contentView.alpha = disabled ? 0.5 : 1
        backgroundColor = disabled ? UIColor.gray : UIColor.white
    }
    
    fileprivate let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        imageView.frame = CGRect.zero
        imageView.backgroundColor = UIColor.cyan
        contentView.addSubview(imageView)
        
        let selectedBackgroundView = UIView(frame: CGRect.zero)
        selectedBackgroundView.backgroundColor = UIColor.orange
        self.selectedBackgroundView = selectedBackgroundView
        
        backgroundColor = UIColor.white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
        isSelected = false
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds.insetBy(dx: 10, dy: 10)
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
        
        collectionView?.register(SampleFourCell.self, forCellWithReuseIdentifier: CellIdentifier)
     collectionView?.register(SampleFourHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderIdentifier)
        
        collectionView?.allowsMultipleSelection = true
        collectionView?.indicatorStyle = .white
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
    
    func photoModelForIndexPath(_ indexPath: IndexPath) -> SampleFourPhotoModel {
        return selectionModelArray[indexPath.section].photoModels[indexPath.item]
    }
    
    func configureCell(_ cell: SampleFourCell, forIndexPath indexPath: IndexPath) {
        cell.image = photoModelForIndexPath(indexPath).image
        
        // default
        cell.isSelected = false
        cell.setDisabled(false)
        
        if indexPath.section < currentModelArrayIndex {
            cell.setDisabled(true)
            
            if indexPath.row == selectionModelArray[indexPath.section].selectedPhotoModelIndex {
                cell.isSelected = true
            }
        }
    }


    // header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderIdentifier, for: indexPath) as! SampleFourHeaderView
        
        if indexPath.section == 0 {
            headerView.text = "Tap on a photo to start the recommendation engine."
        }else if indexPath.section <= currentModelArrayIndex {
            let selectionModel = selectionModelArray[indexPath.section - 1]
            let selectedPhotoModel = photoModelForIndexPath(IndexPath(item: selectionModel.selectedPhotoModelIndex, section: indexPath.section - 1))
            headerView.text = "Because you liked \(selectedPhotoModel.name) ..."
        }
        
        return headerView
    }
    
    // dataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return min(currentModelArrayIndex + 1, selectionModelArray.count)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionModelArray[currentModelArrayIndex].photoModels.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! SampleFourCell
        configureCell(cell, forIndexPath: indexPath)
     
        return cell
    }
    
    // delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // no matter what, deselect that cell
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if currentModelArrayIndex >= selectionModelArray.count - 1 {
//            UIAlertController(title: "Recommendation Engine", message: "Based on your selections, we have concluded you have excellent taste in photography", preferredStyle: .Alert)
           isFinished = true
            print("yes")
            
            return
        }
        
        selectionModelArray[currentModelArrayIndex].selectedPhotoModelIndex = indexPath.item
        collectionView.performBatchUpdates({ 
            self.currentModelArrayIndex += 1
            collectionView.insertSections(IndexSet(integer: self.currentModelArrayIndex))
            collectionView.reloadSections(IndexSet(integer: self.currentModelArrayIndex-1))
            }) { (true) in
                collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentModelArrayIndex), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == currentModelArrayIndex && !isFinished
    }
    
    // menu
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if NSStringFromSelector(action) == "copy" {
            return true
        }
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if NSStringFromSelector(action) == "copy" {
            let pasteboard = UIPasteboard.general
            pasteboard.string = photoModelForIndexPath(indexPath).name
            
        }
    }
}

// MARK: ------------------- Five -----------------------
class SampleFiveCollectionFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArray = super.layoutAttributesForElements(in: rect)
        for attributes in attributesArray! {
            applyLayoutAttributes(attributes)
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        applyLayoutAttributes(attributes!)
        
        return attributes
    }
    
    fileprivate func applyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes){
        
    }
}
