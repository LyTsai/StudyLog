//
//  APageLayerPath.m
//  AnnieVisualtics-LandingPage
//
//  Created by hui wang on 8/21/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "Utils.h"
#import "APageLayerPath.h"

@implementation APageLayerPath
{
    @private
    
    // the visual frame size after transformation
    CGRect _layoutFrame;
}

@synthesize pathRefSize;//, page;

-(void)initDrawPros
{
    pathRefSize = CGPointMake(1024, 768);
    _layoutFrame = CGRectZero;
}

-(CGRect)layoutFrame
{
    return _layoutFrame;
}

-(void)dealloc
{
    if (self.superlayer != nil)
    {
        [self removeFromSuperlayer];
    }
}

// load into parent page
// parentPage - new parent layer
// layout - new frame rect area on the new parent layer
-(void)loadOntoPage:(CALayer*)parentPage
             layout:(CGRect)layout
{
    // make sure that we are disconnected from parent page and reverse back to I transformation
    [self removeFromSuperlayer];
    [self setAffineTransform:CGAffineTransformIdentity];
    
    // connect to the new parent
    [parentPage addSublayer:self];
    
    // set frame
    self.frame = layout;
}

// overwrite setFrame to use automate transformation
-(void)setFrame:(CGRect)frame
{
    // make sure that we are disconnected from parent page and reverse back to I transformation
    [self setAffineTransform:CGAffineTransformIdentity];
    
    // set to source size (original image size) first
    // !!! make sure setBounds is not overwrited because of this
    super.frame = CGRectMake(0, 0, pathRefSize.x, pathRefSize.y);
    
    // set transform matrix that would do: size. self.frame => layout
    [self setAffineTransform:getFitTransformEx(frame, self.frame, false)];
    
    _layoutFrame = frame;
    
    // set for displaying
    [self setNeedsDisplay];
}

// get transformed rect are of a given area from the orginal view
// originalRect - rect area in original view
// !!! make sure to adjust originalRect to the center point coordinate that CALayer is using
// the range of this layer is define by pathRefSize
-(CGRect)transformedRect:(CGRect)originalRect
{
    CGRect rc;
    CGPoint pt, pt1, pt2;
    
    pt1 = originalRect.origin;
    pt2 = originalRect.origin;
    pt2.x += originalRect.size.width;
    pt2.y += originalRect.size.height;
    
    // based on (.5 * pathRefSize.x, .5 * pathRefSize.y) origin
    pt1.x -= .5 * pathRefSize.x;
    pt1.y -= .5 * pathRefSize.y;
    pt2.x -= .5 * pathRefSize.x;
    pt2.y -= .5 * pathRefSize.y;
    
    rc.origin = CGPointApplyAffineTransform(pt1, self.affineTransform);
    // back in (0, 0) origin
    rc.origin.x += .5 * pathRefSize.x;
    rc.origin.y += .5 * pathRefSize.y;
    
    pt = CGPointApplyAffineTransform(pt2, self.affineTransform);
    // back in (0, 0) origin
    pt.x += .5 * pathRefSize.x;
    pt.y += .5 * pathRefSize.y;
    
    rc.size.width = pt.x - rc.origin.x;
    rc.size.height = pt.y - rc.origin.y;
    
    return rc;
}

@end
