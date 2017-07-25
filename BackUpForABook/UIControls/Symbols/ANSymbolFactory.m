//
//  ANSymbolFactory.m
//  NodeGraph
//
//  Created by hui wang on 11/19/16.
//  Copyright © 2016 hui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANSymbolFactory.h"

#import "ASymbol_10_Year Survival.h"
#import "ASymbol_CheckMark_Na_1.h"
#import "ASymbol_CheckMark_No_1.h"
#import "ASymbol_CheckMark_Yes_1.h"
#import "ASymbol_CVD.h"
#import "ASymbol_Diabetes.h"
#import "ASymbol_Heart.h"
#import "ASymbol_NewCholestrol.h"
#import "ASymbol_Stroke.h"
#import "ASymbolButterfly.h"
#import "ASymbol_Heart1.h"
#import "ASymbol_Brain.h"

#import "ASymbol_Face1.h"
#import "ASymbol_Face2.h"
#import "ASymbol_Face3.h"
#import "ASymbol_Sleeps.h"
#import "ASymbol_SleepWell.h"
#import "ASymbol_Stress.h"
#import "ASymbol_Alcohol.h"
#import "ASymbol_Alzheimers.h"
#import "ASymbol_Aspirin.h"
#import "ASymbol_Berries.h"
#import "ASymbol_Exercise.h"
#import "ASymbol_Fish.h"
#import "ASymbol_FishOil.h"
#import "ASymbol_FolicAcid.h"
#import "ASymbol_ManageWeights.h"
#import "ASymbol_Mediate.h"
#import "ASymbol_Memory.h"
#import "ASymbol_SlimDownWaist.h"
#import "ASymbol_Smoking.h"
#import "ASymbol_Support.h"
#import "ASymbol_Vegetables.h"

#import "ASymbol_Background.h"
#import "ASymbol_LifeStyle_Diet.h"
#import "ASymbol_LifeStyle_Exercise.h"
#import "ASymbol_LifeStyle_Wellness.h"

#include "metrics.h"
////////////////////////////////////////////////////////
// symbol class factory
////////////////////////////////////////////////////////
// map metric key to symbolkey that can be used for view
// !!! note to add symbol for a metric you need to firtst create class for symbol drawing
// then add the class in the the symbol cration list for intented symbol key
// the symbol key is simply direct match to the metric key
#define ANSYMBOL_CHECKMARKNA1           @"CHECKMARKNA1"
#define ANSYMBOL_CHECKMARKYES1          @"CHECKMARKYES1"
#define ANSYMBOL_CHECKMARKNO1           @"CHECKMARKNO1"
#define ANSYMBOL_10YEARSURVIVAL         ANMETRIC_10YEARSURVIVAL
#define ANSYMBOL_CVD                    ANMETRIC_CVD_RISK
#define ANSYMBOL_DIABETES               ANMETRIC_DIABETES_RISK
#define ANSYMBOL_HEART                  @"heart"
#define ANSYMBOL_NEWCHOLESTROL          ANMETRIC_NEWCHOLESTEROL
#define ANSYMBOL_STROKE                 ANMETRIC_STROKE_RISK
#define ANSYMBOL_BUTTERFLY              @"BUTTERFLY"
#define ANSYMBOL_BRAIN                  ANMETRIC_BRAIN_YEARS
#define ANSYMBOL_HEART1                 ANMETRIC_HEART_YEARS
#define ANSYMBOL_ASSESSMENT             ANMETRIC_ASSESSMENT

APathDrawWrap* createSymbol(NSString* type, BOOL edge)
{
    APathDrawWrap* obj = nil;
    
    if ([type isEqual: ANSYMBOL_10YEARSURVIVAL])
    {
        obj = [ASymbol_10_Year_Survival warp];
    }else if ([type isEqual: ANSYMBOL_CHECKMARKNA1])
    {
        obj = [ASymbol_CheckMark_Na_1 warp];
    }else if ([type isEqual: ANSYMBOL_CHECKMARKYES1])
    {
        obj = [ASymbol_CheckMark_Yes_1 warp];
    }else if ([type isEqual: ANSYMBOL_CHECKMARKNO1])
    {
        obj = [ASymbol_CheckMark_No_1 warp];
    }else if ([type isEqual: ANSYMBOL_CVD])
    {
        obj = [ASymbol_CVD warp];
    }else if ([type isEqual: ANSYMBOL_DIABETES])
    {
        obj = [ASymbol_Diabetes warp];
    }else if ([type isEqual: ANSYMBOL_HEART])
    {
        obj = [ASymbol_Heart warp];
    }else if ([type isEqual: ANSYMBOL_NEWCHOLESTROL])
    {
        obj = [ASymbol_NewCholestrol warp];
    }else if ([type isEqual: ANSYMBOL_STROKE])
    {
        obj = [ASymbol_Stroke warp];
    }else if ([type isEqual: ANSYMBOL_BUTTERFLY])
    {
        obj = [ASymbolButterfly warp];
    }else if ([type isEqual: ANSYMBOL_BRAIN])
    {
        obj = [ASymbol_Brain warp];
    }else if ([type isEqual: ANSYMBOL_HEART1])
    {
        obj = [ASymbol_Heart1 warp];
    }else if ([type isEqual: ANSYMBOL_ASSESSMENT])
    {
        obj = [ASymbolButterfly warp];
    }else
    {
        obj = nil;
    }
    
    if (obj != nil && edge == FALSE)
    {
        obj.strokeColor = [UIColor clearColor].CGColor;
        obj.fillColor = [UIColor clearColor].CGColor;
    }
    
    return obj;
}

