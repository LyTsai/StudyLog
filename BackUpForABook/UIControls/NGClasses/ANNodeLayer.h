//
//  ASymbol_Brain.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ANNodeLayer : CALayer

-(void)initWithDefault;

// load into parent page and set up transformation matrix that would map the original view onto given layout
// parentPage -  our new parent layer
// layout - the new frame area
-(void)loadOntoPage:(CALayer*)parentPage layout:(CGRect)layout;

@end

ANNodeLayer* getRandomSymbolPath();
ANNodeLayer* getRandomSymbolPath_Face();
