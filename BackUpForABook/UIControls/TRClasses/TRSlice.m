//
//  TRSlice.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/20/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRSlice.h"

@interface TRSlice (PrivateMethods)

// methods

// paint slice visual components
-(void)paintSliceBorders:(CGContextRef)ctx;
// paint float tip message
-(void)paintCellTip:(CGContextRef)ctx;

@end

@implementation TRSlice

@synthesize size, origin, background, table, grid, ringAxis, angleAxis;

// private data members

// methods:

// attach GUI object to data table
// !!! each cell by now would have their image setup.  for example: oneCell.image
-(void)attachToTable
{
    if (table == nil)
    {
        return ;
    }

    int col, row;
    
    for (row = 0; row < [table numberOfRows]; row++)
    {
        for (col = 0; col < [table numberOfColumns]; col++)
        {
            TRCell* oneCell = [table cell:row nCol:col];
            
            if (oneCell == nil || oneCell.image == nil)
            {
                continue;
            }
            
            // create CALayer object from factory and set it to oneCell.layer
            oneCell.layer = [CALayer layer];
            oneCell.layer.drawsAsynchronously = TRUE;
            
            oneCell.layer.contents = (__bridge id) oneCell.image.CGImage;
            oneCell.layer.frame = CGRectMake(0, 0, oneCell.displaySize, oneCell.displaySize);
            oneCell.layer.backgroundColor = [UIColor clearColor].CGColor;
            oneCell.layer.zPosition = 10;
            
            if (_parent)
            {
                [_parent addSublayer:oneCell.layer];
            }
            
            // do not do this!!!.  it will invaldates the contents
            //[oneCell.layer setNeedsDisplay];
        }
    }
}

// detach all table (CALayer) objects
-(void)detachFromTable
{
    if (table == nil)
    {
        return ;
    }
    
    int col, row;
    
    for (row = 0; row < [table numberOfRows]; row++)
    {
        for (col = 0; col < [table numberOfColumns]; col++)
        {
            TRCell* oneCell = [table cell:row nCol:col];
            
            if (oneCell == nil || oneCell.layer == nil)
            {
                continue;
            }
            
            [oneCell.layer removeFromSuperlayer];
            oneCell.layer = nil;
        }
    }
}

-(void)dealloc
{
    // detach all CALayer objects
    [self detachFromTable];
}

////////////////////////////////////////////////////
// attach table of metric values and view mapping table to slice
// parent - parent layer
// metricValues - metrics values
-(void)showMetricDataTable:(TRMetricDataTable*)metricValues
{
    // detach from current table
    [self detachFromTable];

    // load table data
    if (table)
    {
        [table loadMetricDataTable:metricValues];
        angleAxis.title.title = metricValues.title;
    }
    
    // attach GUI objects used for table data
    [self attachToTable];
}

-(id)init
{
    self = [super init];
    
    _parent = nil;
    _pointsPerFontSize = 1.0;
    
    // (1) create background object
    background = [[TRSliceBackground alloc] init];
    
    // (2) create grid object
    grid = [[TRSliceGrid alloc] init];
    grid.evenRowBackgroundColor = [UIColor colorWithRed:0.5 green:0.9 blue:0.9 alpha:0.4];
    grid.oddRowBackgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.4];
    grid.highLightedcellBorderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:.4];
    grid.columnGridLine.size = 1.0;
    grid.columnGridLine.style = GridLine_Solid;
    grid.columnGridLine.color = [UIColor whiteColor];
    grid.rowGridLine.size = .6;
    grid.rowGridLine.style = GridLine_Dash;
    grid.rowGridLine.color = [UIColor lightGrayColor];
    
    // (3) create axis objects
    ringAxis = [[TRRowAxis alloc] init];
    angleAxis = [[TRColumnAxis alloc] init];
    
    // (4) create data table object
    table = [[TRDataTableSliceView alloc] init];
    
    _rowBarStyle = BarPosition_LT;
    _rowLabelOnLeft = TRUE;
    _rowLabelOnRight = TRUE;
    
    // border edge
    _leftBorderStyle = SliceBorder_Solid;
    _rightBorderStyle = SliceBorder_Solid;
    _leftAngleMargin = 5;
    _rightAngleMargin = 5;
    _topEdgeMargin = 12.0;
    _bottomEdgeMargin = 12.0;
    _leftBorderSize = 8.0;
    _rightBorderSize = 8.0;
    _showLeftBorderShadow = TRUE;
    _showRightBorderShadow = TRUE;
    
    _borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:.5];
    _borderInnerColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    _borderShadowColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:.3];
    
    // floating tip message
    _cellTip = [[TRCellTip alloc] init];
    
    return self;
}

