//
//  TRDataTableSliceView.h
//  ATreeRingMap
//
//  Created by Hui Wang on 6/22/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRCell.h"
#import "TRMetricDataTable.h"

// used as property of TRSlice
// used for getting a slice view of parent TRDataTable table and set into TRSlice view
// it represents the view projection of selected partial or whole TRDataTable data set
// !!! The data set is orgainized by column to reflect the way TRSlice is begin used:
// columns of data (with identical number of rows) are inserted into the table.
// this is a 2 by 2 table of TRCells with row header saved in seperate array while
// column header text being saved in the column 0 in 2 x 2 table.
// !!! we do not assum the unique texts are passed.  we use the ordering for drawing.
// it is caller's responsibility to arrange data in the right order so cell data will match
// with the right row and column text lable.
@interface TRDataTableSliceView : NSObject{
    // array row text labels that defines the row dimension
    NSMutableArray *rowTexts;
    
    // table of TRCell objects that has visual presentatin information
    // columns[i] - NSArray of TRCell columns
    // columns[i][j] - (j - 1)th TRCell of ith NSArray column
    // columns[i][0] - colmn header text of ith column
    NSMutableArray *columns;
}

// methods for populating and accessing table data

// methods for populating table
// set up table rows with array of row lables
-(BOOL)setTableRows:(NSArray*)rowLabels;
// add one column of TRCell.  !!! must has size of (numberOfRows + 1) with first element to be header text
-(BOOL)addColumn:(NSArray*)oneColumn;
-(BOOL)addColumnAt:(NSArray*)oneColumn
          position:(int)position;

-(void)removeColumn:(int)position;
-(void)removeAllColumns;

// accessing table elements
// row tick lables
-(NSArray*)rowTickLabels;
// column tick lables
-(NSArray*)colTickLabels;
// number of data points
-(int)numberOfRows;
// number of data sets
-(int)numberOfColumns;
// row text at position pos
-(NSString*)rowText:(int)pos;
// column text at position pos
-(NSString*)columnText:(int)pos;
// TRCell data at position (nRow, nCol).
-(TRCell*)cell:(int)nRow
          nCol:(int)nCol;

// load table of metric values and view mapping table into slice
-(void)loadMetricDataTable:(TRMetricDataTable*)metricValues;

// Text method for debug purpose
-(void)createTestTable;
@end
