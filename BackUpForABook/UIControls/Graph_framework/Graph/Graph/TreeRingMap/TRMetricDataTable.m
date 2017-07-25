//
//  TRMetricDataTable.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/10/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRMetricDataTable.h"

@interface TRMetricDataTable (PrivateMethods)

@end

@implementation TRMetricDataTable
{
    // map column name to its index position for fast accessing of table cells
    // map (columnKey, columnIndex)
    NSMutableDictionary* _columnKey2Index;
}

-(id)init
{
    self = [super init];
    
    _title = nil;
    _metricValues = [[NSMutableArray alloc] init];
    
    return self;
}

-(id)initWithTitle:(NSString*)title
{
    self = [super init];
    
    _title = [[NSMutableString alloc] initWithString:title];
    _metricValues = [[NSMutableArray alloc] init];
    
    return self;
    
}

// get cell index for easy access
// column index in _metricValues for given column key
-(NSInteger)_ColumnIndex:(NSString*)columnKey
{
    // look for columnKey in _columnKey2Index
    if (_columnKey2Index == nil || [_columnKey2Index valueForKey:columnKey] == nil)
    {
        return -1;
    }
    
    // for cell row the first element is always reserved for row name
    return [[_columnKey2Index valueForKey:columnKey] integerValue] + 1;
}

// index for the given row in _metricValues
-(NSInteger)_RowIndex:(NSInteger)row
{
    return row + 1;
}

// setup table column with array of key strings
-(void)createTableColumnKeys:(NSArray*)columnKeys
{
    if (_metricValues == nil)
    {
        _metricValues = [[NSMutableArray alloc] init];
    }else
    {
        [_metricValues removeAllObjects];
    }
    
    // add one row
    [_metricValues addObject:[[NSMutableArray alloc] init]];
    
    // array of NSString
    NSMutableArray* keys = [_metricValues objectAtIndex:0];
    
    if (columnKeys == nil)
    {
        return ;
    }
    
    NSString* colKey;
    for (colKey in columnKeys)
    {
        if (colKey != nil)
        {
            // add this metric key
            [keys addObject:colKey];
        }
    }
    
    // update _columnKey2Index
    if (_columnKey2Index == nil)
    {
        _columnKey2Index = [[NSMutableDictionary alloc] init];
    }else
    {
        [_columnKey2Index removeAllObjects];
    }
    
    int i;
    for (i = 0; i < keys.count; i++)
    {
        [_columnKey2Index setValue:[NSNumber numberWithInteger:i] forKey:keys[i]];
    }
    
    return ;

}

// add new column for the given metric key
-(void)addColumnKey:(NSString*)columnKey
{
    if (_metricValues == nil)
    {
        _metricValues = [[NSMutableArray alloc] init];
        _columnKey2Index = [[NSMutableDictionary alloc] init];
    }
    
    if (_metricValues.count == 0)
    {
        [_metricValues addObject:[[NSMutableArray alloc] init]];
    }
    
    NSMutableArray* keys = [_metricValues objectAtIndex:0];
    if (keys == nil)
    {
        return ;
    }
    
    [keys addObject:columnKey];
    
    // add to _columnKey2Index
    [_columnKey2Index setValue:[NSNumber numberWithInteger:(keys.count - 1)] forKey:columnKey];
}

// columns
-(NSArray*)columnKeys
{
    if (_metricValues == nil || [_metricValues objectAtIndex:0] == nil)
    {
        return nil;
    }
    
    return [_metricValues objectAtIndex:0];
}

// number of coumns
-(NSUInteger)numberOfColumns
{
    return [self columnKeys].count;
}

// number of value rows (measurement set)
-(NSUInteger)numberOfRows
{
    if (_metricValues.count <= 1)
    {
        return 0;
    }
    
    return _metricValues.count - 1;
}

// data input methods:

// you can always input the data by directly setting table "metricValues".  but you have to make sure that you set the table cells with the right type (ANDataTableCell) at the correct location (row, column).
// or you call following methods with somewhat slower speed but more secure

// get row ID
-(NSString*)rowID:(NSInteger)row
{
    if (row >= [self numberOfRows])
    {
        return nil;
    }
    
    NSInteger _rowIndex = [self _RowIndex:row];
    
    id obj = [[_metricValues objectAtIndex:_rowIndex] objectAtIndex:0];
    
    if([obj isKindOfClass:[NSString class]] != TRUE)
    {
        return nil;
    }

    return [[_metricValues objectAtIndex:_rowIndex] objectAtIndex:0];
}


// add onew row in _metricValues
-(NSMutableArray*)_addRow:(NSString*)rowID
{
    [_metricValues addObject:[[NSMutableArray alloc]  initWithCapacity:[self numberOfColumns] + 1]];
    
    NSMutableArray* newRow = [_metricValues objectAtIndex:_metricValues.count - 1];
    // the first element is row ID
    [newRow addObject:rowID];
    
    return newRow;
}

// set table data cell at location (rowKey, columnKey)
-(void)setTableCell:(NSString*)columnKey
           rowIndex:(NSUInteger)rowIndex
               cell:(ANDataTableCell*)cell
{
    if (cell == nil)
    {
        return ;
    }
    
    if (rowIndex >= [self numberOfRows])
    {
        return ;
    }
    
    NSInteger _rowIndex = [self _RowIndex:rowIndex];
    NSInteger _columnIndex = [self _ColumnIndex:columnKey];
    if (_columnIndex < 0)
    {
        return;
    }

    [[_metricValues objectAtIndex:_rowIndex] setObject:cell atIndexedSubscript:_columnIndex];
}

// set one row of cells with dictionary of ANDataTableCell by column key
-(void)addRow:(NSString*)rowID
        cells:(NSDictionary*)cells
{
    if (rowID == nil || cells == nil)
    {
        return ;
    }
    
    // make sure we have the right set of data
    
    // check all column keys in _metricValues
    NSArray* columnKeys = [self columnKeys];
    
    if (columnKeys == nil || columnKeys.count < 1)
    {
        // no columns in this table
        return ;
    }
    
    // create one row in table metricValues
    NSMutableArray* newRow = [self _addRow:rowID];
    if (newRow == nil)
    {
        return ;
    }

    for (int i = 0; i < columnKeys.count; i++)
    {
        // add one cell first
        [newRow addObject:[[ANDataTableCell alloc] init]];
        
        // set value if we have a valid cell object
        id obj = [cells valueForKey:columnKeys[i]];
        if ([obj isKindOfClass:[ANDataTableCell class]] == FALSE)
        {
            continue;
        }
        
        newRow[newRow.count - 1] = obj;
    }
}

// access to cell
-(ANDataTableCell*)cellAt:(NSString*)columnKey
                 rowIndex:(NSUInteger)rowIndex
{
    if (columnKey == nil)
    {
        return nil;
    }
    
    NSInteger _columnIndex = [self _ColumnIndex:columnKey];
    NSInteger _rowIndex = [self _RowIndex:rowIndex];
    
    if (_columnIndex < 0)
    {
        return nil;
    }
    
    // first row is for column keys
    return [_metricValues[_rowIndex] objectAtIndex:_columnIndex];
}

@end
