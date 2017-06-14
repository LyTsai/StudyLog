//
//  TRDataTableFactory.h
//  ATreeRingMap
//
//  Created by hui wang on 12/25/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMetricDataTable.h"

// Create TRMetricDataTable data table source to be fed into tree ring map
@interface TRDataTableFactory : NSObject{
    
}

// Sample data set for demo purpose
//////////////////////////////////////////////////////////////////////////////////
// create table object using new format
//////////////////////////////////////////////////////////////////////////////////
// game of scores slice of risk factors static / under control
-(TRMetricDataTable*)createLowVitDGameOfScoresTable_Static;
-(TRMetricDataTable*)createLowVitDGameOfScoresTable_Dynamic;

@end
