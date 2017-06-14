//
//  TRLegend.h
//  ATreeRingMap
//
//  Created by hui wang on 12/30/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricView.h"
#import "ANText.h"

// legend element alignment type
typedef enum
{
    TRLegendAlignment_None   = 1,
    TRLegendAlignment_LT,
    TRLegendAlignment_LB,
    TRLegendAlignment_RT,
    TRLegendAlignment_RB
}TRLegendAlignment;

@interface TRLegend : NSObject{
    // collection of key - ANMetricView pairs
    NSMutableDictionary* _metricViews;
    
    // collection of key - ANText pairs
    NSMutableDictionary* _metricLabels;
    
    // keys in the order added
    NSMutableArray* _keys;
}

// add one legend entry
-(void)addEntry:(NSString*)key
           view:(ANMetricView*)view
          label:(ANText*)label;

// get view object for the given key
-(ANMetricView*)getView:(NSString*)key;

// get label object for the given key
-(ANText*)getLabel:(NSString*)key;

// get all keys
-(NSArray*)keys;

// paint selected labels in the order of keys specified in the array
// ctx - CGContextRef
// orderByKeys - oder to draw legend element
// alignment - way to align the element
// lineSpace - distance between lines
// position - left - top position
// return end position
-(CGPoint)paint:(CGContextRef)ctx
    orderByKeys:(NSArray*)orderByKeys
      alignment:(TRLegendAlignment) alignment
      lineSpace:(float) lineSpace
       position:(CGPoint)position;

@end
