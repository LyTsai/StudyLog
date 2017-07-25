//
//  TRMetricDataTable.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/10/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "ANDataTableCell.h"

// object that holds the table of measured metric values and viewing information for feeding into tree ring map
// the table data object is used for sending tabula data format displayed by tree ring map slice view
// this object is usually loaded from annielyticx backend
@interface TRMetricDataTable : NSObject{
    
}

// properties

// methods for creating data table
-(id)initWithTitle:(NSString*)title;

// table title
@property(strong, nonatomic)NSMutableString* title;

// two demensional measured metric value tables.  Think this of as similar to the excel table
// that has first row for column labels and the rest rows as actual data set
// metricValues is array of matric value arrays whith the first array element for metric keys

// metricValues[0] - array of column names
// metricValues[0][i] - ith column name

// metricValues[0][0] - row ID such as date used for row axis
// metricValues[r][0] - r > 0. used for rth row axis label
// metricValues[r][i] - r > 0 and i > 0.  metric value object (ANDataTableCell) for ith column at row rth
@property(strong, nonatomic)NSMutableArray* metricValues;

// methods for interacting with data table:

// setup table column with array of key strings
-(void)createTableColumnKeys:(NSArray*)columnKeys;
// add new column for the given metric key
-(void)addColumnKey:(NSString*)columnKey;
// array of column strings.
-(NSArray*)columnKeys;

// number of value rows (measurement set)
-(NSUInteger)numberOfRows;
// get row ID
-(NSString*)rowID:(NSInteger)row;

// data input methods:

// you can always input the data by directly setting table "metricValues".  but you have to make sure that you set the table cells with the right type (ANDataTableCell) at the correct location (row, column).
// or you call following methods with somewhat slower speed but more secure
// set table data cell at location (rowKey, columnKey)
-(void)setTableCell:(NSString*)columnKey
           rowIndex:(NSUInteger)rowIndex
               cell:(ANDataTableCell*)cell;

// set one row of cells with dictionary of ANDataTableCell by column key
// cells - dictionary of (columnKey, ANDataTableCell*)
-(void)addRow:(NSString*)rowID
        cells:(NSDictionary*)cells;

// access to cell
-(ANDataTableCell*)cellAt:(NSString*)columnKey
                 rowIndex:(NSUInteger)rowIndex;

@end
