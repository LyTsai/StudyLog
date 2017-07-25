//
//  APathDrawWrap.m
//  AProgressBars
//
//  Created by hui wang on 7/13/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APathDrawWrap.h"
#import "Utils.h"

@interface APathDrawWrap (PrivateMethods)

// set up shape path
-(void)setShapePath;

@end

@implementation APathDrawWrap

-(id)initWith:(CGRect)frame
     pathDraw:(APathDraw*)pathDraw
{
    if (self == nil)
    {
        return self;
    }
    
    // call parent to init
    self = [super init];
    
    // default value
    self.strokeColor = [UIColor lightGrayColor].CGColor;
    self.lineWidth = 1.0;
    
    // add _pathDraw layer
    [self addSublayer:pathDraw];
    
    // record the embeded object
    _pathDraw = pathDraw;
    
    // set freame via calling setFrame
    self.frame = frame;
    
    // background edge drawing properties
    _space = 4;
    
    self.fillColor = [UIColor whiteColor].CGColor;
    
    self.backgroundColor = [UIColor clearColor].CGColor;
    
    return self;
}
 
-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self setShapePath];
    
    // setup _pathDraw
    if (_pathDraw != nil)
    {
        // anchor position at the center
        [_pathDraw setAnchorPoint:CGPointMake(.5, .5)];
        [_pathDraw setPosition:CGPointMake(.0, .0)];
        
        // !!! has to set the frame to its original full path size
        [_pathDraw setAffineTransform:CGAffineTransformIdentity];
        
        // !!! make sure set the transform to unit before setting the frame to avoid the left over from previous transform
        _pathDraw.frame = CGRectMake(0, 0, _pathDraw.pathRefSize.x, _pathDraw.pathRefSize.y);
        
        // transformation to within bounds area
        [_pathDraw setAffineTransform:getFitTransform(CGRectInset(bounds, _space, _space), _pathDraw.frame)];
        
        // !!! refresh it
        [_pathDraw setNeedsDisplay];
    }
}

// set up shape path
-(void) setShapePath
{
    // set shape path by shape type
    self.path = [UIBezierPath bezierPathWithOvalInRect: CGRectInset(self.bounds, .5, .5)].CGPath;
    
    /*
    // shadow
    self.shadowRadius = .5;
    self.shadowColor = [UIColor blackColor].CGColor;
    self.shadowOpacity = .5;
    self.shadowOffset = CGSizeMake(0.0, 0.0);
    */
}

@end
