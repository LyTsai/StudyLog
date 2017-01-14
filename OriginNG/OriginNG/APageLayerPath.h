//
//  APageLayerPath.h
//  AnnieVisualtics-LandingPage
//
//  Created by hui wang on 8/21/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// base class for loading a layer onto page.
// to construct a view page:
// (1) design the page using ai
// (2) break the page into multiple layers
// (3) save each layer into their svg files with the SAME conves size
// (4) convert each layer svg into drawing path using paintdraw with the SAME size
// (5) construct layer object with paths generated from paintdraw
@interface APageLayerPath : CAShapeLayer

// properties

// original canvas size that path were created based on (size when zoom factor is 1.0)
@property  CGPoint pathRefSize;

// methods

// set intrinsic properties such as the original size the layer was created with
-(void)initDrawPros;

-(CGRect)layoutFrame;

// load into parent page and set up transformation matrix that would map the original view onto given layout
// parentPage -  our new parent layer
// layout - the new frame area
-(void)loadOntoPage:(CALayer*)parentPage layout:(CGRect)layout;

// get transformed rect are of a given area from the orginal view
// originalRect - rect area in original view
-(CGRect)transformedRect:(CGRect)originalRect;

@end
