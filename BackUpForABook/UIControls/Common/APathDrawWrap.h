//
//  APathDrawWrap.h
//  AProgressBars
//
//  Created by hui wang on 7/13/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "APathDraw.h"

// wrap around a path drawing based layer object.  used for loading a symbol CALayer into a circle etc 
@interface APathDrawWrap : CAShapeLayer
{
    
}

// properties
// embeded path drawing based object
@property(strong, nonatomic)APathDraw* pathDraw;

// properties for background drawing
// edge type: circle, oval

// space between path draw object and bounds edge
@property int space;

// method
-(id)initWith:(CGRect)frame
     pathDraw:(APathDraw*)pathDraw;

@end
