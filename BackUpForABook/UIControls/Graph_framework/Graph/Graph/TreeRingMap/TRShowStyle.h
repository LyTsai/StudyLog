//
//  TRShowStyle.h
//  ATreeRingMap
//
//  Created by Hui Wang on 6/1/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Define.h"

// basic tree ring map component visual style information.
// used by tree ring map components (such as TRLabel for example) for show information
@interface TRShowStyle : NSObject

// properties:
// show / hide
@property(nonatomic)BOOL show;
// size
@property(nonatomic)NSInteger size;
// shadow
@property(nonatomic)BOOL withShadow;
// transparent
@property(nonatomic)BOOL withTransparency;
// face color
@property(strong, nonatomic)UIColor *faceColor;
// background color
@property(strong, nonatomic)UIColor *backgroundColor;
// gradient color
@property(strong, nonatomic)UIColor *beginColor;
@property(strong, nonatomic)UIColor *endColor;
// image attachment if there is any
@property(strong, nonatomic)UIImage *image;
@end