// methods
-(void)setPointsPerFontSize:(float)pointsPerFontSize
{
    _pointsPerFontSize = pointsPerFontSize;
    ringAxis.pointsPerFontSize = pointsPerFontSize;
    angleAxis.pointsPerFontSize = pointsPerFontSize;
}

// setup slice view style
-(void)setStyle:(SliceViewStyle)style
{
    if (style == SliceViewStyle_1)
    {
        [self setStyle_1];
    }else if (style == SliceViewStyle_2)
    {
        [self setStyle_2];
    }
}

// supported slice styles
-(void)setStyle_1
{
    // !!! slice one style
    self.background.style = BackgroudStyle_Color_Fill;
    self.background.bkgColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.8];
    self.background.edgeColor = [UIColor lightGrayColor];
    self.background.highlightColor = [UIColor colorWithRed:.0 green:1.0 blue:1.0 alpha:.4];
    self.background.highlightStyle = HighLightStyle_Gradient;
    
    // grid line background
    self.grid.evenRowBackgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.6];
    self.grid.oddRowBackgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.2];
    
    grid.columnGridLine.size = 1.0;
    grid.columnGridLine.style = GridLine_Solid;
    grid.columnGridLine.color = [UIColor whiteColor];
    grid.rowGridLine.size = .6;
    grid.rowGridLine.style = GridLine_Dash;
    grid.rowGridLine.color = [UIColor lightGrayColor];
    
    // border (seperator)
    self.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:.5];
    self.borderInnerColor = [UIColor colorWithRed:.6 green:.6 blue:.6 alpha:.8];
    self.borderShadowColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:.3];
    
    // margin on left and right sides
    self.leftAngleMargin = 5;
    self.rightAngleMargin = 5;
    
    self.leftAngleMargin = 5;
    self.leftBorderSize = 8.0;
    self.showLeftBorderShadow = TRUE;
    
    self.rightAngleMargin = 5;
    self.rightBorderSize = 8.0;
    self.showRightBorderShadow = TRUE;
    
    // ring axis
    self.ringAxis.tickLableDirection = TickLableOrientation_0; //TickLableOrientation_Angle;
    self.ringAxis.spaceBetweenAxisAndLable = 12.0;
    self.ringAxis.labelMargin = 60;
    self.ringAxis.maxNumberOfFullSizeLetters = 28;
    // fonts
    [self.ringAxis setTickLabelFonts:TRUE large:12.0 small:8.0];
    // ticks
    self.ringAxis.tickColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
    self.ringAxis.tickSize = 1.0;
    self.ringAxis.height = 3.0;
    
    // angle axis
    // ring on the outside edge
    self.angleAxis.ring.size = 18;
    self.angleAxis.ring.backgroundShadow = FALSE;// TRUE;
    self.angleAxis.ring.bkgColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.3];
    self.angleAxis.ring.borderColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
    self.angleAxis.ring.lineWidth = 1.0;
    self.angleAxis.showTickLabels = TRUE;
    self.angleAxis.labelMargin = 80;
    self.angleAxis.tickLableDirection = TickLableOrientation_0; //TickLableOrientation_Radius;
    
    // arrows
    self.angleAxis.beginArrow.shadow = FALSE;
    self.angleAxis.beginArrow.faceColor = [UIColor colorWithRed:0.0 green:.3 blue:.9 alpha:.8];
    self.angleAxis.endArrow.shadow = FALSE;
    self.angleAxis.endArrow.faceColor = [UIColor colorWithRed:0.0 green:.3 blue:.9 alpha:.8];
    
    // fonts
    self.angleAxis.maxNumberOfFullSizeLetters = 28;
    [self.angleAxis setTickLabelFonts:TRUE large:12.0 small:8.0];
    
    // title
    self.angleAxis.title.size = self.angleAxis.ring.size;
    self.angleAxis.title.style = RingTextStyle_AlignMiddle;
    
    [self.angleAxis.title setStringAttributes:@"Helvetica-Bold" size:10.0 foregroundColor:[UIColor colorWithRed:.0 green:.0 blue: .0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:4.0] strokeWidth:-3.0];
    
    return ;
}

