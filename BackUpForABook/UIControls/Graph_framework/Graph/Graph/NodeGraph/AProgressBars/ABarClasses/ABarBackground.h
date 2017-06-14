//
//  ABarBackground.h
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// defines background style, size and drawing properties such as color, gradient or line size etc
@interface ABarBackground : NSObject
{
    
}

// properties

// style: rect, pie

// color
@property(strong, nonatomic)UIColor* bkgColor;

// gradient
@property BOOL showGradient;

-(void)initPros;

@end
