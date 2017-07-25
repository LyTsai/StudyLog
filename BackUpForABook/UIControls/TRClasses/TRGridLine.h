//
//  TRGridLine.h
//  ATreeRingMap
//
//  Created by hui wang on 12/20/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "define.h"

// defines grid line style
@interface TRGridLine : NSObject

// grid line color
@property(strong, nonatomic)UIColor *color;
// grid line size
@property(nonatomic)float size;
// grid line drawing style: GridLine_Solid, GridLine_Dash, GridLine_Neon etc
@property(nonatomic)GridLine style;

@end