-(void)setStyle_2
{
    self.background.style = BackgroudStyle_Color_Fill;
    self.background.bkgColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.8];
    self.background.edgeColor = [UIColor lightGrayColor];
    self.background.highlightColor = [UIColor colorWithRed:.0 green:1.0 blue:1.0 alpha:.4];
    self.background.highlightStyle = HighLightStyle_Gradient;
    
    // grid line background
    self.grid.evenRowBackgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.6];
    self.grid.oddRowBackgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.2];
    grid.columnGridLine.size = 1.0;
    grid.columnGridLine.style = GridLine_Solid;
    grid.columnGridLine.color = [UIColor whiteColor];
    grid.rowGridLine.size = .6;
    grid.rowGridLine.style = GridLine_Dash;
    grid.rowGridLine.color = [UIColor lightGrayColor];
    
    // border (seperator)
    self.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:.5];
    self.borderInnerColor = [UIColor colorWithRed:.6 green:.6 blue:.6 alpha:.8];
    self.borderShadowColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:.3];
    
    // margin on left and right sides
    self.leftAngleMargin = 5;
    self.rightAngleMargin = 5;
    
    self.leftAngleMargin = 5;
    self.leftBorderSize = 8.0;
    self.showLeftBorderShadow = TRUE;
    
    self.rightAngleMargin = 5;
    self.rightBorderSize = 8.0;
    self.showRightBorderShadow = TRUE;
    
    // ring axis
    self.ringAxis.tickLableDirection = TickLableOrientation_0; // TickLableOrientation_Angle
    self.ringAxis.spaceBetweenAxisAndLable = 12.0;
    self.ringAxis.labelMargin = 80;
    // fonts
    self.ringAxis.maxNumberOfFullSizeLetters = 28;
    // ticks
    self.ringAxis.tickColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
    self.ringAxis.tickSize = 1.0;
    self.ringAxis.height = 3.0;
    
    [self.ringAxis setTickLabelFonts:TRUE large:12.0 small:8.0];
    
    // angle axis
    // ring on the outside edge
    self.angleAxis.ring.size = 18;
    self.angleAxis.ring.backgroundShadow = FALSE;// TRUE;
    self.angleAxis.ring.bkgColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.3];
    self.angleAxis.ring.borderColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
    self.angleAxis.ring.lineWidth = 1.0;
    self.angleAxis.showTickLabels = TRUE;
    self.angleAxis.labelMargin = 80;
    self.angleAxis.tickLableDirection = TickLableOrientation_0; //TickLableOrientation_Radius;
    
    // arrows
    self.angleAxis.beginArrow.shadow = FALSE;
    self.angleAxis.beginArrow.faceColor = [UIColor colorWithRed:0.0 green:.3 blue:.9 alpha:.8];
    self.angleAxis.endArrow.shadow = FALSE;
    self.angleAxis.endArrow.faceColor = [UIColor colorWithRed:0.0 green:.3 blue:.9 alpha:.8];
    
    // fonts
    self.angleAxis.maxNumberOfFullSizeLetters = 28;
    [self.angleAxis setTickLabelFonts:TRUE large:12.0 small:8.0];
    self.angleAxis.title.style = RingTextStyle_AlignMiddle;
    
    // title
    self.angleAxis.title.size = self.angleAxis.ring.size;
    self.angleAxis.title.style = RingTextStyle_AlignMiddle;
    
    [self.angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:1.0 green:.0 blue: .0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
}

