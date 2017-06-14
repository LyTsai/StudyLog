//
//  ANImage.h
//  ATreeRingMap
//
//  Created by hui wang on 2/2/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Provide various image manipulation functions
@interface ANImage : NSObject

// properties
// access to image
@property(nonatomic, strong)UIImage* image;

// functions

// resize
+ (UIImage*) imageWithImage:(UIImage*)image
                scaleToSize:(CGSize)newSize;

// load from file
-(id)initWithFile:(NSString*) fileName;

// load from base64 data string
-(id)initWithDataString:(NSString*) base64String;

// paint
-(void)paint:(CGContextRef)ctx
        rect:(CGRect)rect;

@end
