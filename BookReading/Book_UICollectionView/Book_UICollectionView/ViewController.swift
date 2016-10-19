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

// MARK: ------------------- Two -----------------------
class SampleThreeViewController: UICollectionViewController {
    let CellIdentifier = "Cell Identifier"
    let HeaderIdentifier = "HeaderIdentifier"
    
    var imageArray = [UIImage?]()
    var colorArray = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModels()
        setupLayout()
        
        collectionView?.registerClass(SampleThreeCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView?.registerClass(SampleTreeHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderIdentifier)
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
    
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HeaderIdentifier, forIndexPath: indexPath)
        
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

class SampleTreeHeaderView: UICollectionReusableView {
    var text = "This is header" {
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
//        textLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
        
        addSubview(textLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = " "
    }
    
}