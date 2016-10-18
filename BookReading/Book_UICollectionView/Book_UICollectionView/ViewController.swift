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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        text = "0"
//    }
    
    var text = "Hello World"
    
    private let textLabel = UILabel()
    
    func getCellWithText(text: String) -> SampleTwoCell {
        let cell = SampleTwoCell()
        textLabel.frame = bounds
        textLabel.text = text
        contentView.addSubview(textLabel)
        backgroundColor = UIColor.whiteColor()
        
        return cell
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
        flowLayout.itemSize = CGSize(width: 200, height: 200)
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
        let string = dateFormatter.stringFromDate(datesArray[indexPath.item])
        cell.getCellWithText(string)
        
        return cell
    }
    
    @IBAction func userTappedAddButton(sender: AnyObject) {
        collectionView?.performBatchUpdates({ 
            let dateNow = NSDate()
            self.datesArray.insert(dateNow, atIndex: 0)
            print("hello")
            
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 0)])// (0, 0)
            }, completion: nil)
    }
    
}