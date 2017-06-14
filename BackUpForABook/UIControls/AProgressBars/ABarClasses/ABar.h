//
//  ABar.h
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ANText.h"

@interface ABar : NSObject
{
    
}

// hold bar information for processing (instead of drawing)
// length or height of bar to represent the value that is mapped to its visual presentation
// in many cases the min and max of a value is not known and we need to mapp the value to visual presentation
// the bar length here means to take this much percentage of full bar visual range
@property float height;
// main color
@property(strong, nonatomic)UIColor* color1;
// secondary color in case of gradient color
@property(strong, nonatomic)UIColor* color2;
// numberical value
@property float val;
// display name
@property(strong, nonatomic)ANText* text;

-(id)initWith:(UIColor*)color1
       color2:(UIColor*)color2
       height:(float)height
        value:(float)value
         text:(NSString*)text;

@end
