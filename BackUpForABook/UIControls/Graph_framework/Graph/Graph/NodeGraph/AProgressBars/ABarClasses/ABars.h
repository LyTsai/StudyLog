//
//  ABars.h
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "ABarBackground.h"
#import "ABar.h"

#import "ANText.h"


// bar style
typedef enum
{
    BARSTYLE_NULL           = 0x00,         // not specified
    BARSTYLE_LINE_VER       = 0x01,         // vertical bar
    BARSTYLE_LINE_HORI      = 0x02,         // horizontal bar
    BARSTYLE_ROUNDEND       = 0x04,         // round end
    BARSTYLE_GRADIENT       = 0x08,         // gradient
    BARSTYLE_SHADOW         = 0x10,         // shadow
    BARSTYLE_TEXT_CENTER    = 0x20,         // text in the center
    BARSTYLE_TEXT_BOTTOM    = 0x40          // text in the bottom
}BARSTYLE;

// collection of bar data set
@interface ABars : NSObject
{
    
}

// generic bar collection properties:
// hold bar information for processing (instead of drawing)

// bar style
@property BARSTYLE style;
// weight for visual size for weighting purpose
@property float sizeWeight;

// background color
@property(strong, nonatomic)ABarBackground* backGround;
// collection of ABar opbjects
@property(strong, nonatomic)NSMutableArray* bars;
// position, size and style (rect or pie)
// metric object key (of measurement)
@property(strong, nonatomic)NSString* key;

// metric information coming from (type, name, unit and ranges etc).
// !!! caller will extract the information out of object like anmetrics etc

// metric name
@property(strong, nonatomic)ANText* metricName;
// unit type
// unit string
@property(strong, nonatomic)ANText* unitStr;

// range
@property float minVal;
@property float maxVal;

// methods
-(void)initPros:(NSString*)key
     metricName:(NSString*)metricName
           unit:(NSString*)unit
           bars:(NSArray*)bars;

@end
