//
//  ANClassFactory.m
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANClassFactory.h"

//////////////////////////////////////////////////
// progress indicator
//////////////////////////////////////////////////
#import "ABatteryBar.h"

AProgressIndicator* createProgressIndicator(NSString* type)
{
    AProgressIndicator* obj;
    
    if ([type isEqual:ANPROGRESSINDICATOR_BATTERY])
    {
        obj = [[ABatteryBar alloc] init];
    }
    
    return obj;
}
