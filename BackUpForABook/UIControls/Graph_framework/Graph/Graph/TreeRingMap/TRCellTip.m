//
//  TRCellTip.m
//  ATreeRingMap
//
//  Created by hui wang on 9/13/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRCellTip.h"

@implementation TRCellTip

-(id)init
{
    self = [super init];
    
    _show = true;
    _sliceIndex = -1;
    _columnIndex = -1;
    _rowIndex = -1;
    
    _cellTip = [[ANText alloc] initWithFont:@"Helvetica" size:16 shadow:TRUE underline:FALSE];
    _cellTip.textFillColor = [UIColor redColor];
    _cellTip.textStrokeColor = [UIColor blackColor];
    
    [_cellTip setTextUnderlineStyle:2];
    
    return self;
}

-(void)Paint:(CGContextRef)ctx
        cell:(TRCell*)cell
    position:(CGPoint)position
{
    if (_show == false || _cellTip == nil)
    {
        return ;
    }
    
    if (cell.showValue == false)
    {
        // do not show value
        [_cellTip.text setString:cell.text];
    }else
    {
        // show value
        [_cellTip.text setString:cell.text];
        [_cellTip.text appendString:[NSString stringWithFormat:@": %0.1f ", cell.value]];
        [_cellTip.text appendString:cell.unit];
    }
    
    CGSize textSize = [_cellTip.attributedText size];
    CGRect rect = CGRectMake(position.x - .5 * textSize.width, (position.y - .5 * textSize.height - .5 * cell.displaySize), textSize.width, textSize.height + 2);
    
    _cellTip.textFillColor = [UIColor blackColor];
    _cellTip.textStrokeColor = cell.metricColor;
    
    [_cellTip paint:ctx rect:rect];
    
    return ;
}

@end
