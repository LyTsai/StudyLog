//
//  TRSliceGrid.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/24/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRSliceGrid.h"

@interface TRSliceGrid (PrivateMethods)
// paint grid background
-(void)paintGridRingBackground:(CGContextRef)ctx
                        layout:(Slice)size
                        center:(CGPoint)origin
                      ringAxis:(TRAxis *)ringAxis;
// paint grid lines
-(void)paintGridLines:(CGContextRef)ctx
               layout:(Slice)size
               center:(CGPoint)origin
             ringAxis:(TRAxis *)ringAxis
            angleAxis:(TRAxis *)angleAxis;

// paint grid table cells
-(void)paintCells:(CGContextRef)ctx
            table:(TRDataTableSliceView*) table
           layout:(Slice)size
           center:(CGPoint)origin
         ringAxis:(TRAxis *)ringAxis
        angleAxis:(TRAxis *)angleAxis;

// paint grid cell at given location
-(void)paintCell:(CGContextRef)ctx
            cell:(TRCell *)cell
        position:(CGPoint)position;

// dynamicly draw grid cell at given location
-(void)drawCell:(CGContextRef)ctx
           cell:(TRCell *)cell
       position:(CGPoint)position;

// get cell path
-(UIBezierPath *)getCellPath:(TRCell *)cell
                    position:(CGPoint)position;

@end

@implementation TRSliceGrid

-(id)init
{
    self = [super init];
    
    _cellShowAsLayer = TRUE;
    
    // create grid line objects
    _columnGridLine = [[TRGridLine alloc] init];
    _rowGridLine = [[TRGridLine alloc] init];
    
    // initial row and column focus
    _rowFocus = -1;
    _columnFocus = -1;
    
    return self;
}

// paint grid and grid cell tabel on the given context
-(void)paint:(CGContextRef)ctx
       table:(TRDataTableSliceView*) table
      layout:(Slice)size
      center:(CGPoint)origin
    ringAxis:(TRAxis *)ringAxis
   angleAxis:(TRAxis *)angleAxis
{
    // (1) paint grid background
    CGContextSaveGState(ctx);
    [self paintGridRingBackground:ctx
                           layout:size
                           center:origin
                         ringAxis:ringAxis];
    CGContextRestoreGState(ctx);

    // (2) paint grid lines
    CGContextSaveGState(ctx);
    [self paintGridLines:ctx
                  layout:size
                  center:origin
                ringAxis:ringAxis
               angleAxis:angleAxis];
    CGContextRestoreGState(ctx);
    
    // (3) paint grid cells
    if (_cellShowAsLayer == FALSE)
    {
        CGContextSaveGState(ctx);
        [self paintCells:ctx
               table:table
              layout:size
              center:origin
            ringAxis:ringAxis
           angleAxis:angleAxis];
        CGContextRestoreGState(ctx);
    }
}

// paint grid background
-(void)paintGridRingBackground:(CGContextRef)ctx
                        layout:(Slice)size
                        center:(CGPoint)origin
                      ringAxis:(TRAxis *)ringAxis
{
    int i;
    float radius, width;
    
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    // paint each even grid backgrounds
    if (_evenRowBackgroundColor != nil)
    {
        for (i = 0; i < ringAxis.numberOfTicks - 1; i++)
        {
            if (i % 2 == 0)
            {
                // radius of this ring
                radius = ([ringAxis position:(i + 1)] + [ringAxis position:i]) / 2.0;
                // width of this ring
                width = ([ringAxis position:(i + 1)] - [ringAxis position:i]);
                
                // add arc
                [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(size.right) endAngle:-DEGREES_TO_RADIANS(size.left) clockwise:FALSE];
                
                // draw the path
                CGContextBeginPath(ctx);
                CGContextAddPath(ctx, aPath.CGPath);
                
                CGContextSetLineWidth(ctx, width);
                CGContextSetStrokeColorWithColor(ctx, _evenRowBackgroundColor.CGColor);
                
                CGContextStrokePath(ctx);
                
                // clean up all path points
                [aPath removeAllPoints];
                
            }
        }
    }

    // paint each odd grid background
    if (_oddRowBackgroundColor != nil)
    {
        for (i = 0; i < ringAxis.numberOfTicks - 1; i++)
        {
            if (i % 2 != 0)
            {
                // radius of this ring
                radius = ([ringAxis position:(i + 1)] + [ringAxis position:i]) / 2.0;
                // width of this ring
                width = ([ringAxis position:(i + 1)] - [ringAxis position:i]);
                
                // add arc
                [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(size.right) endAngle:-DEGREES_TO_RADIANS(size.left) clockwise:FALSE];
                
                // draw the path
                CGContextBeginPath(ctx);
                CGContextAddPath(ctx, aPath.CGPath);
            
                CGContextSetLineWidth(ctx, width);
                CGContextSetStrokeColorWithColor(ctx, _oddRowBackgroundColor.CGColor);
                
                CGContextStrokePath(ctx);
                
                // clean up all path points
                [aPath removeAllPoints];
                
            }
        }
    }
}

