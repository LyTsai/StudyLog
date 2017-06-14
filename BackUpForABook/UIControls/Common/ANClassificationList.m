//
//  ANClassificationList.m
//  ANBookPad
//
//  Created by hui wang on 9/3/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import "ANClassificationList.h"
#import "ANClassification.h"
#import "metrics.h"

// define class for keeping a list of supported classifications
@implementation ANClassificationList
{
    NSMutableDictionary* _classificationList;
}

-(instancetype) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _classificationList = [[NSMutableDictionary alloc] init];
    
    return self;
}

// add classififcation: key - unique key in the system
-(void) addClassification:(NSString*)key
                     name:(NSString*)name
              displayName:(NSString*)displayName
                     info:(NSString*)info
                    color:(UIColor*)color
                    image:(UIImage*)image
                    score:(CGFloat)score;
{
    if (_classificationList == nil)
    {
        _classificationList = [[NSMutableDictionary alloc] init];
    }
    
    if ([_classificationList objectForKey:key] != nil)
    {
        // already have one key
        return ;
    }
    
    // create classification
    ANClassification* classification = [[ANClassification alloc] init];
    
    classification.key = key;
    classification.name = name;
    classification.displayName = displayName;
    classification.info = info;
    classification.color = color;
    classification.image = image;
    classification.score = score;
    
    // create projector for the given metric
    [_classificationList setObject:classification forKey:key];
}

// access the classififcation for specified calssification key
-(ANClassification*) classificationOf: (NSString*) key
{
    if (_classificationList == nil || key == nil)
    {
        return nil;
    }
    
    return [_classificationList objectForKey:key];
}

// get all supoorted keys
-(NSArray*) allClassifications
{
    if (_classificationList == nil)
    {
        return nil;
    }
    
    return [_classificationList allKeys];
}