// paint slice
-(void)Paint:(CGContextRef)ctx
{
    // (1) paint background first
    [background paint:ctx layout:size center:origin];

    // (2) paint column axis
    // the "circle" bar is drawn at the right side boarder
    BOOL bCircleBarOnRight = _rightBorderStyle == SliceBorder_Line;
    [angleAxis paint:ctx startAngle:size.right endAngle:size.left radius:size.top barSize:angleAxis.ring.size * _pointsPerFontSize center:origin frameHeight:_hostFrame.size.height circleBarOnRight:bCircleBarOnRight];
    
    // (3) paint row axis
    if (_rowLabelOnLeft == TRUE)
    {
        [ringAxis paint:ctx startPosition:size.bottom endPosition:size.top angle:size.left offset:_leftBorderSize * _pointsPerFontSize * .5 center:origin frameHeight:_hostFrame.size.height];
    }
    
    if (_rowLabelOnRight == TRUE)
    {
        [ringAxis paint:ctx startPosition:size.bottom endPosition:size.top angle:size.right offset:_rightBorderSize * _pointsPerFontSize * .5 center:origin frameHeight:_hostFrame.size.height];
    }
 
    // (4) paint slice grid
    [grid paint:ctx table:table layout:size center:origin ringAxis:ringAxis angleAxis:angleAxis];
    
    // (5) paint left and right slice borders (left and right edges)
    [self paintSliceBorders:ctx];
    
    // (6) paint row axis slider bars
    if (_rowBarStyle == BarPosition_LT)
    {
        // slider bar on left
        [ringAxis paintSliderBar:ctx startPosition:size.bottom endPosition:size.top angle:size.left center:origin];
    }else if (_rowBarStyle == BarPosition_RB)
    {
        // slider bar on the right
        [ringAxis paintSliderBar:ctx startPosition:size.bottom endPosition:size.top angle:size.right center:origin];
    }
    
    // (7) display float tip message
    [self paintCellTip:ctx];
}

// paint slice visual components

-(void)paintSliceBorderLine:(CGContextRef)ctx
                      angle:(float)angle
                beginRadius:(float)beginRadius
                  endRadius:(float)endRadius
                      width:(float)width
                borderColor:(CGColorRef)borderColor
{
    CGPoint bPt, ePt;
    
    // begin and end of angle grid line for angle
    bPt.x = origin.x + beginRadius * cosf(DEGREES_TO_RADIANS(angle));
    bPt.y = origin.y - beginRadius * sinf(DEGREES_TO_RADIANS(angle));
    
    ePt.x = origin.x + endRadius * cosf(DEGREES_TO_RADIANS(angle));
    ePt.y = origin.y - endRadius * sinf(DEGREES_TO_RADIANS(angle));
    
    CGContextSaveGState(ctx);
    
    // draw the path
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, bPt.x, bPt.y);
    CGContextAddLineToPoint(ctx, ePt.x, ePt.y);
    
    // set line width
    CGContextSetLineWidth(ctx, width);
    if (angleAxis && angleAxis.ring && angleAxis.ring.innerDecorationStyle == INNERDECORATION_BLACK_GREY)
    {
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    }else if (angleAxis && angleAxis.ring && angleAxis.ring.innerDecorationStyle == INNERDECORATION_WHITE_BLACK)
    {
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    }else
    {
        CGContextSetStrokeColorWithColor(ctx, borderColor);
    }
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

