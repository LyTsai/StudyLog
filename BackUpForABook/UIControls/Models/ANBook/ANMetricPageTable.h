//
//  ANMetricPageTable.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricTable.h"

// sections of tables on the same page
@interface ANMetricPageTable : NSObject

// properties
// page title
@property(strong, nonatomic) NSString* title;
// section table.  array of ANMetricTable
@property(readonly)NSArray* tables;

-(id)init;

// add page table
-(void)addTable:(ANMetricTable*)table;

// access to page contents
-(NSUInteger)numberOfTables;
-(ANMetricTable*)getTable:(NSUInteger)tableNumber;

// test methods
// create test data set
-(void)createTestPageTable;

@end
