//
//  JAMSVGGradientParts.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "JAMSVGGradientParts.h"

@implementation JAMSVGGradient

- (id)init;
{
    if (!(self = [super init])) return nil;
    
    self.colorStops = NSMutableArray.new;
    return self;
}

@end

@implementation JAMSVGLinearGradient
@end

@implementation JAMSVGRadialGradient
@end

@implementation JAMSVGGradientColorStop
- (id)initWithColor:(UIColor *)color position:(CGFloat)position;
{
    if (!(self = [super init])) return nil;
    
    self.color = color;
    self.position = position;
    return self;
}

@end