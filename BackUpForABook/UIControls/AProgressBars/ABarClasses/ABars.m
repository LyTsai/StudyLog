//
//  ABars.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ABars.h"

@implementation ABars

-(void)initPros:(NSString*)key
     metricName:(NSString*)metricName
           unit:(NSString*)unit
           bars:(NSArray*)bars
{
    _key = key;
    _minVal = .0;
    _maxVal = 100.0;
    _backGround = [[ABarBackground alloc] init];
    _sizeWeight = 1.0;
    _style = BARSTYLE_NULL;
    
    [_backGround initPros];
    
    _bars = [[NSMutableArray alloc] initWithArray:bars];
    
    // metric and unit strings
    _metricName = [[ANText alloc] initWithFont:@"Helvetica Bold" size:10.0 shadow:FALSE underline:FALSE];
    _metricName.text = [[NSMutableString alloc] initWithString:metricName];
 
    _metricName.textFillColor = [UIColor darkTextColor];
    _metricName.textStrokeWidth = -1.0;
    
    _unitStr = [[ANText alloc] initWithFont:@"Helvetica" size:10.0 shadow:FALSE underline:FALSE];
    _unitStr.text = [[NSMutableString alloc] initWithString:unit];
  
    _unitStr.textFillColor = [UIColor darkTextColor];
    _unitStr.textStrokeWidth = -1.0;
}

@end
