//
//  ANDataTableCell.m
//  ANBookPad
//
//  Created by hui wang on 9/3/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import "ANDataTableCell.h"

@implementation ANDataTableCell

// create one cell
+(ANDataTableCell*)createWith:(NSString*)unit
                       symbol:(NSString*)symbol
                        value:(double)value
                        image:(nullable UIImage*)image
                     viewSize:(int)viewSize
                          tip:(NSString*)tip
{
    ANDataTableCell* oneCell = [[ANDataTableCell alloc] init];
    
    oneCell.unit_name = unit;
    oneCell.unit_symbol = symbol;
    oneCell.value = value;
    oneCell.image = image;
    oneCell.viewSize = viewSize;
    oneCell.tip = tip;
    
    return oneCell;
}

@end
