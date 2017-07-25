//
//  ANVLModelFactory.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLModelFactory.h"
#import "metrics.h"

@implementation ANVLModelFactory

// create sample model

// helper functions

// create sample page node for testing purpose
// node structure:
// user: "user ID", "Lab Test"
// "Lab Test": "Sample1", "Sample2",,,,"Sample6"
// "Sample": "Blood Test", "Years", "Risks"
// "Blood Test":
// "Years":
// "Risks":
+(ANVLNode*)addSampleUser
{
    // start one collection
    ANVLNode* user = [[ANVLNode alloc] initWith:NODECLASS_GENERAL info:@"User" metric:[[ANVLMetric alloc] initWith:ANLTCS_GENERIC value:30] time:[NSDate date]];
    
    
    // (1) add user info node
    [user addNode:[[ANVLUserInfo alloc] initWithInfo:@"User ID" contact:nil personal:nil]];
    
    // (2) add lab test collection node
    ANVLNode* test = [[ANVLNode alloc] initWith:NODECLASS_TIME_SERIES_UNIFORM info:@"Lab Test" metric:[[ANVLMetric alloc] initWith:ANLTCS_GENERIC value:48] time:[NSDate date]];
    
    // add 6 set of test samples (time serials) into collection node "test"
    int i;
    
    for (i = 0; i < 6; i++)
    {
        // sample node
        ANVLNode* sample = [[ANVLNode alloc] initWith:NODECLASS_PHYSICAL_BEGIN info:@"lab-physical" metric:[[ANVLMetric alloc] initWith:ANLTCS_GENERIC value:20] time:[NSDate date]];
        
        // (1) add blood test data section
        ANVLNode* bloodtestsection = [[ANVLNode alloc] initWith:NODECLASS_LABTEST_BLOOD info:@"Blood Test" metric:[[ANVLMetric alloc] initWith:ANLTCS_GENERIC value:30] time:nil];
        
        // add all metrics
        [bloodtestsection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_NEWCHOLESTEROL value:36] time:nil]];
        [bloodtestsection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_NEWCHOLESTEROL value:36] time:nil]];
  
        [sample addNode:bloodtestsection];
        
        // (2) add physical data section
        
        // add years data
        ANVLNode* yearssection = [[ANVLNode alloc] initWith:NODECLASS_ANNIELYTICS_YEARS info:@"Years" metric:[[ANVLMetric alloc] initWith:ANLTCS_GENERIC value:20] time:nil];
        
        // add all metrics
        [yearssection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_SKIN_YEARS value:-3] time:nil]];
        [yearssection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_HEART_YEARS value:3] time:nil]];
        [yearssection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_BRAIN_YEARS value:-3] time:nil]];
        
        [sample addNode:yearssection];
        
        // (3) add risk data section
        ANVLNode* risksection = [[ANVLNode alloc] initWith:NODECLASS_ANNIELYTICS_RISKS info:@"Risks" metric:[[ANVLMetric alloc] initWith:ANLTCS_GENERIC value:40] time:nil];
        
        // add all metrics
        [risksection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_NEWCHOLESTEROL value:36] time:nil]];
        
        [risksection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_DIABETES_RISK value:36] time:nil]];
        
        [risksection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_CVD_RISK value:13] time:nil]];
        
        [risksection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_10YEARSURVIVAL value:38] time:nil]];
        
        [risksection addNode:[[ANVLNode alloc] initWith:NODECLASS_GENERAL info:nil metric:[[ANVLMetric alloc] initWith:ANMETRIC_STROKE_RISK value:53] time:nil]];
        
        [sample addNode:risksection];
        
        // done.  add to test node
        [test addNode:sample];
    }
    
    [user addNode:test];
    
    // (3) add physical health collection node
    
    // add cognitive activities collection node
    
    // add social engagement collection node
    
    // add diet and nutrition collection node
    
    // add fitness collection node
    
    return user;
}

+(ANVLNode*)createSampleBook_1
{
    // root
    ANVLNode* root = [[ANVLNode alloc] initWith:NODECLASS_USER_SAMPLE_BOOK1 info:@"Test data set" metric:nil time:[NSDate date]];
    
    // add user 1
    ANVLNode* user = [ANVLModelFactory addSampleUser];
    user.info = @"User 1";
    [root addNode:user];
    
    // add user 2
    user = [ANVLModelFactory addSampleUser];
    user.info = @"User 2";
    [root addNode:user];
    
    // add user 3
    user = [ANVLModelFactory addSampleUser];
    user.info = @"User 3";
    [root addNode:user];
    
    return root;
}

@end
