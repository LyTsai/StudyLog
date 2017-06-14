//
//  ANMetricBook.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANMetricBook.h"

@implementation ANMetricBook
{
    @private
    
    // array of ANMetricTable
    NSMutableArray* _pages;
}

-(id)init
{
    if (self == nil)
    {
        self = [super init];
    }
    
    if (_pages == nil)
    {
        _pages = [[NSMutableArray alloc] init];
    }
    
    [self loadDefaultMetricCollection];
    
     _title = @"Empty Book";
    
    return self;
}

// load system default
-(void)loadDefaultMetricCollection
{
    if (_supportedMetrics == nil)
    {
        _supportedMetrics = [[ANMetricsCollection alloc] init];
    }
    
    [_supportedMetrics createDefaultMetricsList];
}

-(NSArray*)pages
{
    return _pages;
}

// add page
-(void)addPage:(ANMetricPageTable*)page
{
    if (_pages == nil)
    {
        _pages = [[NSMutableArray alloc] init];
    }
    
    [_pages addObject:page];
}

// access book
-(NSUInteger)numberOfPages
{
    return _pages.count;
}

-(ANMetricPageTable*)getPage:(NSUInteger)pageNumber
{
    if (pageNumber >= _pages.count)
    {
        return nil;
    }
    
    return [_pages objectAtIndex:pageNumber];
}

// map given metric value to view
-(ANMetricView*)metricView:(NSString*)metricKey
                     value:(double)value
{
    if (_supportedMetrics != nil)
    {
        return [_supportedMetrics metricView:metricKey value:value];
    }
    
    return nil;
}

// get metric information for the given metric key
-(ANMetric*) getMetric:(NSString*)key
{
    if (_supportedMetrics != nil)
    {
        return [_supportedMetrics getMetric:key];
    }
    
    return nil;
}

// create test data set
-(void)createTestBook
{
    if (_pages == nil)
    {
        _pages = [[NSMutableArray alloc] init];
    }
    
    _title = @"Test data set";
    
    // create all pages
    ANMetricPageTable* page = [[ANMetricPageTable alloc] init];
    
    [page createTestPageTable];
    [self addPage:page];
    
    page = [[ANMetricPageTable alloc] init];
    [page createTestPageTable];
    [self addPage:page];
    
    page = [[ANMetricPageTable alloc] init];
    [page createTestPageTable];
    [self addPage:page];
    
    page = [[ANMetricPageTable alloc] init];
    [page createTestPageTable];
    [self addPage:page];
    
    page = [[ANMetricPageTable alloc] init];
    [page createTestPageTable];
    [self addPage:page];
    
    page = [[ANMetricPageTable alloc] init];
    [page createTestPageTable];
    [self addPage:page];
    
    page = [[ANMetricPageTable alloc] init];
    [page createTestPageTable];
    [self addPage:page];
}

@end
