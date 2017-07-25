//
//  ANVLModelCollection.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLModelCollection.h"

@implementation ANVLModelCollection
{
    @private
    NSMutableDictionary *_models;
}

-(id)init
{
    if (self == nil)
    {
        self = [super init];
    }
    
    _models = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(NSInteger)numberOfModels
{
    return _models.count;
}

-(void)addModel:(NSString*)modelKey
           data:(ANVLNode*)data
           view:(ANMetricsCollection*)view
{
    if (_models == nil)
    {
        _models = [[NSMutableDictionary alloc] init];
    }
    
    ANVLModel* model = [[ANVLModel alloc] init];
    model.data = data;
    model.view = view;
    
    [_models setObject:model forKey:modelKey];
}

-(ANVLModel*)getModel:(NSString*)modelKey
{
    if (_models == nil)
    {
        return nil;
    }
    
    return [_models objectForKey:modelKey];
}

-(NSArray*)keys
{
    if (_models == nil)
    {
        return nil;
    }
    
    return [_models allKeys];
}

@end
