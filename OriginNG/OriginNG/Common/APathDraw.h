//
//  APathDraw.h
//  AProgressBars
//
//  Created by hui wang on 7/13/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface APathDraw : CALayer
{
    
}

// properties
// size that path were created based on
@property  CGPoint pathRefSize;

// path stroke size
@property int pathThickness;
// color of path edge stroke
@property(strong, nonatomic)UIColor* pathEdgeColor;
// color of path fill
@property(strong, nonatomic)UIColor* pathFillColor;

// methods
-(void)initDrawPros;

@end