// paint grid lines
-(void)paintGridLines:(CGContextRef)ctx
               layout:(Slice)size
               center:(CGPoint)origin
             ringAxis:(TRAxis *)ringAxis
            angleAxis:(TRAxis *)angleAxis

{
    // paint row grid lines
    [self paintRowGridLines:ctx
                     layout:size
                     center:origin
                   ringAxis:ringAxis
                  angleAxis:angleAxis];
    
    // paint column grid lines
    [self paintColumnGridLines:ctx
                        layout:size
                        center:origin
                      ringAxis:ringAxis
                     angleAxis:angleAxis];
    
    // paint focusing row or column
    if (_rowFocus >= 0 && _rowFocus < ringAxis.numberOfTicks)
    {
        [self paintRowGridLines_Neon:ctx
                              center:origin
                            ringAxis:ringAxis
                            rowFocus:_rowFocus
                          beginAngle:size.right
                            endAngle:size.left];
    }
    
    if (_columnFocus >= 0 && _columnFocus < angleAxis.numberOfTicks)
    {
        [self paintColumnGridLines_Neon:ctx
                                 center:origin
                              angleAxis:angleAxis
                            columnFocus:_columnFocus
                            beginRadius:size.bottom
                              endRadius:size.top];
    }
    
    return ;
}

// paint row grid line (x axis)
-(void)paintRowGridLines:(CGContextRef)ctx
                  layout:(Slice)size
                  center:(CGPoint)origin
                ringAxis:(TRAxis *)ringAxis
               angleAxis:(TRAxis *)angleAxis
{
    int i;
    float angle;
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    CGPoint bPt;
    
    // (2) draw ring (row) grid start from size.bottom to size.top
    // clean the path first
    float radius;
    [aPath removeAllPoints];
    
    angle = size.right;
    
    for (i = 0; i < ringAxis.numberOfTicks; i++)
    {
        // radius of this ring
        radius = [ringAxis position:i];
        
        // move to the begining angle line
        bPt.x = origin.x + radius * cosf(DEGREES_TO_RADIANS(angle));
        bPt.y = origin.y - radius * sinf(DEGREES_TO_RADIANS(angle));
        
        [aPath moveToPoint:bPt];
        
        // add arc
        [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(size.right) endAngle:-DEGREES_TO_RADIANS(size.left) clockwise:FALSE];
    }
    
    if (_rowGridLine.style == GridLine_Dash)
    {
        CGFloat dash[] = {2.0, 2.0};
        CGContextSetLineDash(ctx, .0, dash, 2);
    }
    
    // draw the path
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, aPath.CGPath);
    
    CGContextSetLineWidth(ctx, _rowGridLine.size);
    CGContextSetStrokeColorWithColor(ctx, _rowGridLine.color.CGColor);
    CGContextStrokePath(ctx);
    
    // Remove dash
    CGContextSetLineDash(ctx, .0, NULL, 0);
}

