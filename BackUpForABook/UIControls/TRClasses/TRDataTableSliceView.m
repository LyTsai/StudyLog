//
//  TRDataTableSliceView.m
//  ATreeRingMap
//
//  Created by Hui Wang on 6/22/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRDataTableSliceView.h"
#import "ANDataTableCell.h"
#import "TRNode.h"

@interface TRDataTableSliceView (PrivateMethods)
@end

@implementation TRDataTableSliceView

// private data

-(id)init
{
    self = [super init];
    
    rowTexts = nil;
    columns = nil;
    
    return self;
}

// set up table rows with array of row lables
-(BOOL)setTableRows:(NSArray*)rowLabels
{
    if (rowTexts != nil)
    {
        [rowTexts removeAllObjects];
    }else
    {
        rowTexts = [[NSMutableArray alloc] init];
    }
    
    int i;
    for (i = 0; i < rowLabels.count; i++)
    {
        if ([[rowLabels objectAtIndex:i] isKindOfClass:[NSString class]])
        {
            [rowTexts addObject:[rowLabels objectAtIndex:i]];
        }else
        {
            return FALSE;
        }
    }
    return TRUE;
}

// add one column.  !!! must has size of (numberOfRows + 1) with first element to be header text
-(BOOL)addColumn:(NSArray*)oneColumn
{
    if (rowTexts == nil || oneColumn.count != (rowTexts.count + 1))
    {
        return FALSE;
    }
    
    // make sure we have right data types
    int i;
    
    if ([[oneColumn objectAtIndex:0] isKindOfClass:[NSString class]] != TRUE)
    {
        return FALSE;
    }
    
    for (i = 1; i < oneColumn.count; i++)
    {
        if ([[oneColumn objectAtIndex:i] isKindOfClass:[TRCell class]] != TRUE)
        {
            return FALSE;
        }
    }
    
    // we are good if we get here
    if (columns == nil)
    {
        columns = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    NSMutableArray *newColumn = [[NSMutableArray alloc] initWithCapacity:oneColumn.count];
    
    for (i = 0; i < oneColumn.count; i++)
    {
        [newColumn addObject:[oneColumn objectAtIndex:i]];
    }
    
    [columns addObject:newColumn];
    
    return TRUE;
}

-(BOOL)addColumnAt:(NSArray*)oneColumn
          position:(int)position
{
    if (rowTexts == nil || oneColumn.count != (rowTexts.count + 1))
    {
        return FALSE;
    }
    
    // make sure we have right data types
    int i;
    
    if ([[oneColumn objectAtIndex:0] isKindOfClass:[NSString class]] != TRUE)
    {
        return FALSE;
    }
    
    for (i = 1; i < oneColumn.count; i++)
    {
        if ([[oneColumn objectAtIndex:i] isKindOfClass:[TRCell class]] != TRUE)
        {
            return FALSE;
        }
    }
    
    // we are good if we get here
    if (columns == nil)
    {
        columns = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *newColumn = [[NSMutableArray alloc] initWithCapacity:oneColumn.count];
    
    for (i = 0; i < oneColumn.count; i++)
    {
        [newColumn addObject:[oneColumn objectAtIndex:i]];
    }
    
    [columns insertObject:newColumn atIndex:position];
    
    return TRUE;
}

-(void)removeColumn:(int)position
{
    if (columns == nil || position >= columns.count)
    {
        return ;
    }else
    {
        [columns removeObjectAtIndex:position];
    }
}

-(void)removeAllColumns
{
    if (columns != nil)
    {
        [columns removeAllObjects];
    }
}

// row tick lables
-(NSArray*)rowTickLabels
{
    return rowTexts;
}

// column tick lables
-(NSArray*)colTickLabels
{
    NSMutableArray *colTexts = [[NSMutableArray alloc] initWithCapacity:[self numberOfColumns]];
    
    int i;
    for (i = 0; i < [self numberOfColumns]; i++)
    {
        [colTexts addObject:[self columnText:i]];
    }
    
    return colTexts;
}

// accessing table elements
// number of data points
-(int)numberOfRows
{
    if (rowTexts == nil)
    {
        return 0;
    }else
    {
        return rowTexts.count;
    }
}

// number of data sets
-(int)numberOfColumns
{
    if (columns == nil)
    {
        return 0;
    }else
    {
        return columns.count;
    }
}

-(NSString*)rowText:(int)pos
{
    if (pos >= rowTexts.count)
    {
        return nil;
    }else
    {
        return [rowTexts objectAtIndex:pos];
    }
}

-(NSString*)columnText:(int)pos
{
    if (pos >= columns.count)
    {
        return nil;
    }else
    {
        return [[columns objectAtIndex:pos] objectAtIndex:0];
    }
}


// TRCell data at position (nRow, nCol).   
-(TRCell*)cell:(int)nRow
          nCol:(int)nCol
{
    if (nRow >= [self numberOfRows] || nCol >= [self numberOfColumns])
    {
        return nil;
    }else
    {
        return [[columns objectAtIndex:nCol] objectAtIndex:(nRow + 1)];
    }
}

// load table of metric values and view mapping table into slice
// !!! Note that TRDataTableSliceView defines the number of rows first before
// columns of metric values are added into the table
// metricValues - data table with title, row ID, column ID and [i][j] matrix of metric table values
-(void)loadMetricDataTable:(TRMetricDataTable*)metricValues
{
    NSInteger col, row, nRow;
    
    if (metricValues == nil)
    {
        return ;
    }
    
    // get number of data rows first
    nRow = [metricValues numberOfRows];
    
    // prepare for the row labels
    NSMutableArray *rowLabels = [[NSMutableArray alloc] initWithCapacity:nRow];
    
    // load all row labels
    for (row = 0; row < nRow; row++)
    {
        [rowLabels addObject:[metricValues rowID:row]];
    }

    // (1) set row texts
    [self setTableRows:rowLabels];
    
    // create collection of one column objects
    NSMutableArray *oneColumn = [[NSMutableArray alloc] initWithCapacity:(nRow + 1)];
    
    // populate columns
    // clear all current data
    [self removeAllColumns];
    
    // (2) add all columns column by column
    // all coliumns identified by column keys (or names)
    NSArray* columnKeys = [metricValues columnKeys];
    
    // first element (i = 0) of each row is row ID
    //for (col = 1; col < columnKeys.count; col++)
    for (col = columnKeys.count - 1; col >= 0; col--)
    {
        // metric key as column name for column col
        NSString* columnKey = [columnKeys objectAtIndex:col];
        
        ANDataTableCell *cell = nil;
        
        // table column name first
        [oneColumn addObject:columnKey];
        
        // then load rows of values for this column
        for (row = 0; row < nRow; row++)
        {
            // get metric value for jth row first
            cell = [metricValues cellAt:columnKey rowIndex:row];
             
            if (cell == nil)
            {
                continue;
            }
            
            // create one cell object for it
            TRCell *oneCell = [[TRCell alloc] init];
            
            // cell node metric meta data information
            oneCell.name = cell.unit_name;
            oneCell.unit = cell.unit_symbol;
            oneCell.text = cell.tip;
            
            // cell node visual information
            oneCell.displaySize = cell.viewSize;
            oneCell.value = cell.value;
            
            // visual presentation
            oneCell.image = cell.image;
            
            // add this grid cell
            [oneColumn addObject:oneCell];
        }
        
        // add this column into table
        [self addColumn:oneColumn];
        // remove objects from this column
        [oneColumn removeAllObjects];
    }
}

// Text method for debug purpose
-(void)createTestTable
{
    // nRow = 12, nCol = 30
    int i, j, nRow = 12, nCol = 30;
    
    NSMutableArray *rowLabels = [[NSMutableArray alloc] initWithCapacity:nRow];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init]; 
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    for (i = 0; i < nRow; i++)
    {
        [rowLabels addObject:dateString];
    }
    
    // (1) set row texts
    [self setTableRows:rowLabels];
    
    NSMutableArray *oneColumn = [[NSMutableArray alloc] initWithCapacity:(nRow + 1)];
    
    // populate columns
    [self removeAllColumns];
    
    for (i = 0; i < nCol; i++)
    {
        // first element is column text
        [oneColumn addObject:([NSString stringWithFormat:@"Diabetes %d", i])];
        
        // nRow of data elements
        for (j = 0; j < nRow; j++)
        {
            TRCell *oneCell = [[TRCell alloc] init];
            
            oneCell.displayStyle = CellValueShow_Flat;
            oneCell.cellShape = CellValueShape_Circle;
            oneCell.withShadow = TRUE;
            oneCell.withOutline = TRUE;
            oneCell.displaySize = 5;
            oneCell.showValue = TRUE;
            oneCell.metricColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.0 alpha:0.6];
            //oneCell.metricColor = [UIColor cyanColor];
                    
            [oneColumn addObject:oneCell];
        }
        
        // add into table
        [self addColumn:oneColumn];
        [oneColumn removeAllObjects];
    }
    return ;
}

@end
