//
//  JAMSVGParser.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** JAMSVGParser uses NSXMLParser to parse SVG documents and extract graphic data. The end result is an array of JAMStyledBezierPaths that are used by JAMSVGImage and JAMSVGImageView to draw these resolution-independent vector graphics. */
@interface JAMSVGParser : NSObject

/** The array of JAMStyledBezierPaths. */
@property (nonatomic) NSMutableArray *paths;
/** The viewBox from the SVG document. This is used to configure the JAMSVGImage size property. */
@property (nonatomic) CGRect viewBox;

/** Initializers for file path and data. */
- (id)initWithSVGDocument:(NSString *)path;
- (id)initWithSVGData:(NSData *)data;

/** Triggers the parsing of the SVG XML data. */
- (BOOL)parseSVGDocument;

@end