//
//  TRShowStyle.m
//  ATreeRingMap
//
//  Created by Hui Wang on 6/1/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRShowStyle.h"

@implementation TRShowStyle

// methods
-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _show = TRUE;
        _withShadow = FALSE;
        _withTransparency = FALSE;
    }
    
    return self;
}
@end