// create sample for test purpose
+(ANClassificationList*) createSampleClassificationList
{
    ANClassificationList* sampleList = [[ANClassificationList alloc] init];
    
    // ANLTCS_GENERIC
    [sampleList addClassification:ANLTCS_GENERIC_VERYHIGH_KEY
                             name:ANLTCS_GENERIC_VERYHIGH
                      displayName:ANLTCS_GENERIC_VERYHIGH
                             info:ANLTCS_GENERIC
                            color:[UIColor redColor]
                            image:[UIImage imageNamed:@"face5.png"]
                            score:CLASSIFICATION_ANLTCS_GENERAL_VERY_HIGH];

    [sampleList addClassification:ANLTCS_GENERIC_HIGH_KEY
                             name:ANLTCS_GENERIC_HIGH
                      displayName:ANLTCS_GENERIC_HIGH
                             info:ANLTCS_GENERIC
                            color:[UIColor brownColor]
                            image:[UIImage imageNamed:@"face4.png"]
                            score:CLASSIFICATION_ANLTCS_GENERAL_HIGH];
    
    [sampleList addClassification:ANLTCS_GENERIC_NORMAL_KEY
                             name:ANLTCS_GENERIC_NORMAL
                      displayName:ANLTCS_GENERIC_NORMAL
                             info:ANLTCS_GENERIC
                            color:[UIColor yellowColor]
                            image:[UIImage imageNamed:@"face3.png"]
                            score:CLASSIFICATION_ANLTCS_GENERAL_NORMAL];
    
    [sampleList addClassification:ANLTCS_GENERIC_LOW_KEY
                             name:ANLTCS_GENERIC_LOW
                      displayName:ANLTCS_GENERIC_LOW
                             info:ANLTCS_GENERIC
                            color:[UIColor blueColor]
                            image:[UIImage imageNamed:@"face2.png"]
                            score:CLASSIFICATION_ANLTCS_GENERAL_LOW];
    
    [sampleList addClassification:ANLTCS_GENERIC_VERYLOW_KEY
                             name:ANLTCS_GENERIC_VERYLOW
                      displayName:ANLTCS_GENERIC_VERYLOW
                             info:ANLTCS_GENERIC
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face1.png"]
                            score:CLASSIFICATION_ANLTCS_GENERAL_VERY_LOW];

    // ANLTCS_HML
    // ANLTCS_DEGREE
    // ANLTCS_ANSWER
    
    // VTD_AGE
    [sampleList addClassification:AGE_YOUNG_KEY
                             name:AGE_YOUNG
                      displayName:AGE_YOUNG
                             info:VTD_AGE
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face1.png"]
                            score:CLASSIFICATION_VTD_AGE_YOUNG];
    
    [sampleList addClassification:AGE_MIDDLE_KEY
                             name:AGE_MIDDLE
                      displayName:AGE_MIDDLE
                             info:VTD_AGE
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face3.png"]
                            score:CLASSIFICATION_VTD_AGE_MIDDLE];

    [sampleList addClassification:AGE_SENIOR_BREAST_FED_INFANT_KEY
                             name:AGE_SENIOR_BREAST_FED_INFANT
                      displayName:AGE_SENIOR_BREAST_FED_INFANT
                             info:VTD_AGE
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face5.png"]
                            score:CLASSIFICATION_VTD_AGE_SENIOR_BREAST_FED_INFANT];

    // VTD_SKIN
    [sampleList addClassification:SKIN_PIGMENT_FAIR_PALE_KEY
                             name:SKIN_PIGMENT_FAIR_PALE
                      displayName:SKIN_PIGMENT_FAIR_PALE
                             info:VTD_SKIN
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face1.png"]
                            score:CLASSIFICATION_VTD_SKIN_PIGMENT_FAIR_PALE];
    
    [sampleList addClassification:SKIN_PIGMENT_MEDIUM_KEY
                             name:SKIN_PIGMENT_MEDIUM
                      displayName:SKIN_PIGMENT_MEDIUM
                             info:VTD_SKIN
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face3.png"]
                            score:CLASSIFICATION_VTD_SKIN_PIGMENT_MEDIUM];
    
    [sampleList addClassification:SKIN_PIGMENT_DARK_KEY
                             name:SKIN_PIGMENT_DARK
                      displayName:SKIN_PIGMENT_DARK
                             info:VTD_SKIN
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face5.png"]
                            score:CLASSIFICATION_VTD_SKIN_PIGMENT_DARK];
    
    // VTD_BODY_FAT
    [sampleList addClassification:BODY_FAT_LOW_KEY
                             name:BODY_FAT_LOW
                      displayName:BODY_FAT_LOW
                             info:VTD_BODY_FAT
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face1.png"]
                            score:CLASSIFICATION_VTD_SKIN_PIGMENT_FAIR_PALE];
    
    [sampleList addClassification:BODY_FAT_MEDIUM_KEY
                             name:BODY_FAT_MEDIUM
                      displayName:BODY_FAT_MEDIUM
                             info:VTD_BODY_FAT
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face3.png"]
                            score:CLASSIFICATION_VTD_SKIN_PIGMENT_MEDIUM];
    
    [sampleList addClassification:BODY_FAT_HIGH_KEY
                             name:BODY_FAT_HIGH
                      displayName:BODY_FAT_HIGH
                             info:VTD_BODY_FAT
                            color:[UIColor greenColor]
                            image:[UIImage imageNamed:@"face5.png"]
                            score:CLASSIFICATION_VTD_SKIN_PIGMENT_DARK];
    
    // VTD_ENVIRONMENT
    // VTD_LATITUDE
    // VTD_SUN_EXPOSURE
    // VTD_SEASON
    // VTD_PREGNANCY
    // VTD_DIET
    // VTD_DNA_GENE_POLYMORPHISM
    // VTD_BLOOD_TEST_D3_SERUM_LEVEL
    // VTD_DISEASES
    // VTD_MEDICATIONS
    
    return sampleList;
}

@end
