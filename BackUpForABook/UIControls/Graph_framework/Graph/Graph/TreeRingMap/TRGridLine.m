//
//  TRGridLine.m
//  ATreeRingMap
//
//  Created by hui wang on 12/20/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "TRGridLine.h"

@implementation TRGridLine

-(id)init
{
    self = [super init];
    
    _style = GridLine_Solid;
    _size = 2;
    _color = [UIColor whiteColor];
    
    return self;
}

@end
