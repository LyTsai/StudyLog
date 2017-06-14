//
//  TRMLabels.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANNamedText.h"

// alignment type
typedef enum
{
    TRMTextAlignment_None   = 1,
    TRMTextAlignment_LT,
    TRMTextAlignment_LB,
    TRMTextAlignment_RT,
    TRMTextAlignment_RB
}TRMTextAlignment;

// represents line of text on tree ring map
@interface TRMLabels : NSObject{
    
    // collection of name - TRLabel pairs
    NSMutableDictionary* _labels;
    
    // keys in the order added
    NSMutableArray* _keys;
}

// add one label field
-(void)addLabel:(NSString*)key
          label:(ANNamedText*)label;

// get label object
-(ANNamedText*)getLabel:(NSString*)key;

// get all keys
-(NSArray*)keys;

// paint selected labels in the order of keys specified in the array
// return end position
-(CGPoint)paint:(CGContextRef)ctx
    orderByKeys:(NSArray*)orderByKeys
      alignment:(TRMTextAlignment) alignment
      lineSpace:(float) lineSpace
       position:(CGPoint)position;

@end