// paint column grid line (y axis)
-(void)paintColumnGridLines:(CGContextRef)ctx
                     layout:(Slice)size
                     center:(CGPoint)origin
                   ringAxis:(TRAxis *)ringAxis
                  angleAxis:(TRAxis *)angleAxis
{
    int i;
    float angle;
    CGPoint bPt, ePt;
    
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    // (1) drawing angle (column) grid start from the right to left
    // build path first
    for (i = 0; i < angleAxis.numberOfTicks; i++)
    {
        angle = [angleAxis position:i];
        
        // begin and end of angle grid line for angle
        bPt.x = origin.x + size.bottom * cosf(DEGREES_TO_RADIANS(angle));
        bPt.y = origin.y - size.bottom * sinf(DEGREES_TO_RADIANS(angle));
        
        ePt.x = origin.x + size.top * cosf(DEGREES_TO_RADIANS(angle));
        ePt.y = origin.y - size.top * sinf(DEGREES_TO_RADIANS(angle));
        
        [aPath moveToPoint:bPt];
        [aPath addLineToPoint:ePt];
    }
    
    if (_columnGridLine.style == GridLine_Dash)
    {
        CGFloat dash[] = {2.0, 2.0};
        CGContextSetLineDash(ctx, .0, dash, 2);
    }
    
    // draw the path
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, aPath.CGPath);
    
    CGContextSetLineWidth(ctx, _columnGridLine.size);
    CGContextSetStrokeColorWithColor(ctx, _columnGridLine.color.CGColor);
    CGContextStrokePath(ctx);
}

// paint neon light style type of line
-(void)paintRowGridLines_Neon:(CGContextRef)ctx
                       center:(CGPoint)origin
                     ringAxis:(TRAxis *)ringAxis
                     rowFocus:(int)rowFocus
                   beginAngle:(float)beginAngle
                     endAngle:(float)endAngle
{
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    CGPoint bPt;
    
    if (rowFocus >= ringAxis.numberOfTicks)
    {
        // do nothing
        return ;
    }
    
    float radius = [ringAxis position:rowFocus];
    
    // draw line around center in the {begin, end} range
    
    // move to the begining angle line
    bPt.x = origin.x + radius * cosf(DEGREES_TO_RADIANS(beginAngle));
    bPt.y = origin.y - radius * sinf(DEGREES_TO_RADIANS(beginAngle));
    
    [aPath moveToPoint:bPt];
    
    // add arc
    [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(beginAngle) endAngle:-DEGREES_TO_RADIANS(endAngle) clockwise:FALSE];
    
    // draw the path
    [self drawNeonPath:ctx
                 aPath:aPath
             lineColor:[UIColor blueColor].CGColor
             neonColor:[UIColor whiteColor].CGColor];
}

-(void)paintColumnGridLines_Neon:(CGContextRef)ctx
                          center:(CGPoint)origin
                       angleAxis:(TRAxis *)angleAxis
                     columnFocus:(int)columnFocus
                     beginRadius:(float)beginRadius
                       endRadius:(float)endRadius
{
    float angle;
    CGPoint bPt, ePt;
    
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    // (1) drawing angle (column) grid start from the right to left
    // build path first
    angle = [angleAxis position:columnFocus];
    
    // begin and end of angle grid line for angle
    bPt.x = origin.x + beginRadius * cosf(DEGREES_TO_RADIANS(angle));
    bPt.y = origin.y - beginRadius * sinf(DEGREES_TO_RADIANS(angle));
        
    ePt.x = origin.x + endRadius * cosf(DEGREES_TO_RADIANS(angle));
    ePt.y = origin.y - endRadius * sinf(DEGREES_TO_RADIANS(angle));
        
    [aPath moveToPoint:bPt];
    [aPath addLineToPoint:ePt];
    
    // draw the path
    [self drawNeonPath:ctx
                 aPath:aPath
             lineColor:[UIColor blueColor].CGColor
             neonColor:[UIColor whiteColor].CGColor];
}

