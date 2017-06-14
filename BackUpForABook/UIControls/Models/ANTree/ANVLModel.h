//
//  ANVLModel.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANVLNode.h"
#import "ANMetricsCollection.h"

// represents the data set and interpretation collection

// model types
typedef enum
{
    ANVLMODLETYPE_NA                    = 1,        // unknown type
    
    ANVLMODLETYPE_ANBOOK                = 2,        // annielyticx book
    
    ANVLMODLETYPE_QUESTIONNAIRE,        // questionnaireused for data input
    ANVLMODLETYPE_QUESTIONNAIRE_GENERAL = ANVLMODLETYPE_QUESTIONNAIRE + 1,
    ANVLMODLETYPE_QUESTIONNAIRE_VTD     = ANVLMODLETYPE_QUESTIONNAIRE + 2,
    ANVLMODLETYPE_QUESTIONNAIRE_MAGESIUM     = ANVLMODLETYPE_QUESTIONNAIRE + 3,
    ANVLMODLETYPE_QUESTIONNAIRE_B12     = ANVLMODLETYPE_QUESTIONNAIRE + 4,
    ANVLMODLETYPE_QUESTIONNAIRE_ALZHEIMERS  = ANVLMODLETYPE_QUESTIONNAIRE + 5,
    ANVLMODLETYPE_QUESTIONNAIRE_HEPATITIS   = ANVLMODLETYPE_QUESTIONNAIRE + 6,
    
    ANVLMODLETYPE_QUESTIONNAIRE_END,
    
    ANVLMODLETYPE_SLICE_DICE,
    ANVLMODLETYPE_SLICE_DICE_TIME       = ANVLMODLETYPE_SLICE_DICE + 1, // by time
    ANVLMODLETYPE_SLICE_DICE_METRIC     = ANVLMODLETYPE_SLICE_DICE + 2, // by metric
    ANVLMODLETYPE_SLICE_DICE_USER       = ANVLMODLETYPE_SLICE_DICE + 3, // by user
    
    ANVLMODLETYPE_SLICE_DICE_END        = ANVLMODLETYPE_SLICE_DICE + 1,
    
    ANVLMODLETYPE_END
}ANVLMODLETYPE;

// model class
@interface ANVLModel : NSObject

// properties
@property (readonly)ANVLMODLETYPE model;
// data tree
@property(strong, nonatomic)ANVLNode* data;
// interpretation
@property(strong, nonatomic)ANMetricsCollection* view;

// test methods
// create test data set
-(void)createTestModel;
// return lab test node
-(ANVLNode*)userLabTestNode;

@end
