//
//  TRNode.m
//  ATreeRingMap
//
//  Created by hui wang on 12/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRNode.h"

@implementation TRNode

-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _showValue = .0;
        _showValue_Str = nil;
        _viewProjectValue = .0;
        _displayText = nil;
        _nodeDetails = nil;
    }
    return self;
}

// object creation (constructor)
-(id)initWith:(double)showValue
 showValueStr:(NSString*)showValueStr
viewProjectValue:(double)viewProjectValue
          key:(NSString*)key
  displayText:(NSString*)displayText
  nodeDetails:(NSMutableArray*)nodeDetails
{
    self = [super init];
    
    if (self != nil)
    {
        _showValue = showValue;
        _showValue_Str = showValueStr;
        _viewProjectValue = viewProjectValue;
        _key = key;
        _displayText = displayText;
        _nodeDetails = nodeDetails;
    }
    return self;
}

// constructor of metric object with numberic value
+ (id)nodeWith:(double)showValue
viewProjectValue:(double)viewProjectValue
           key:(NSString*)key
   displayText:(NSString*)displayText
   nodeDetails:(NSMutableArray*)nodeDetails
{
    return [[self alloc] initWith:showValue showValueStr:nil viewProjectValue:viewProjectValue key:key displayText:displayText nodeDetails:nodeDetails];
}

// constructor of metric object with string value
// convert the string value to numberic if availible or map to CLASSIFICATION
+ (id)nodeWith:(double)showValue
  showValueStr:(NSString*)showValueStr
viewProjectValue:(double)viewProjectValue
           key:(NSString*)key
   displayText:(NSString*)displayText
   nodeDetails:(NSMutableArray*)nodeDetails
{
    return [[self alloc] initWith:showValue showValueStr:showValueStr viewProjectValue:viewProjectValue key:key displayText:displayText nodeDetails:nodeDetails];
}

@end
