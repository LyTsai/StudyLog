//
//  iCarousel.swift
//  UIDesignCollection
//
//  Created by iMac on 16/10/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//  https://github.com/nicklockwood/iCarousel
//

import Foundation
import UIKit

enum CarouselType: Int {
    case Linear             = 0
    case Rotary
    case InvertedRotory
    case Cylinder
    case InvertedCylinder
    case CoverFlow
    case CoverFlow2
}

enum CarouselOption: Int {
    case Wrap               = 0
    case ShowBackfaces
    case OffsetMultiplier
}

@objc protocol CarouselDataSource {
    func numberOfItemsInCarouselView(carouselView: CarouselView) -> Int
    func carouselView(carouselView: CarouselView, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    
    optional func numberOfPlaceholdersInCarouselView(carouselView: CarouselView) -> Int
    optional func carouselView(carouselView: CarouselView, placeholderViewAtIndex index:Int, reusingView view: UIView?) -> UIView
}

@objc protocol CarouselDelegate {
    optional func carouselWillBeginScrollingAnimation(carouselView: CarouselView)
    optional func carouselDidEndScrolllingAnimation(carouselView: CarouselView)
    optional func carouselDidScroll(carouselView: CarouselView)
    optional func carouselCurrentItemIndexDidChange(carouselView: CarouselView)
    optional func carouseWillBeginDragging(carouselView: CarouselView)
    optional func carouselDidEndDragging(carouselView: CarouselView, willDecelerate:Bool)
    
//    - (void)carouselWillBeginDecelerating:(iCarousel *)carousel;
//    - (void)carouselDidEndDecelerating:(iCarousel *)carousel;
//    
//    - (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index;
//    - (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;
//    
//    - (CGFloat)carouselItemWidth:(iCarousel *)carousel;
//    - (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;
//    - (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

}
//
//@implementation NSObject (iCarousel)
//
//- (NSUInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel { return 0; }
//    - (void)carouselWillBeginScrollingAnimation:(__unused iCarousel *)carousel {}
//        - (void)carouselDidEndScrollingAnimation:(__unused iCarousel *)carousel {}
//            - (void)carouselDidScroll:(__unused iCarousel *)carousel {}
//                
//    - (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {}
//                    - (void)carouselWillBeginDragging:(__unused iCarousel *)carousel {}
//                        - (void)carouselDidEndDragging:(__unused iCarousel *)carousel willDecelerate:(__unused BOOL)decelerate {}
//      - (void)carouselWillBeginDecelerating:(__unused iCarousel *)carousel {}
//                                - (void)carouselDidEndDecelerating:(__unused iCarousel *)carousel {}
//                                    
//                                    - (BOOL)carousel:(__unused iCarousel *)carousel shouldSelectItemAtIndex:(__unused NSInteger)index { return YES; }
//                                        - (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(__unused NSInteger)index {}
//                                            
//       - (CGFloat)carouselItemWidth:(__unused iCarousel *)carousel { return 0; }
//     - (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(__unused CGFloat)offset
//baseTransform:(CATransform3D)transform { return transform; }
//    - (CGFloat)carousel:(__unused iCarousel *)carousel
//valueForOption:(__unused iCarouselOption)option
//withDefault:(CGFloat)value { return value; }
//
//@end

class CarouselView: UIView {
    
    // MARK: ------------
    var dataSource: CarouselDataSource! {
        willSet{
            if  dataSource !== newValue && newValue != nil {
                reloadData()
            }
        }
    }
    
    var delegate: CarouselDelegate!{
        willSet {
            if delegate !== newValue && newValue != nil && dataSource != nil {
                setNeedsLayout()
            }
        }
    }
    
    var type: CarouselType = .Rotary {
        willSet {
            if type != newValue {
                layoutItemViews()
            }
        }
    }
    var prespective: CGFloat = -1.0/500.0
    var decelerationRate: CGFloat = 0.95
    var scrollSpeed: CGFloat = 1.0
    
    var scrollEnabled = true
    var isScrollEnabled: Bool { return scrollEnabled }
    var pagingEnabled = true
    var isPagingEnabled: Bool { return pagingEnabled }
    var vertical = true {
        willSet{
            if vertical != newValue {
                layoutItemViews()
            }
        }
    }
    var isVertical: Bool { return vertical }
    var wrapEnabled = true
    var isWrapEnabled: Bool { return wrapEnabled }
    
