//
//  ANGraphNodeLayer.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/31/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANGraphNodeLayer.h"

@implementation ANGraphNodeLayer

-(instancetype)init
{
    self = [super init];
    
    _node = nil;
    _layer = nil;
    
    return self;
}

-(ANGraphNodeLayer*)initWith:(ANLayoutNode*)node
{
    self = [super init];
    
    _node = node;
    _layer = [[CALayer alloc] init];
    
    return self;
}

// initalize with node and drawing layer
-(ANGraphNodeLayer*)initWith:(ANLayoutNode*)node layer:(CALayer*) layer
{
    self = [super init];
    
    _node = node;
    _layer = layer;
    
    return self;
}

@end

