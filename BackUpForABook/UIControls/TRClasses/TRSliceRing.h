//
//  TRSliceRing.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/15/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TRSliceRing : NSObject

// properties

// slice ring look and feel
typedef enum
{
    TRSLICERINGBKG_NULL,            // no background
    TRSLICERINGBKG_SIMPLE,          // simple and plane mode
    TRSLICERINGBKG_METAL            // metal look and feel
}TRSLICERINGBKG;

// look and feel mode
@property TRSLICERINGBKG showType;

// unit font size
@property(nonatomic)float pointsPerFontSize;
@property(nonatomic)BOOL backgroundShadow;
// ring backgrond color
@property(strong, nonatomic)UIColor *bkgColor;
// ring borader color
@property(strong, nonatomic)UIColor *borderColor;
// border line
@property(nonatomic)float lineWidth;
// ring size in font size.  this is the width of the ring
@property(nonatomic)NSInteger size;

///////////////////////////////////////////////////////
// inner and outer ring decorations
// outer decorating ring
// true for gradient color. false for gray color
@property(nonatomic)BOOL outerDecorationRingFocus;

// true if from begin to end for gradient.  false for end to beginning
@property(nonatomic)BOOL outerDecorationGradientColorBegin2End;
@property(nonatomic)float outerDecorationRingSize;
// distance from ring edge
@property(nonatomic)float outerDecorationRingOffset;

// inner decorating ring is a two bands ring with two disticnt colors: high and low
// we have two modes here: black narrow band plus wide grey band, white narrow band pluse width black band
typedef enum
{
    INNERDECORATION_NULL,           // no decoration
    INNERDECORATION_BLACK_GREY,     // black grey
    INNERDECORATION_WHITE_BLACK     // white and black
}INNERDECORATION;

@property(nonatomic)INNERDECORATION innerDecorationStyle;

// end of decoration rings 
///////////////////////////////////////////////////////

// radius - position of ring starting point (inside)
// size - size and width of the ring
// methods
-(void)paint:(CGContextRef)ctx
  startAngle:(float)start
    endAngle:(float)end
      radius:(float)radius
        size:(float)size
      center:(CGPoint)origin;

@end
