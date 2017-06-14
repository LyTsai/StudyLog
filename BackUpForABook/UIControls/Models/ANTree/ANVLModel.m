//
//  ANVLModel.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLModel.h"
#import "ANVLModelFactory.h"

@implementation ANVLModel

-(id)init
{
    if (self == nil)
    {
        self = [super init];
    }
    
    _data = nil;
    
    _view = [[ANMetricsCollection alloc] init];
    [_view createDefaultMetricsList];

    
    return self;
}

// test methods
// create test data set
-(void)createTestModel
{
    _data = [ANVLModelFactory createSampleBook_1];
    
    if (_view == nil)
    {
        _view = [[ANMetricsCollection alloc] init];
        [_view createDefaultMetricsList];
    }
}

// return lab test node
-(ANVLNode*)userLabTestNode
{
    if (_data == nil)
    {
        return nil;
    }
    
    ANVLNode* firstUser = [_data.subNodes objectAtIndex:0];
    if (firstUser == nil)
    {
        return nil;
    }
    
    return [firstUser.subNodes objectAtIndex:1];
}

@end
