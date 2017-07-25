//
//  JAMSVGGradientParts.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** The SVG Gradient object and its two subtypes */
@interface JAMSVGGradient : NSObject
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSMutableArray *colorStops;
@property (nonatomic) NSValue *gradientTransform;
@end

@interface JAMSVGLinearGradient : JAMSVGGradient
@property CGPoint startPosition;
@property CGPoint endPosition;
@end

@interface JAMSVGRadialGradient : JAMSVGGradient
@property CGPoint position;
@property CGFloat radius;
@end

/** ColorStop wraps up a color and position. */
@interface JAMSVGGradientColorStop : NSObject
- (id)initWithColor:(UIColor *)color position:(CGFloat)position;
@property (nonatomic) UIColor *color;
@property CGFloat position;
@end
