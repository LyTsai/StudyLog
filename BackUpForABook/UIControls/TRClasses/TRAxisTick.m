//
//  TRAxisTick.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/25/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRAxisTick.h"

@implementation TRAxisTick

-(id)initWith:(NSInteger)index
 viewPosition:(float)viewOffset
        space:(float)viewSpace
{
    self = [super init];
    
    _gridIndex = index;
    _viewOffset = viewOffset;
    _viewSpace = viewSpace;
    _label = [[TRLabel alloc] init];
     
    _label.fullString = [NSString stringWithFormat:@"Red Blood Cell Count %d", _gridIndex];
    _label.shortString = [NSString stringWithFormat:@"Diabetes %d", _gridIndex];
    
    //_label.fullString = [NSString stringWithFormat:@"%d", _gridIndex];
    //_label.shortString = [NSString stringWithFormat:@"%d", _gridIndex];

    return self;
}

-(id)init
{
    self = [super init];
    
    _gridIndex = 0;
    _viewOffset = 0;
    _viewSpace = 8.0;
    
    _label = [[TRLabel alloc] init];
    
    _label.fullString = [NSString stringWithFormat:@"Red Blood Cell Count %d", _gridIndex];
    _label.shortString = [NSString stringWithFormat:@"Diabetes %d", _gridIndex];
    
    return self;
}

@end