    private var contentView: UIView!
    private var itemView = [UIView]()
    
    //    @property (nonatomic, strong) NSMutableSet *itemViewPool;
    //    @property (nonatomic, strong) NSMutableSet *placeholderViewPool;
    
    private var previousScrollOffset: CGFloat = 0
    private var previousItemIndex: Int = 0
    
    //    @property (nonatomic, assign) NSInteger numberOfPlaceholdersToShow;
    //    @property (nonatomic, assign) NSInteger numberOfVisibleItems;
    //    @property (nonatomic, assign) CGFloat itemWidth;
    //    @property (nonatomic, assign) CGFloat offsetMultiplier;
    private var startOffset: CGFloat = 0
    private var endOffset: CGFloat = 0
    
    //    @property (nonatomic, assign) NSTimeInterval scrollDuration;
    
    private var scrolling = true
    private var isScrolling: Bool { return scrolling }
   
    //    @property (nonatomic, assign) NSTimeInterval startTime;
    //    @property (nonatomic, assign) NSTimeInterval lastTime;
    //    @property (nonatomic, assign) CGFloat startVelocity;
    //    @property (nonatomic, strong) NSTimer *timer;
    private var decelerating = true
    private var isDecelerating: Bool { return decelerating }
    
    //    @property (nonatomic, assign) CGFloat previousTranslation;
    //    @property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;
    //    @property (nonatomic, assign, getter = isDragging) BOOL dragging;
    //    @property (nonatomic, assign) BOOL didDrag;
    //    @property (nonatomic, assign) NSTimeInterval toggleTime;
    //    
    //    NSComparisonResult compareViewDepth(UIView *view1, UIView *view2, iCarousel *self);

    
    var bounces = true
    var scrollOffset: CGFloat = 1.0 {
        willSet {
            scrolling = false
            decelerating = false
            startOffset = newValue
            endOffset = newValue
            
            if fabs(scrollOffset - newValue) > 0.0 {
                depthSortViews()
                didScroll()
            }
        }
    }
    
    
    var offsetMultiplier: CGFloat { return 1.0 }
    var contentOffset = CGSizeZero
    var viewPointOffset = CGSizeZero
    
    var numberOfItems: Int {
        return dataSource.numberOfItemsInCarouselView(self)
    }
    var numberOfPlaceholders: Int {
        return dataSource.numberOfItemsInCarouselView(self)
    }
    var currentItemIndex: Int = 0
    
//    @property (nonatomic, strong, readonly) UIView * __nullable currentItemView;
//    @property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
//    @property (nonatomic, readonly) NSInteger numberOfVisibleItems;
//    @property (nonatomic, strong, readonly) NSArray *visibleItemViews;
//    @property (nonatomic, readonly) CGFloat itemWidth;
//    @property (nonatomic, strong, readonly) UIView *contentView;
//    @property (nonatomic, readonly) CGFloat toggle;
    
    var autoscroll: CGFloat = 0
    
//    @property (nonatomic, assign) CGFloat autoscroll;
//    @property (nonatomic, assign) BOOL stopAtItemBoundary;
//    @property (nonatomic, assign) BOOL scrollToItemBoundary;
//    @property (nonatomic, assign) BOOL ignorePerpendicularSwipes;
//    @property (nonatomic, assign) BOOL centerItemWhenSelected;
//    @property (nonatomic, readonly, getter = isDragging) BOOL dragging;
//    @property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
//    @property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;
//    
//    - (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
//    - (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
//    - (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
//    - (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
//    - (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
//    
//    - (nullable UIView *)itemViewAtIndex:(NSInteger)index;
//    - (NSInteger)indexOfItemView:(UIView *)view;
//    - (NSInteger)indexOfItemViewOrSubview:(UIView *)view;
//    - (CGFloat)offsetForItemAtIndex:(NSInteger)index;
//    - (nullable UIView *)itemViewAtPoint:(CGPoint)point;
//    
//    - (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
//    - (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
//    - (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;
//    
//    
    func reloadData() {
        
    }
    
    private func layoutItemViews(){
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    private func depthSortViews() {
    
    }
    
    private func didScroll(){
        
    }
    deinit {
        // stopAnimation
    }
    
    private func setUp() {
        
    }
    
}