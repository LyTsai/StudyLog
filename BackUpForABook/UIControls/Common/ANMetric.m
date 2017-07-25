//
//  ANMetric.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANMetric.h"

@implementation ANMetric
{
    // normal ranges
    NSMutableArray* _normalRanges;

    // valid ranges
    NSMutableArray* _validRanges;
}

-(instancetype) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _normalRanges = [[NSMutableArray alloc] init];
    _validRanges = [[NSMutableArray alloc] init];
    
    return self;
}

-(NSArray*) normalRanges
{
    return _normalRanges;
}

-(NSArray*) validRanges
{
    return _validRanges;
}

// add normal range
-(void) addNormalRange:(NSString*)name
                  info:(NSString*)info
                  type:(ANRangeType)type
                   min:(double)min
                   max:(double)max
{
    if (_normalRanges == nil)
    {
        _normalRanges = [[NSMutableArray alloc] init];
    }
    
    ANRange* range = [[ANRange alloc] init];
    
    range.name = name;
    range.info = info;
    range.valid_type = type;
    range.valid_min = min;
    range.valid_max = max;
    
    [self addNormalRange:range];
}

// add valid range
-(void) addValidRange:(NSString*)name
                 info:(NSString*)info
                 type:(ANRangeType)type
                  min:(double)min
                  max:(double)max
{
    if (_validRanges == nil)
    {
        _validRanges = [[NSMutableArray alloc] init];
    }
    
    ANRange* range = [[ANRange alloc] init];
    
    range.name = name;
    range.info = info;
    range.valid_type = type;
    range.valid_min = min;
    range.valid_max = max;
    
    [self addValidRange:range];
}

-(void) addNormalRange:(ANRange*)range
{
    [_normalRanges addObject:range];
}
-(void) addValidRange:(ANRange*)range
{
    [_validRanges addObject:range];
}

@end