// angle - angle position
// beginRadius, endRadius - begin and end of line points
// width - line width
-(void)paintSliceBorderSimple:(CGContextRef)ctx
                        angle:(float)angle
                  beginRadius:(float)beginRadius
                    endRadius:(float)endRadius
                        width:(float)width
                  borderColor:(CGColorRef)borderColor
                  shadowColor:(CGColorRef)shadowColor
                      bShadow:(BOOL)bShadow
{
    CGPoint bPt, ePt;
    
    // begin and end of angle grid line for angle
    bPt.x = origin.x + beginRadius * cosf(DEGREES_TO_RADIANS(angle));
    bPt.y = origin.y - beginRadius * sinf(DEGREES_TO_RADIANS(angle));
    
    ePt.x = origin.x + endRadius * cosf(DEGREES_TO_RADIANS(angle));
    ePt.y = origin.y - endRadius * sinf(DEGREES_TO_RADIANS(angle));
    
    CGContextSaveGState(ctx);
    
    // draw the path
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, bPt.x, bPt.y);
    CGContextAddLineToPoint(ctx, ePt.x, ePt.y);
    
    // set line width
    CGContextSetLineWidth(ctx, width);
    CGContextSetStrokeColorWithColor(ctx, borderColor);
    CGContextStrokePath(ctx);
    
    // draw white line in between
    CGContextMoveToPoint(ctx, bPt.x, bPt.y);
    CGContextAddLineToPoint(ctx, ePt.x, ePt.y);
    
    // add shadow
    if (bShadow == TRUE)
    {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 3.0), 3.0, shadowColor);
    }
    
    CGContextSetLineWidth(ctx, width - 2.0);
    CGContextSetStrokeColorWithColor(ctx, borderColor);
    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);
}

-(void)paintSliceBorderMetal:(CGContextRef)ctx
                       angle:(float)angle
                 beginRadius:(float)beginRadius
                   endRadius:(float)endRadius
                       width:(float)width
                 borderColor:(CGColorRef)borderColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIColor* gradientColor38 = [UIColor colorWithRed: 0.718 green: 0.706 blue: 0.698 alpha: 1];
    UIColor* gradientColor39 = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1];
    UIColor* gradientColor40 = [UIColor colorWithRed: 0.702 green: 0.69 blue: 0.686 alpha: 1];
    UIColor* gradientColor41 = [UIColor colorWithRed: 0.737 green: 0.722 blue: 0.722 alpha: 1];
    
    CGFloat sVGID_4_Locations[] = {.1, 0.45, 0.72, 1};
    CGGradientRef sVGID_4_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor38.CGColor, (id)gradientColor39.CGColor, (id)gradientColor40.CGColor, (id)gradientColor41.CGColor], sVGID_4_Locations);
    
    CGPoint bPt, ePt;
    
    float dx = .5 * width * sinf(DEGREES_TO_RADIANS(angle));
    float dy = .5 * width * cosf(DEGREES_TO_RADIANS(angle));
    
    // begin and end of angle grid line for angle
    bPt.x = origin.x + beginRadius * cosf(DEGREES_TO_RADIANS(angle));
    bPt.y = origin.y - beginRadius * sinf(DEGREES_TO_RADIANS(angle));
    
    ePt.x = origin.x + endRadius * cosf(DEGREES_TO_RADIANS(angle));
    ePt.y = origin.y - endRadius * sinf(DEGREES_TO_RADIANS(angle));
    
    UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
    
    [rectanglePath moveToPoint: CGPointMake(bPt.x - dx, bPt.y - dy)];
    [rectanglePath addLineToPoint: CGPointMake(bPt.x + dx, bPt.y + dy)];
    [rectanglePath addLineToPoint: CGPointMake(ePt.x + dx, ePt.y + dy)];
    [rectanglePath addLineToPoint: CGPointMake(ePt.x - dx, ePt.y - dy)];
    [rectanglePath closePath];
    
    CGContextSaveGState(ctx);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(ctx, sVGID_4_,
                                bPt,
                                ePt,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(ctx);
    CGGradientRelease(sVGID_4_);
    CGColorSpaceRelease(colorSpace);
}

