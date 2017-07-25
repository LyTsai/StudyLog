//
//  ANClassFactory.h
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#ifndef ANClassFactory_h
#define ANClassFactory_h


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#include "metrics.h"

#include "AProgressIndicator.h"

////////////////////////////////////////////////////////
// progress chart class factory
////////////////////////////////////////////////////////
#define ANPROGRESSINDICATOR_BATTERY     @"ABatteryBar"

AProgressIndicator* createProgressIndicator(NSString* type);

#endif