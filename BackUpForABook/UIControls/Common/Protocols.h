//
//  Protocols.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#ifndef AnnieVisualyticsPageView_Protocols_h
#define AnnieVisualyticsPageView_Protocols_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// protocol for progress bar / chart views

@protocol AProgress <NSObject>
// class key
-(NSString*)getKey;
// data set
-(void)setUnit:(NSString*)unit;
-(void)setValue:(double)value;
-(void)setMin:(double)value;
-(void)setMax:(double)value;

-(void)setColor:(UIColor*)color;
-(void)setIndicatorColor:(UIColor*)color;

@end

// protocol for collection view components
@protocol AVLObj <NSObject>

// information about THIS object
// class key identifying this object class.  can be class key, object name or ID etc
-(NSString*)getKey;
// match to this object?
-(bool)match:(NSString*)key;

@end

////////////////////////////////////////////////////////
// protocol for collection view layout
////////////////////////////////////////////////////////

@protocol AVLHotSpotLayout <NSObject>

/////////////////////////////////////////////////////////////////////
// visual layout changes requests
/////////////////////////////////////////////////////////////////////

// set focusing element
-(void)setFocusingElement:(NSIndexPath*) indexPath;

// support for "hot spot":
// number of availible "hot spot"
-(NSInteger)numberOfHotSpots;

// obtain one hot spot
// get prefered hot spot (in current coordinate) for given index
-(CGRect)hotSpot_OnPage:(NSInteger)index;

// center position
-(CGRect)center_OnPage;

@end

#endif
