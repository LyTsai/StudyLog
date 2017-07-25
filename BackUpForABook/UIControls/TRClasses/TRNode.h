//
//  TRNode.h
//  ATreeRingMap
//
//  Created by hui wang on 12/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data structure for date collection at each grid node
@interface TRNode : NSObject

// metric key used for projecting viewProjectValue into proper GUI presentation
@property(nonatomic)NSString* key;

// raw data values associated with this node.
// !! these are original data before processing.  set showValue_Str to nil for numberic values
// value to be shown for this node for visual presentation.  Examples are metric value for HDL, LDL etc
@property(nonatomic)double showValue;
// the string form of metric value
@property(strong, nonatomic)NSString* showValue_Str;

// value used for mapping to right visual view.  Examples are: delta change compare to previous measurement.  most time this value is the same as showValue.
// !!! for values that is of string type raw data onvert them to numberical values before assigning.  map to CLASSIFICATION for string values
@property(nonatomic)double viewProjectValue;
// display text for this node
@property(nonatomic)NSString* displayText;
// drill down data set.  collection of data objects with specific types.  nil for most cases unless you have data for shoing "details" purpose
@property(nonatomic)NSMutableArray* nodeDetails;

// object creation (constructor)
-(id)initWith:(double)showValue
 showValueStr:(NSString*)showValueStr
viewProjectValue:(double)viewProjectValue
          key:(NSString*)key
  displayText:(NSString*)displayText
  nodeDetails:(NSMutableArray*)nodeDetails;

// constructor of metric object with numberic value
+ (id)nodeWith:(double)showValue
viewProjectValue:(double)viewProjectValue
           key:(NSString*)key
   displayText:(NSString*)displayText
   nodeDetails:(NSMutableArray*)nodeDetails;

// constructor of metric object with string value
// convert the string value to numberic if availible or map to CLASSIFICATION
+ (id)nodeWith:(double)showValue
  showValueStr:(NSString*)showValueStr
viewProjectValue:(double)viewProjectValue
           key:(NSString*)key
   displayText:(NSString*)displayText
   nodeDetails:(NSMutableArray*)nodeDetails;

@end