APageLayerPath* createSymbolLayerPath(SYMBOLPATH type)
{
    APageLayerPath* obj = nil;
    
    if (type == SYMBOLPATH_FACE1)
    {
        obj = [[ASymbol_Face1 alloc] init];
    }else if (type == SYMBOLPATH_FACE2)
    {
        obj = [[ASymbol_Face2 alloc] init];
    }else if (type == SYMBOLPATH_FACE3)
    {
        obj = [[ASymbol_Face3 alloc] init];
    }else if (type == SYMBOLPATH_BACKGROUND)
    {
        obj = [[ASymbol_Background alloc] init];
    }else if (type == SYMBOLPATH_LIFESTYLE_EXERCISE)
    {
        obj = [[ASymbol_LifeStyle_Exercise alloc] init];
    }else if (type == SYMBOLPATH_LIFESTYLE_DIET)
    {
        obj = [[ASymbol_LifeStyle_Diet alloc] init];
    }else if (type == SYMBOLPATH_LIFESTYLE_WELLNESS)
    {
        obj = [[ASymbol_LifeStyle_Wellness alloc] init];
    }else if (type == SYMBOLPATH_SLEEPS_ENOUGH)
    {
        obj = [[ASymbol_Sleeps alloc] init];
    }else if (type == SYMBOLPATH_SLEEPS_WELL)
    {
        obj = [[ASymbol_SleepWell alloc] init];
    }else if (type == SYMBOLPATH_STRESS)
    {
        obj = [[ASymbol_Stress alloc] init];
    }else if (type == SYMBOLPATH_ALCOHOL)
    {
        obj = [[ASymbol_Alcohol alloc] init];
    }else if (type == SYMBOLPATH_ALZHEIMERS)
    {
        obj = [[ASymbol_Alzheimers alloc] init];
    }else if (type == SYMBOLPATH_ASPIRIN)
    {
        obj = [[ASymbol_Aspirin alloc] init];
    }else if (type == SYMBOLPATH_BERRIES)
    {
        obj = [[ASymbol_Berries alloc] init];
    }else if (type == SYMBOLPATH_EXERCISE)
    {
        obj = [[ASymbol_Berries alloc] init];
    }else if (type == SYMBOLPATH_FISH)
    {
        obj = [[ASymbol_Fish alloc] init];
    }else if (type == SYMBOLPATH_FISHOIL)
    {
        obj = [[ASymbol_FishOil alloc] init];
    }else if (type == SYMBOLPATH_FOLICACID)
    {
        obj = [[ASymbol_FolicAcid alloc] init];
    }else if (type == SYMBOLPATH_MANAGEWEIGHTS)
    {
        obj = [[ASymbol_ManageWeights alloc] init];
    }else if (type == SYMBOLPATH_MEDIATE)
    {
        obj = [[ASymbol_Mediate alloc] init];
    }else if (type == SYMBOLPATH_MEMORY)
    {
        obj = [[ASymbol_Memory alloc] init];
    }else if (type == SYMBOLPATH_SLIMDOWNWAIST)
    {
        obj = [[ASymbol_SlimDownWaist alloc] init];
    }else if (type == SYMBOLPATH_SMOKING)
    {
        obj = [[ASymbol_Smoking alloc] init];
    }else if (type == SYMBOLPATH_SUPPORT)
    {
        obj = [[ASymbol_Support alloc] init];
    }else if (type == SYMBOLPATH_VEGETABLES)
    {
        obj = [[ASymbol_Vegetables alloc] init];
    }
    
    if (obj != nil)
    {
        [obj initDrawPros];
    }
    
    return obj;
}

APageLayerPath* getRandomSymbolPath()
{
    
    SYMBOLPATH r = arc4random_uniform(SYMBOLPATH_VEGETABLES - SYMBOLPATH_LIFESTYLE_WELLNESS);
    
    APageLayerPath* symbol = createSymbolLayerPath(r + SYMBOLPATH_LIFESTYLE_WELLNESS);
    
    return symbol;
}

APageLayerPath* getRandomSymbolPath_Face()
{
    SYMBOLPATH r = arc4random_uniform(SYMBOLPATH_FACE5 - SYMBOLPATH_FACE2);
    
    APageLayerPath* symbol = createSymbolLayerPath(r + SYMBOLPATH_FACE1);
    
    return symbol;
}


