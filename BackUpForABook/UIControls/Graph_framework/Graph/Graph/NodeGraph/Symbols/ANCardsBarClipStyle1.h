//
//  ANCardsBarClipStyle1.h
//  ABook_iPhone
//
//  Created by hui wang on 5/2/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "APageLayerPath.h"

@interface ANCardsBarClipStyle1 : APageLayerPath

@property(readonly) float edgeOffset;

//// Color Declarations
@property(strong, nonatomic)UIColor* gradientColor1;
@property(strong, nonatomic)UIColor* gradientColor2;
@property(strong, nonatomic)UIColor* gradientColor3;
@property(strong, nonatomic)UIColor* gradientColor4;
@property(strong, nonatomic)UIColor* fillColor1;
@property(strong, nonatomic)UIColor* fillColor2;
@property(strong, nonatomic)UIColor* textForeground;

// label
@property(strong, nonatomic)NSString* label;

@end
