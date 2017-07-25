//
//  ANDataTableCell.h
//  ANBookPad
//
//  Created by hui wang on 9/3/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import <Foundation/Foundation.h>

// define class for passing and storing table data cell raw data measurement and information for visual presentation
// !!! this class should be as simple as possible.  only holds enough information for data presenetation purpose.  it is caller's job to process data, map to specific clasification and provide content in "info" for additional text as tip message
// !!! you have to keep in mind that a data point can be specified by either raw value, classification or both.  as long as we have either value or classification the data point is valid.  
@interface ANDataTableCell : NSObject

// raw data information: value / unit
@property(strong, nullable)NSString* unit_name;
@property(strong, nullable)NSString* unit_symbol;
// raw data value
@property double value;

// visual information of raw value by classification.  if null the raw value will be printed on the screen
@property(strong, nullable)UIImage* image;
// visual size
@property int viewSize;
// additional information for tip message that will be shown in pop up message
@property(strong, nullable)NSString* tip;

// create one cell
+(nonnull ANDataTableCell*)createWith:(nullable NSString*)unit
                               symbol:(nullable NSString*)symbol
                                value:(double)value
                                image:(nullable UIImage*)image
                             viewSize:(int)viewSize
                                  tip:(nullable NSString*)tip;
@end