// paint the borders
// bIncludsBar - true if the bar area is also included in painting
-(void)paintSliceBorders:(CGContextRef)ctx
{
    if (_leftBorderStyle == SliceBorder_None && _rightBorderStyle == SliceBorder_None)
    {
        return ;
    }
    
    float angle, beginRadius, endRadius;
    float cellSize;
    
    if (_leftBorderStyle != SliceBorder_None)
    {
        // angle position of border
        angle = size.left;
        
        if ([table numberOfColumns] >= 1 && [table numberOfRows] >= 1)
        {
            // cell circle size adjustment for the left starting cell of most column
            cellSize = [[table cell:0 nCol:([table numberOfColumns] - 1)] displaySize];
        }else
        {
            cellSize = 0;
        }
        
        // convert to device size
        cellSize *= _pointsPerFontSize;
        
        // radius position of border head
        beginRadius = (size.bottom + cellSize);
        
        // radius position of end
        if (angleAxis.ring && _leftBorderStyle != SliceBorder_Line)
        {
            endRadius = (size.top + angleAxis.ring.size * _pointsPerFontSize);
        }else
        {
            endRadius = size.top;
        }
        
        if (_leftBorderStyle == SliceBorder_Line)
        {
            [self paintSliceBorderLine:ctx
                                 angle:angle
                           beginRadius:beginRadius
                             endRadius:endRadius
                                 width:6
                           borderColor:_borderColor.CGColor];
        }else if (_leftBorderStyle == SliceBorder_Solid)
        {
            [self paintSliceBorderSimple:ctx
                                   angle:angle
                             beginRadius:beginRadius
                               endRadius:endRadius
                                   width:_leftBorderSize * _pointsPerFontSize
                             borderColor:_borderColor.CGColor
                             shadowColor:_borderShadowColor.CGColor
                                 bShadow:_showLeftBorderShadow];
        }else if (_leftBorderStyle == SliceBorder_Metal)
        {
            [self paintSliceBorderMetal:ctx
                                  angle:angle
                            beginRadius:beginRadius
                              endRadius:endRadius
                                  width:_leftBorderSize * _pointsPerFontSize
                            borderColor:_borderColor.CGColor];
        }
    }
    
    if (_rightBorderStyle != SliceBorder_None)
    {
        // angle position of border
        angle = size.right;
        
        // cell circle size adjustment for the left starting cell of most column
        if ([table numberOfColumns] >= 1 && [table numberOfRows] >= 1)
        {
            // cell circle size adjustment for the left starting cell of most column
            cellSize = [[table cell:0 nCol:0] displaySize];
        }else
        {
            cellSize = 0;
        }

        cellSize *= _pointsPerFontSize;
        
        // radius position of border head
        beginRadius = (size.bottom + cellSize);
        
        // radius position of end
        if (angleAxis.ring && _rightBorderStyle != SliceBorder_Line)
        {
            endRadius = (size.top + angleAxis.ring.size * _pointsPerFontSize);
        }else
        {
            endRadius = size.top;
        }
        
        if (_rightBorderStyle == SliceBorder_Line)
        {
            [self paintSliceBorderLine:ctx
                                 angle:angle
                           beginRadius:beginRadius
                             endRadius:endRadius
                                 width:4
                           borderColor:_borderColor.CGColor];
        }else if (_rightBorderStyle == SliceBorder_Solid)
        {
            [self paintSliceBorderSimple:ctx
                                   angle:angle
                             beginRadius:beginRadius
                               endRadius:endRadius
                                   width:_rightBorderSize * _pointsPerFontSize
                             borderColor:_borderColor.CGColor
                             shadowColor:_borderShadowColor.CGColor
                                 bShadow:_showRightBorderShadow];
        }else if (_rightBorderStyle == SliceBorder_Metal)
        {
            [self paintSliceBorderMetal:ctx
                                  angle:angle
                            beginRadius:beginRadius
                              endRadius:endRadius
                                  width:_rightBorderSize * _pointsPerFontSize
                            borderColor:_borderColor.CGColor];
        }
    }
}

