//
//  JAMStyledBezierPathFactory.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JAMStyledBezierPath;

/** The JAMStyledBezierPathFactory takes SVG element names and attributes from the SVG parser and generates JAMStyledBezierPaths. */
@interface JAMStyledBezierPathFactory : NSObject


/** Generates a JMStyledPath based on the elementName and attributes from the JMSVGParser. */
- (JAMStyledBezierPath *)styledPathFromElementName:(NSString *)elementName attributes:(NSDictionary *)attributes;

/** Adds a gradient color stop to the local array. */
- (void)addGradientStopWithAttributes:(NSDictionary *)attributes;

/** Gets the viewBox for the svg document. */
- (CGRect)getViewboxFromAttributes:(NSDictionary *)attributes;

@end