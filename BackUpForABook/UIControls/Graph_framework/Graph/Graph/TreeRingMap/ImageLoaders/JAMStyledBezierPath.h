//
//  JAMStyledBezierPath.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** The JAMStyledBezierPath class encapsulates a UIBezierPath object and styling information (fill, stroke, etc.) */
@interface JAMStyledBezierPath : NSObject

// drawing function
- (void)drawStyledPath:(CGContextRef)context;
@end
