//
//  AImage_LifeStyle0.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 8/31/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "AImage_LifeStyle0.h"

@implementation AImage_LifeStyle0
{
    @private
    
    CAShapeLayer *_imageLayer;
}

// !!! over write initDrawPros and setFrame to avoid the default behaviros
-(void)initDrawPros
{
    _imageLayer = [CAShapeLayer layer];
    _imageLayer.contents = (id) [UIImage imageNamed:@"lifestyle.png"].CGImage;
    _imageLayer.masksToBounds = YES;
    _imageLayer.borderColor = [UIColor clearColor].CGColor;
    _imageLayer.backgroundColor = [UIColor clearColor].CGColor;
}

-(void)setFrame:(CGRect)frame
{
    _imageLayer.frame = frame;
}

-(void)loadOntoPage:(CALayer*)parentPage
             layout:(CGRect)layout
{
    // map to _imageLayer
    if (_imageLayer && _imageLayer.superlayer)
    {
        [_imageLayer removeFromSuperlayer];
    }
    
    // connect to the new parent
    [parentPage addSublayer:_imageLayer];
    
    // set frame
    _imageLayer.frame = layout;
}

@end
