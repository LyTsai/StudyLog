//
//  ANVLModelCollection.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANVLModel.h"

@interface ANVLModelCollection : NSObject

// number of models
-(NSInteger)numberOfModels;

// add one model set
-(void)addModel:(NSString*)modelKey
           data:(ANVLNode*)data
           view:(ANMetricsCollection*)view;

-(ANVLModel*)getModel:(NSString*)modelKey;

-(NSArray*)keys;

// test functions creating samples

@end
