//
//  Cards.swift
//  UIDesignCollection
//
//  Created by iMac on 16/9/27.
//  Copyright © 2016年 LyTsai. All rights reserved.
// http://www.jianshu.com/p/c5124b2322be

import Foundation
import UIKit

// MARK: ScrollCollectionView, looks like a images Scroll View
class ScrollFlowLayout: UICollectionViewFlowLayout{
    // called before cell shows, used to set layout
    /*
     - 该方法是准备布局，会在cell显示之前调用，可以在该方法中设置布局的一些属性，比如滚动方向，cell之间的水平间距，以及行间距等
     - 也建议在这个方法中做布局的初始化操作，不建议在init方法中初始化，这个时候可能CollectionView还没有创建，官方文档也有明确说明
     - 如果重写了该方法，一定要调用父类的prepareLayout
     */
    override func prepare() {
        super.prepare()
        
        // layout
        scrollDirection = .horizontal
        minimumLineSpacing = 20

        let inset: CGFloat = 20
        sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
    }
    
    /*
     - 是否允许在里面cell位置改变的时候重新布局
     - 默认是NO，返回YES的话，该方法内部重新会按顺序调用以下2个方法
     - (void)prepareLayout
     - (NSArray *)layoutAttributesForElementsInRect:(CGRect):rect
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /*
     - 该方法的返回值是一个存放着rect范围内所有元素的布局属性的数组
     - 数组里面的对象决定了rect范围内所有元素的排布（frame）
     - 里面存放的都是UICollectionViewLayoutAttributes对象，该对象决定了cell的排布样式
     - 一个cell就对应一个UICollectionViewLayoutAttributes对象，这个对象决定了cell的frame
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 拿到系统已经帮我们计算好的布局属性数组，然后对其进行拷贝一份，后续用这个新拷贝的数组去操作。Swift中是值传递，直接赋值
        let orginalArray = super.layoutAttributesForElements(in: rect)
        let curArray = orginalArray!
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width * 0.5 // 计算collectionView中心点的x值(整个collectionView的，包含在屏幕之外的偏移量
        
        for attrs in curArray {
            // cell的中心点x 和 collectionView最中心点的x值的间距的绝对值，根据间距值计算cell的缩放比例
            let space = abs(attrs.center.x - centerX)
            let scale = 1 - space / collectionView!.bounds.width
            attrs.transform = CGAffineTransform(scaleX: scale, y: scale) // 设置缩放比例
        }

        return curArray
    }

    /*
     - proposedContentOffset：原本情况下，collectionview停止滚动时最终的偏移量
     滑动的时候手松开因为惯性并不会立即停止，会再滚动一会才会真正停止，这个属性就是记录这个真正停止这一刻的偏移量
     - velocity：滚动速率，可以根据velocity的x或y判断它是向上/向下/向右/向左滑动
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // 计算出停止滚动时(不是松手时)最终显示的矩形框
        let rect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)
        
        let array = super.layoutAttributesForElements(in: rect)!
        let centerX = proposedContentOffset.x + collectionView!.bounds.width * 0.5
        
        var minSpace = CGFloat(MAXFLOAT)// 先将间距赋值为最大值，保证第一次一定可以进入这个if条件
        for attrs in array {
            if abs(minSpace) > abs(attrs.center.x - centerX) {
                minSpace = attrs.center.x - centerX
            }
        }

        let changedCenter = CGPoint(x: proposedContentOffset.x + minSpace, y: proposedContentOffset.y)
        
        return changedCenter
    }
}


class ScrollCollectionViewCell: UICollectionViewCell {
    let textLabel = UILabel()
    
    func addText(_ text: String)  {
        backgroundColor = UIColor.clear
        
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = UIColor.cyan.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 5)
        shadowLayer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowRadius = 4
        layer.addSublayer(shadowLayer)
        
        textLabel.frame = bounds
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.darkGray
        textLabel.backgroundColor = UIColor.white
        textLabel.layer.cornerRadius = 5
        textLabel.layer.masksToBounds = true
    
        addSubview(textLabel)
    }
}

// MARK:----------------------- viewController For Test -----------------------
class LTScrollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var data = [["Test", "Tree","section0","bonjue"],["Test", "Tree","section1","bonjue"],["Test", "Tree","section2","bonjue"],["Test", "Tree","section3","bonjue"],["Test", "Tree","section4","bonjue"]]
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollLayout = ScrollFlowLayout()
        scrollLayout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: CGRect(x: 20, y: 60, width: 360, height: 200), collectionViewLayout: scrollLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightGray
        
        collectionView.register(ScrollCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScrollCollectionViewCell
        cell.addText(data[indexPath.section][indexPath.row])
        
        return cell
    }
}


