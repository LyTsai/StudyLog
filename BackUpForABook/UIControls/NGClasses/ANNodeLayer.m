//
//  ASymbol_Brain.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANNodeLayer.h"

@implementation ANNodeLayer
{
    @private

    CAShapeLayer *_imageLayer;
}

-(void)initWithDefault
{
    _imageLayer = [CAShapeLayer layer];
    _imageLayer.contents = (id) [UIImage imageNamed:@"face_red@3x.png"].CGImage;
    _imageLayer.masksToBounds = YES;
    _imageLayer.borderColor = [UIColor clearColor].CGColor;
    _imageLayer.backgroundColor = [UIColor clearColor].CGColor;
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    CGContextSetLineWidth(ctx, 2.0);
    
    [rectanglePath fill];
    
    UIGraphicsPopContext();
    CGContextRestoreGState(ctx);
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


ANNodeLayer* getRandomSymbolPath()
{
    ANNodeLayer* obj = [[ANNodeLayer alloc] init];
    
    [obj initWithDefault];
    
    return obj;
}

ANNodeLayer* getRandomSymbolPath_Face()
{
    ANNodeLayer* obj = [[ANNodeLayer alloc] init];
    
    [obj initWithDefault];
    
    return obj;
}


