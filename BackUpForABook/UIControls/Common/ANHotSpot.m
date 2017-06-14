//
//  ANHotSpot.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANHotSpot.h"

@implementation ANHotSpot

-(id)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    _center.x = 0;
    _center.y = 0;
    _size.width = .0;
    _size.height = .0;
    _symbol = nil;
    
    return self;
}

-(id)initWith:(CGPoint)center
         size:(CGSize)size
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    _center = center;
    _size = size;
    _symbol = nil;
    
    return self;
}

@end
