//
//  ABar.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ABar.h"

@implementation ABar

-(id)initWith:(UIColor*)color1
       color2:(UIColor*)color2
       height:(float)height
        value:(float)value
         text:(NSString*)text
{
    self = [super init];
    
    //_color1 = [UIColor colorWithRed: .9 green: 0.2 blue: 0.2 alpha: .8];
    
    _color1 = color1;
    _color2 = color2;
    _height = height;
    _val = value;
    
    _text = [[ANText alloc] initWithFont:@"Helvetica Bold" size:10.0 shadow:FALSE underline:FALSE];
    _text.text = [[NSMutableString alloc] initWithString:text];
    
    _text.textFillColor = [UIColor darkTextColor];
    _text.textStrokeWidth = -1.0;

    return self;
}

@end