// paint float tip message
-(void)paintCellTip:(CGContextRef)ctx
{
    if (_cellTip == nil ||
        _cellTip.show == false ||
        _cellTip.rowIndex < 0 ||
        _cellTip.columnIndex < 0)
    {
        return ;
    }
    
    // (1) get TRCell object
    TRCell *cell = [table cell:_cellTip.rowIndex nCol:_cellTip.columnIndex];
    
    if (cell == nil)
    {
        return ;
    }
    
    // (2) get cell location
    CGPoint position = [self getCellPosition:_cellTip.rowIndex column:_cellTip.columnIndex];
   
    // (3) show tip
    [_cellTip Paint:ctx cell:cell position:position];
    
    return ;
}

// call whenever visual and table data are out of sync.  The visual presentation is decided by grid layout which is reflected in the tick positions of both axises
// !!! setAxisTicks cause call to reSize method of axis
-(void)onDirtyView
{
    // set ring axis size.  leavs no empty spce to both ends
    [ringAxis setAxisTicks:size.bottom max:size.top tickLabels:[table rowTickLabels] firstTickValue:(size.bottom + _bottomEdgeMargin) lastTickValue:(size.top - _topEdgeMargin)];
    
    // set angle axis size.  leaves some spaces to both ends
    [angleAxis setAxisTicks:size.right max:size.left tickLabels:[table colTickLabels] firstTickValue:(size.right + _rightAngleMargin) lastTickValue:(size.left - _leftAngleMargin)];
}

// event of resizing
-(void)onSize
{
    [self updateCellSymbolLayerPositions];
}

// sync node cell layer position (if valid)
-(void)updateCellSymbolLayerPositions
{
    // grid has grid cell node psoition and table has access to cell where the layer object is accessed
    if (table == nil || ringAxis == nil || angleAxis == nil)
    {
        return ;
    }
    
    if ([table numberOfColumns] != (angleAxis.numberOfTicks) ||
        [table numberOfRows] != ringAxis.numberOfTicks)
    {
        return ;
    }
    
    // going over all cells of grid and display them on the map
    // row and column index
    int r, c;
    // cell label point position
    CGPoint pt;
    
    // all columns
    for (c = 0; c < angleAxis.numberOfTicks; c++)
    {
        // all row of each column
        for (r = 0; r < ringAxis.numberOfTicks; r++)
        {
            // get cell object
            TRCell *cell = [table cell:r nCol:c];
            if (cell == nil || cell.layer == nil)
            {
                continue;
            }
            
            // get cell position
            pt = [self getCellPosition:r column:c];
            
            // move layer object to position pt
            if (fabs(cell.layer.position.x - pt.x) > 1.0 || fabs(cell.layer.position.y - pt.y) > 1.0)
            {
                //cell.layer.position = pt;
                
                ///*
                //create a basic animation
                CABasicAnimation *animation = [CABasicAnimation animation];
                animation.keyPath = @"position";
                
                animation.fromValue = [NSValue valueWithCGPoint:pt];//[cell.layer.presentationLayer valueForKeyPath:animation.keyPath];
                animation.toValue = [NSValue valueWithCGPoint:pt];
                
                // set the value to the final state first
                [cell.layer setValue:animation.toValue forKeyPath:animation.keyPath];
                [cell.layer addAnimation:animation forKey:animation.keyPath];
                //*/
            }
        }
    }
}

// resizing the slice.  very cheap operation. should called every time before drawing
-(void)setSize:(Slice)sliceSize
{
    // set slice size
    size = sliceSize;
}

