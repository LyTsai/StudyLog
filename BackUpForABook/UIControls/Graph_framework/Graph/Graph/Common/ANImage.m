//
//  ANImage.m
//  ATreeRingMap
//
//  Created by hui wang on 2/2/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANImage.h"

@implementation ANImage

// resize
+ (UIImage*) imageWithImage:(UIImage*)image
                scaleToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndPDFContext();
    
    return newImage;
}

-(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
}

//load from local image file
-(id)initWithFile:(NSString*) fileName
{
    self = [super init];
    
    return self;
}

// load from base64 data string
-(id)initWithDataString:(NSString*) base64String
{
    self = [super init];
    
    _image = [self decodeBase64ToImage:base64String];
    
    return self;
}

// paint
-(void)paint:(CGContextRef)ctx
        rect:(CGRect)rect
{
    return ;
}

@end