// draw neon path
-(void)drawNeonPath:(CGContextRef)ctx
              aPath:(UIBezierPath *)aPath
          lineColor:(CGColorRef)lineColor
          neonColor:(CGColorRef)neonColor
{
    if (aPath == nil)
    {
        return ;
    }
    
    // draw the path
    CGContextBeginPath(ctx);
    
    CGContextAddPath(ctx, aPath.CGPath);
    // set outside shadow path
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 20, neonColor);
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, lineColor);
    CGContextStrokePath(ctx);
    
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 10, lineColor);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetStrokeColorWithColor(ctx, neonColor);
    CGContextStrokePath(ctx);
}

// paint grid table cells
-(void)paintCells:(CGContextRef)ctx
            table:(TRDataTableSliceView*)table
           layout:(Slice)size
           center:(CGPoint)origin
         ringAxis:(TRAxis *)ringAxis
        angleAxis:(TRAxis *)angleAxis
{
    // going over all cells of grid and display them on the map
    // row and column index
    int r, c;
    float angle, radius;
    // cell label point position
    CGPoint pt;
    
    if ([table numberOfColumns] != (angleAxis.numberOfTicks) ||
        [table numberOfRows] != ringAxis.numberOfTicks)
    {
        return ;
    }
    
    // all columns
    for (c = 0; c < angleAxis.numberOfTicks; c++)
    {
        angle = [angleAxis position:c];
        
        // all row of each column
        for (r = 0; r < ringAxis.numberOfTicks; r++)
        {
            // get cell object
            TRCell *cell = [table cell:r nCol:c];    
            if (cell == nil)
            {
                continue;
            }
            
            // compute grid view position for this cell
            radius = [ringAxis position:r];
            
            pt.x = origin.x + radius * cosf(DEGREES_TO_RADIANS(angle));
            pt.y = origin.y - radius * sinf(DEGREES_TO_RADIANS(angle));
            
            // show cell at position pt
            [self paintCell:ctx cell:cell position:pt];
        }
    }
}

// paint grid cell at given location
-(void)paintCell:(CGContextRef)ctx
            cell:(TRCell *)cell
        position:(CGPoint)position
{
    // check if we need to dynamicly draw cell image
    if (cell.image == nil)
    {
        // need to draw based on the properties
        return [self drawCell:ctx cell:cell position:position];
    }
    
    // we have preload image.  paint cell image at given location
    CGRect rect = CGRectMake(position.x - .5 * cell.image.size.width, position.y - .5 * cell.image.size.height, cell.image.size.width, cell.image.size.height);
    
    CGContextDrawImage(ctx, rect, cell.image.CGImage);
    
    return;
}

// dynamicly draw the cell at given location
-(void)drawCell:(CGContextRef)ctx
            cell:(TRCell *)cell
        position:(CGPoint)position
{
    // get cell drawing path
    UIBezierPath *cellPath = [self getCellPath:cell position:position];
    
    CGContextSaveGState(ctx);
    
    // (1) fill with subtle shadow
    if (cell.withShadow == TRUE)
    {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, [UIColor grayColor].CGColor);
    }
    
    CGContextSetFillColorWithColor(ctx, cell.metricColor.CGColor);
    
    CGContextAddPath(ctx, cellPath.CGPath);
    CGContextFillPath(ctx);

    // (2) outline
    if (cell.withOutline == TRUE)
    {
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(ctx, .5);
        CGContextAddPath(ctx, cellPath.CGPath);
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
}

// get cell path
-(UIBezierPath *)getCellPath:(TRCell *)cell
                    position:(CGPoint)position
{
    float radius = cell.displaySize;
    
    if (cell.cellShape == CellValueShape_Circle || cell.cellShape == CellValueShape_Dot)
    {
        CGRect frame = CGRectMake(position.x - radius, position.y - radius, 2 * radius, 2 * radius);
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:frame
                                                      cornerRadius:frame.size.height * 1.0 / 2.0];
    
        return circle;
    }
    
    return nil;
}

@end
