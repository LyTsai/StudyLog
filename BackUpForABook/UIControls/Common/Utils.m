//
//  Utils.m
//  ATreeLifeStyle
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

// create transform for fitting layer into given rect area
// !! asume the archor point is at the center
// rect - target rect area to fit into
// srcRect - original react area 
CGAffineTransform getFitTransform(CGRect rect, CGRect srcRect)
{
    // (1) shift to center position of rect
    float dx = rect.origin.x + .5 * rect.size.width - (srcRect.origin.x + .5 * srcRect.size.width);
    float dy = rect.origin.y + .5 * rect.size.height - (srcRect.origin.y + .5 * srcRect.size.height);
    
    // (2) scale (around new srcRect center)
    // assume by x first
    float r = rect.size.width / srcRect.size.width;
    // shift to line up to the edge
    float dx1 = 0.0;
    float dy1 = rect.origin.y - (rect.origin.y + .5 * rect.size.height - .5 * r * srcRect.size.height);
    
    if ((rect.size.height / srcRect.size.height) < r)
    {
        // by y
        r = rect.size.height / srcRect.size.height;
        dy1 = .0;
        dx1 = rect.origin.x - (rect.origin.x + .5 * rect.size.width - .5 * r * srcRect.size.width);
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, dx, dy);
    transform = CGAffineTransformScale(transform, r, r);
    transform = CGAffineTransformTranslate(transform, dx1, dy1);
    
    return transform;
}

// new version
// return a transform that would map srcRect onto rect whille keeping the respect ratio
// if bShiftToLeftTop is true then also try to move to left / top position
CGAffineTransform getFitTransformEx(CGRect rect, CGRect srcRect, bool bShiftToLeftTop)
{
    CGPoint shif;
    CGPoint shift1;
    float rx, ry, r = 1.0;
    
    // (1) shift to the center
    shif.x = rect.origin.x + .5 * rect.size.width - (srcRect.origin.x + .5 * srcRect.size.width);
    shif.y = rect.origin.y + .5 * rect.size.height - (srcRect.origin.y + .5 * srcRect.size.height);
    
    // (2) compute scale first
    rx = rect.size.width / srcRect.size.width;
    ry = rect.size.height / srcRect.size.height;
    
    if (rx <= ry)
    {
        // scale by x
        r = rx;
        
        shift1.x = 0.0;
        shift1.y = -((rect.size.height - srcRect.size.height * r) * .5) / r;
    }else
    {
        // scale by y
        r = ry;

        shift1.y = .0;
        shift1.x = -((rect.size.width - srcRect.size.width * r) * .5) / r;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, shif.x, shif.y);
    transform = CGAffineTransformScale(transform, r, r);
    
    if (bShiftToLeftTop)
    {
        transform = CGAffineTransformTranslate(transform, shift1.x, shift1.y);
    }
    
    return transform;
}

@implementation Utils

+(MetricClass) MetricClassOfNumber:(int) number
{
    if (number == 1)
    {
        return MetricClass_Classification;
    }else if (number == 2)
    {
        return MetricClass_Measurement;
    }else
    {
        return MetricClass_Unknown;
    }
}
+(ANRangeType) RangeTypeOfNumber:(int) number
{
    switch (number) {
        case 1:
            return RangeType_NA;
        case 2:
            return RangeType_MinMax;
        case 3:
            return RangeType_MinEquMax;
        case 4:
            return RangeType_MinMaxEqu;
        case 5:
            return RangeType_MinEquMaxEqu;
        case 6:
            return RangeType_Min;
        case 7:
            return RangeType_MinEqu;
        case 8:
            return RangeType_Max;
        case 9:
            return RangeType_MaxEqu;
        case 10:
            return RangeType_NOTEqu;
        default:
            return RangeType_Equ;
    }
}
+(UNIT)UnitOfNumber:(int)number{
    switch (number) {
        case 0:
            return UNIT_ABS;
        case 1:
            return UNIT_ARB;
        case 2:
            return UNIT_PERCENT;
        case 3:
            return UNIT_MGDL;
        case 4:
            return UNIT_MMHG;
        default:
            return UNIT_YEARS;
    }


}

@end
