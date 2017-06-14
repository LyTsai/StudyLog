//
//  ANMetricBook.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricsCollection.h"
#import "ANMetricPageTable.h"

// represents collection of pages ANMetricPageTable
@interface ANMetricBook : NSObject

// properties

// book content interpretors:

// collections of suopported metrics for metric value mapping.  can be created onternally or set extenally
@property(strong, nonatomic)ANMetricsCollection* supportedMetrics;

// interconnectivities for connections among nodes (page, section, row items etc)

// book title
@property(strong, nonatomic) NSString* title;

// book pages.  array of ANMetricPageTable
@property(readonly)NSArray* pages;

// initialize the book
-(id)init;

// load metric list mapping info

// load system default
-(void)loadDefaultMetricCollection;

// load from external sources

// add page
-(void)addPage:(ANMetricPageTable*)page;

// access book
-(NSUInteger) numberOfPages;
-(ANMetricPageTable*)getPage:(NSUInteger)pageNumber;

// map given metric value to view
-(ANMetricView*)metricView:(NSString*)metricKey
                     value:(double)value;

// get metric information for the given metric key
-(ANMetric*) getMetric:(NSString*)key;

// test methods
// create test data set
-(void)createTestBook;

@end