// hit test
-(HitObj)HitTest:(CGPoint) atPoint
{
    HitObj hit;
    
    hit.hitObject = TRObjs_None;
    
    // (1) try angle axis
    hit = [angleAxis HitTest:atPoint radius:size.top barSize:angleAxis.ring.size * _pointsPerFontSize center:origin];
    
    // did we hit anything?
    if (hit.hitObject != TRObjs_None)
    {
        return hit;
    }
    
    // (2) no. try ring axis
    if (_rowBarStyle == BarPosition_LT)
    {
        hit = [ringAxis HitTest:atPoint angle:size.left barSize:angleAxis.ring.size * _pointsPerFontSize center:origin];
    }else if (_rowBarStyle == BarPosition_RB)
    {
        hit = [ringAxis HitTest:atPoint angle:size.right barSize:angleAxis.ring.size * _pointsPerFontSize center:origin];
    }
    
    if (hit.hitObject != TRObjs_None)
    {
        return hit;
    }
    
    // (3). try slice grid table cells
    hit = [self cellTableHitTest:atPoint];
    if (hit.hitObject != TRObjs_None)
    {
        // hit table cell object.  update cellTip object
        _cellTip.rowIndex = hit.row;
        _cellTip.columnIndex = hit.col;
        return hit;
    }
    
    // !!! Add other hit tests if any
    
    return hit;
}

// table cell hit test
-(HitObj)cellTableHitTest:(CGPoint) atPoint
{
    HitObj hit;
    
    hit.hitObject = TRObjs_None;
    
    // Center position
    CGPoint center = origin;
    
    // {angle, radius} point position
    CGFloat r = hypotf(atPoint.x - center.x, atPoint.y - center.y);
    
    float endAngle = .0;
    endAngle = 180.0 * atan(-(atPoint.y - center.y) / (atPoint.x - center.x)) / 3.14;
    if ((atPoint.x - center.x) < 0)
    {
        endAngle += 180;
    }
    
    // is endAngle with slice size range?
    if (endAngle < size.right || endAngle > size.left)
    {
        return hit;
    }
    
    // is within this slice. find if we hit any grid cell
    int col;
    
    // closest column with minimal delta in angle distance
    int colMin = -1;
    float minAngleDelta = 360.0;
    
    for (col = 0; col < angleAxis.numberOfTicks; col++)
    {
        float angle = [angleAxis position:col];
        
        if (ABS(angle - endAngle) < minAngleDelta)
        {
            minAngleDelta = ABS(angle - endAngle);
            colMin = col;
        }
    }
    
    // found valid column?
    if (colMin < 0)
    {
        return hit;
    }
    
    // which row ?
    int row;
    // closest cell position
    int rowMin = -1;
    float minDistance = ABS(size.top - size.bottom);
    
    for (row = 0; row < ringAxis.numberOfTicks; row++)
    {
        // compute grid view position for this cell
        CGPoint cellPt = [self getCellPosition:row column:colMin];
        
        float dis = hypotf(cellPt.x - atPoint.x, cellPt.y - atPoint.y);
        
        if (dis < minDistance)
        {
            minDistance = dis;
            rowMin = row;
        }
    }
    
    // did we find anything?
    if (rowMin < 0)
    {
        return hit;
    }
    
    // get cell object
    TRCell *cell = [table cell:rowMin nCol:colMin];
    if (cell == nil ||      // empty cell
        cell.displayStyle == CellValueShow_None // non displayable cell
        )
    {
        return hit;
    }
    
    if (minDistance > cell.displaySize)
    {
        return hit;
    }
    
    hit.hitObject = TRObjs_Cell;
    hit.row = rowMin;
    hit.col = colMin;
    
    return hit;
}

// Reset axis slider bar position
-(void)setColumnAxisSliderBarPosition:(float)barPosition
{
    angleAxis.eyePosition = barPosition;
    [angleAxis reSize];
}

-(void)setRowAxisSliderBarPosition:(float)barPosition
{
    ringAxis.eyePosition = barPosition;
    [ringAxis reSize];
}

// locate TRCell position for given row and column index
-(CGPoint)getCellPosition:(int)row
                   column:(int)column
{
    // compute grid view position for this cell
    float radius = [ringAxis position:row];
    float angle = [angleAxis position:column];
    
    CGPoint cellPt;
    
    cellPt.x = origin.x + radius * cosf(DEGREES_TO_RADIANS(angle));
    cellPt.y = origin.y - radius * sinf(DEGREES_TO_RADIANS(angle));
    
    return cellPt;
}

@end
