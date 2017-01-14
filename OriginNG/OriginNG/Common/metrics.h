//
//  metrics.h
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.

// metric range types

#ifndef METRICS_DEF
#define METRICS_DEF

#import <Foundation/Foundation.h>

// metric value types:
// there are two types of metrics:
// (1) classification (including boolean)
// (2) continuous measurement values
typedef enum
{
    // unknown type
    MetricClass_Unknown        = 0,
    // classification such as: heart age, "good" or "bad" etc as defined in CLASSIFICATION.  value can be either numberic or string
    MetricClass_Classification = 1,
    // continous value
    MetricClass_Measurement    = 2
}MetricClass;

// range types: >, >=, <, <=, >&&<, >=&&<, >&&<=, >=&&<=, != and =
typedef enum
{
    // not defined
    RangeType_NA            = 0,
    // has to be with (min, max)
    RangeType_MinMax        = 1,        // >&&<
    RangeType_MinEquMax     = 2,        // >=&&<
    RangeType_MinMaxEqu     = 3,        // >&&<=
    RangeType_MinEquMaxEqu  = 4,        // >=&&<=
    // has to be greater than min
    RangeType_Min           = 5,        // >
    RangeType_MinEqu        = 6,        // >=
    // has to be less than max
    RangeType_Max           = 7,        // <
    RangeType_MaxEqu        = 8,        // <=
    // not equal
    RangeType_NOTEqu        = 9,       // !=
    // equal
    RangeType_Equ           = 10        // =
}ANRangeType;

//////////////////////////////////////////////////////
// supported unit type:
//////////////////////////////////////////////////////
typedef enum
{
    UNIT_ABS           = 0,     // absolute unit
    UNIT_ARB,                   // arb
    UNIT_PERCENT,               // %
    UNIT_MGDL,                  // mg/dl
    UNIT_MMHG,                  // mm Hg
    UNIT_YEARS                  // age / years
}UNIT;

//////////////////////////////////////////////////////
// defult unit symbol strings:
//////////////////////////////////////////////////////
#define UNIT_STRING_ABS                         @" "
#define UNIT_STRING_ARB                         @"arb"
#define UNIT_STRING_PERCENT                     @"%"
#define UNIT_STRING_MGDL                        @"mg/dl"
#define UNIT_STRING_MMHG                        @"mm Hg"
#define UNIT_STRING_YEARS                       @"years"


//////////////////////////////////////////////////////
// annielytics scores:
//////////////////////////////////////////////////////
#define ANMETRIC_SCORE_GENERAL                  @"AN_SCORE_GENERAL"
#define ANMETRIC_SCORE_HEALTH                   @"AN_SCORE_HEALTH"
#define ANMETRIC_SCORE_LIFESTYLE                @"AN_SCORE_LIFESTYLE"
#define ANMETRIC_SCORE_LIFESTYLE_SLEEP          @"AN_SCORE_LIFESTYLE_SLEEP"

//////////////////////////////////////////////////////
// annielytics assessment:
//////////////////////////////////////////////////////
// annielytics general assessment: very high, high, normal, low and very low
#define ANMETRIC_ASSESSMENT                     @"AN_ASSESSMENT"
// american heart association assessment
#define ANMETRIC_AMERICAN_HEART_ASSESSMENT      @"AN_AHA_ASSESSMENT"

//////////////////////////////////////////////////////
// risks:
//////////////////////////////////////////////////////
#define ANMETRIC_CVD_RISK                       @"CVD_RISK"
#define ANMETRIC_STROKE_RISK                    @"STROKE_RISK"
#define ANMETRIC_DIABETES_RISK                  @"DIABETES_RISK"
#define ANMETRIC_10YEARSURVIVAL                 @"10YEARSURVIVAL"
#define ANMETRIC_NEWCHOLESTEROL                 @"NEWCHOLESTEROL"
#define ANMETRIC_VITMIN_D3                      @"VITMIN_D3"
#define ANMETRIC_VITMIN_B                       @"VITMIN_B"
#define ANMETRIC_VITMIN_M                       @"VITMIN_M"
#define ANMETRIC_VITMIN_C                       @"VITMIN_C"

//////////////////////////////////////////////////////
// annielytics age / years:
//////////////////////////////////////////////////////
#define ANMETRIC_HEART_YEARS                    @"AN_HEART_YEARS"
#define ANMETRIC_BRAIN_YEARS                    @"AN_BRAIN_YEARS"
#define ANMETRIC_SKIN_YEARS                     @"AN_SKIN_YEARS"


//////////////////////////////////////////////////////
// supported metric keys in defualt set by classes:
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
// lab tests:
//////////////////////////////////////////////////////

#define ANMETRIC_TC                             @"BT_TC"
#define ANMETRIC_LDL                            @"BT_LDL"
#define ANMETRIC_HDL                            @"BT_HDL"
#define ANMETRIC_TRIG                           @"BT_TRIG"
#define ANMETRIC_BMI                            @"BT_BMI"
#define ANMETRIC_ABSI                           @"BT_ABSI"
#define ANMETRIC_BG                             @"BT_BG"
#define ANMETRIC_BP_SYS                         @"BP_SYS"
#define ANMETRIC_BP_DIAS                        @"BP_DIAS"

// general health information (vtD)
#define ANMETRIC_GHI_AGE                        @"GHI_AGE"
#define ANMETRIC_GHI_SKIN                       @"GHI_SKIN"
#define ANMETRIC_GHI_BODY_FAT                   @"GHI_BODY_FAT"
#define ANMETRIC_GHI_ENVIRONMENT                @"GHI_ENVIRONMENT"
#define ANMETRIC_GHI_LATITUDE                   @"GHI_LATITUDE"
#define ANMETRIC_GHI_SUNEXPOSURE                @"GHI_SUNEXPOSURE"
#define ANMETRIC_GHI_SEASON                     @"GHI_SEASON"
#define ANMETRIC_GHI_PREGNANCY                  @"GHI_PREGNANCY"
#define ANMETRIC_GHI_DIET                       @"GHI_DIET"
#define ANMETRIC_GHI_DNAGEN                     @"GHI_DNAGEN"
#define ANMETRIC_GHI_BLOODTEST_D3               @"GHI_D3"
#define ANMETRIC_GHI_DISEASE                    @"GHI_DISEASE"
#define ANMETRIC_GHI_MEDICATION                 @"GHI_MEDICATION"

// general health information 26 brain age
#define ANMETRIC_GHI_SLEEP                      @"GHI_SLEEP"
#define ANMETRIC_GHI_FRUITS                     @"GHI_FRUITS"
#define ANMETRIC_GHI_BERRIES                    @"GHI_BERRIES"
#define ANMETRIC_GHI_FISH_OMGA3                 @"GHI_FISH_OMGA3"
#define ANMETRIC_GHI_SUPPLEMENT_OMG3            @"GHI_SUPPLEMENT_OMG3"
#define ANMETRIC_GHI_FOLICACID                  @"GHI_FOLICACID"
#define ANMETRIC_GHI_ASPIRIN                    @"GHI_ASPIRIN"
#define ANMETRIC_GHI_REDWINE                    @"GHI_REDWINE"
#define ANMETRIC_GHI_EXERCISE                   @"GHI_EXERCISE"
#define ANMETRIC_GHI_BOOKS_PUZZLES              @"GHI_BOOKS_PUZZLES"
#define ANMETRIC_GHI_LESS_TC                    @"GHI_LESS_TC"
#define ANMETRIC_GHI_LESS_LDL                   @"GHI_LESS_LDL"
#define ANMETRIC_GHI_LONGEVITY_GENES            @"GHI_LONGEVITY_GENES"
#define ANMETRIC_GHI_OBESE                      @"GHI_OBESE"
#define ANMETRIC_GHI_MEDITERRANEAN_DIET         @"GHI_MEDITERRANEAN_DIET"
#define ANMETRIC_GHI_OLIVE_OIL                  @"GHI_OLIVE_OIL"
#define ANMETRIC_GHI_SMOKE                      @"GHI_SMOKE"
#define ANMETRIC_GHI_NORMALBLOODPRESSURE        @"GHI_NORMAL_BP"
#define ANMETRIC_GHI_DIABETES2                  @"GHI_DIABETES2"
#define ANMETRIC_GHI_METABOLIC_SYNDROME         @"GHI_METABOLIC_SYNDROME"
#define ANMETRIC_GHI_SLEEP_DISORDER             @"GHI_SLEEP_DISORDER"
#define ANMETRIC_GHI_STRESS                     @"GHI_STRESS"
#define ANMETRIC_GHI_SOCIAL_SUPPORT             @"GHI_SOCIAL_SUPPORT"
#define ANMETRIC_GHI_MEMORY_PROBLEM             @"GHI_MEMORY_PROBLEM"
#define ANMETRIC_GHI_EFFORT                     @"GHI_EFFORT"
#define ANMETRIC_GHI_VTD_DEFICINT               @"GHI_VTD_DEFICINT"

// 9 cards life style questions
#define ANMETRIC_GHI_NO_SMOKING                 @"GHI_No_Smoking"
#define ANMETRIC_GHI_MICRONUTRIENTS             @"GHI_Micro_Nutrients"
#define ANMETRIC_GHI_SLEEPING                   @"GHI_7-8 Hours of Sleep"
#define ANMETRIC_GHI_HYDRATION                  @"GHI_Hydration"
#define ANMETRIC_GHI_SKINNYJEAN                 @"GHI_Skinny Jeans Fit"
#define ANMETRIC_GHI_10KSTEP                    @"GHI_10K Steps"
#define ANMETRIC_GHI_DESTRESS                   @"GHI_De-stress / Deep Breathing"
#define ANMETRIC_GHI_NOLONGSITTING              @"GHI_No Prolonged Sitting"
#define ANMETRIC_GHI_HEALTHYDIET                @"GHI_Healthy Diet / Fruits + Veg"

// more to different files.  netter in xml or object file

typedef enum
{
    // brain age risk factor classification.  see annielytics brain age calculator for details
    CLASSIFICATION_BRAIN_AGE,
    CLASSIFICATION_BRAIN_AGE_SLEEP_7HOURS_YES,
    CLASSIFICATION_BRAIN_AGE_SLEEP_7HOURS_NO,
    CLASSIFICATION_BRAIN_AGE_FRUITS_VEG_YES,
    CLASSIFICATION_BRAIN_AGE_FRUITS_VEG_NO,
    CLASSIFICATION_BRAIN_AGE_BERRIES_YES,
    CLASSIFICATION_BRAIN_AGE_BERRIES_NO,
    CLASSIFICATION_BRAIN_AGE_FISH_OMGA3_YES,
    CLASSIFICATION_BRAIN_AGE_FISH_OMGA3_NO,
    CLASSIFICATION_BRAIN_AGE_SUPPLEMENT_OMG3_YES,
    CLASSIFICATION_BRAIN_AGE_SUPPLEMENT_OMG3_NO,
    CLASSIFICATION_BRAIN_AGE_FOLICACID_YES,
    CLASSIFICATION_BRAIN_AGE_FOLICACID_NO,
    CLASSIFICATION_BRAIN_AGE_ASPIRIN_YES,
    CLASSIFICATION_BRAIN_AGE_ASPIRIN_NO,
    CLASSIFICATION_BRAIN_AGE_REDWINE_YES,
    CLASSIFICATION_BRAIN_AGE_REDWINE_NO,
    CLASSIFICATION_BRAIN_AGE_EXERCISE_YES,
    CLASSIFICATION_BRAIN_AGE_EXERCISE_NO,
    CLASSIFICATION_BRAIN_AGE_BOOKS_PUZZLES_YES,
    CLASSIFICATION_BRAIN_AGE_BOOKS_PUZZLES_NO,
    CLASSIFICATION_BRAIN_AGE_LESS_TC_YES,
    CLASSIFICATION_BRAIN_AGE_LESS_TC_NO,
    CLASSIFICATION_BRAIN_AGE_LESS_LDL_YES,
    CLASSIFICATION_BRAIN_AGE_LESS_LDL_NO,
    CLASSIFICATION_BRAIN_AGE_LONGEVITY_GENES_YES,
    CLASSIFICATION_BRAIN_AGE_LONGEVITY_GENES_NO,
    CLASSIFICATION_BRAIN_AGE_OBESE_YES,
    CLASSIFICATION_BRAIN_AGE_OBESE_NO,
    CLASSIFICATION_BRAIN_AGE_MEDITERRANEAN_DIET_YES,
    CLASSIFICATION_BRAIN_AGE_MEDITERRANEAN_DIET_NO,
    CLASSIFICATION_BRAIN_AGE_OLIVE_OIL_YES,
    CLASSIFICATION_BRAIN_AGE_OLIVE_OIL_NO,
    CLASSIFICATION_BRAIN_AGE_SMOKE_YES,
    CLASSIFICATION_BRAIN_AGE_SMOKE_NO,
    CLASSIFICATION_BRAIN_AGE_NORMALBLOODPRESSURE_YES,
    CLASSIFICATION_BRAIN_AGE_NORMALBLOODPRESSURE_NO,
    CLASSIFICATION_BRAIN_AGE_DIABETES_2_YES,
    CLASSIFICATION_BRAIN_AGE_DIABETES_2_NO,
    CLASSIFICATION_BRAIN_AGE_METABOLIC_SYNDROME_YES,
    CLASSIFICATION_BRAIN_AGE_METABOLIC_SYNDROME_NO,
    CLASSIFICATION_BRAIN_AGE_SLEEP_DISORDER_YES,
    CLASSIFICATION_BRAIN_AGE_SLEEP_DISORDER_NO,
    CLASSIFICATION_BRAIN_AGE_STRESS_YES,
    CLASSIFICATION_BRAIN_AGE_STRESS_NO,
    CLASSIFICATION_BRAIN_AGE_SOCIAL_SUPPORT_YES,
    CLASSIFICATION_BRAIN_AGE_SOCIAL_SUPPORT_NO,
    CLASSIFICATION_BRAIN_AGE_MEMORY_PROBLEM_YES,
    CLASSIFICATION_BRAIN_AGE_MEMORY_PROBLEM_NO,
    CLASSIFICATION_BRAIN_AGE_EFFORT_YES,
    CLASSIFICATION_BRAIN_AGE_EFFORT_NO,
    CLASSIFICATION_BRAIN_AGE_VTD_DEFICINT_YES,
    CLASSIFICATION_BRAIN_AGE_VTD_DEFICINT_NO,
    CLASSIFICATION_BRAIN_AGE_END
    // end of brain age risk classification
    
}CLASSIFICATION;

///////////////////////////////////////////////////////////////////////////////
// metric classifications such as Annielyticx or AHA classification etc
///////////////////////////////////////////////////////////////////////////////

// !!! the cassifications are defined with three parts:
// (1) classification score values as enum
// (2) key for each claasification
// (3) text info for each classification

////////////////////////////
#define CLASSIFICATION_NAME(ORIGIN, TYPE) [NSString stringWithFormat:@"%@+%@",ORIGIN, TYPE]

// ANMETRIC_ASSESSMENT - annielytics in general: very high, high, normal, low, very low
typedef NS_ENUM(NSInteger, CLASSIFICATION_ANLTCS_GENERAL)
{
    CLASSIFICATION_ANLTCS_GENERAL_VERY_HIGH,
    CLASSIFICATION_ANLTCS_GENERAL_HIGH,
    CLASSIFICATION_ANLTCS_GENERAL_NORMAL,
    CLASSIFICATION_ANLTCS_GENERAL_LOW,
    CLASSIFICATION_ANLTCS_GENERAL_VERY_LOW
};

// very high, high, normal, low, very low
static NSString* ANLTCS_GENERIC = @"AnnieLyticx Gereric";
static NSString* ANLTCS_GENERIC_VERYHIGH = @"Very High";
static NSString* ANLTCS_GENERIC_HIGH = @"High";
static NSString* ANLTCS_GENERIC_NORMAL = @"Normal";
static NSString* ANLTCS_GENERIC_LOW = @"Low";
static NSString* ANLTCS_GENERIC_VERYLOW = @"Very Low";

// names
#define ANLTCS_GENERIC_VERYHIGH_NAME    CLASSIFICATION_NAME(ANLTCS_GENERIC, ANLTCS_GENERIC_VERYHIGH)
#define ANLTCS_GENERIC_HIGH_NAME        CLASSIFICATION_NAME(ANLTCS_GENERIC, ANLTCS_GENERIC_HIGH)
#define ANLTCS_GENERIC_NORMAL_NAME      CLASSIFICATION_NAME(ANLTCS_GENERIC, ANLTCS_GENERIC_NORMAL)
#define ANLTCS_GENERIC_LOW_NAME         CLASSIFICATION_NAME(ANLTCS_GENERIC, ANLTCS_GENERIC_LOW)
#define ANLTCS_GENERIC_VERYLOW_NAME     CLASSIFICATION_NAME(ANLTCS_GENERIC, ANLTCS_GENERIC_VERYLOW)

// keys
#define ANLTCS_GENERIC_VERYHIGH_KEY     @"56477a46-94cc-4c73-83ae-3ea1d96c6c7e"
#define ANLTCS_GENERIC_HIGH_KEY         @"99bb14e8-6a1e-4eda-ad8a-cb7a5638ada2"
#define ANLTCS_GENERIC_NORMAL_KEY       @"f0986d27-ff10-4646-a816-152fd6e5d89e"
#define ANLTCS_GENERIC_LOW_KEY          @"24012589-c715-470d-8d03-40738b45384e"
#define ANLTCS_GENERIC_VERYLOW_KEY      @"b818a45c-5dcf-4e34-97a8-1218f62bf749"


////////////////////////////
// ANLTCS_HML
////////////////////////////
typedef NS_ENUM(NSInteger, CLASSIFICATION_ANLTCS_HML)
{
    // "High", "Medium", "Low"
    CLASSIFICATION_ANLTCS_HML_HIGH,
    CLASSIFICATION_ANLTCS_HML_MEDIUM,
    CLASSIFICATION_ANLTCS_HML_LOW
};

// high, medium, low
static NSString* ANLTCS_HML = @"AnnieLyticx HML";
static NSString* ANLTCS_HML_HIGH = @"High";
static NSString* ANLTCS_HML_MEDIUM = @"Medium";
static NSString* ANLTCS_HML_LOW = @"Low";

// names
#define ANLTCS_HML_HIGH_NAME        CLASSIFICATION_NAME(ANLTCS_HML, ANLTCS_HML_HIGH)
#define ANLTCS_HML_MEDIUM_NAME      CLASSIFICATION_NAME(ANLTCS_HML, ANLTCS_HML_MEDIUM)
#define ANLTCS_HML_LOW_NAME         CLASSIFICATION_NAME(ANLTCS_HML, ANLTCS_HML_LOW)

// keys
#define ANLTCS_HML_HIGH_KEY         @"aefeb652-5f76-44a3-9ba5-7f0bd60f1241"
#define ANLTCS_HML_MEDIUM_KEY       @"413e07ab-9467-49ac-a7e6-5694c864be13"
#define ANLTCS_HML_LOW_KEY          @"a1903a19-714e-4d53-acbe-cd1a1aad710a"

////////////////////////////
// ANLTCS_DEGREE
////////////////////////////
typedef NS_ENUM(NSInteger, CLASSIFICATION_ANLTCS_DEGREE)
{
    // "Best", "Better", "Good", "Ok", "Bad", "Worse", "Worst" for degree
    CLASSIFICATION_ANLTCS_DEGREE_BEST,
    CLASSIFICATION_ANLTCS_DEGREE_BETTER,
    CLASSIFICATION_ANLTCS_DEGREE_GOOD,
    CLASSIFICATION_ANLTCS_DEGREE_OK,
    CLASSIFICATION_ANLTCS_DEGREE_BAD,
    CLASSIFICATION_ANLTCS_DEGREE_WORSE,
    CLASSIFICATION_ANLTCS_DEGREE_WORST
};

// "Best", "Better", "Good", "Ok", "Bad", "Worse", "Worst"
static NSString* ANLTCS_DEGREE = @"AnnieLyticx Scale";
static NSString* ANLTCS_DEGREE_BEST = @"Best";
static NSString* ANLTCS_DEGREE_BETTER = @"Better";
static NSString* ANLTCS_DEGREE_GOOD = @"Good";
static NSString* ANLTCS_DEGREE_OK = @"Ok";
static NSString* ANLTCS_DEGREE_BAD = @"Bad";
static NSString* ANLTCS_DEGREE_WORSE = @"Worse";
static NSString* ANLTCS_DEGREE_WORST = @"Worst";

// names
#define ANLTCS_DEGREE_BEST_NAME     CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_BEST)
#define ANLTCS_DEGREE_BETTER_NAME   CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_BETTER)
#define ANLTCS_DEGREE_GOOD_NAME     CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_GOOD)
#define ANLTCS_DEGREE_OK_NAME       CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_OK)
#define ANLTCS_DEGREE_BAD_NAME      CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_BAD)
#define ANLTCS_DEGREE_WORSE_NAME    CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_WORSE)
#define ANLTCS_DEGREE_WORST_NAME    CLASSIFICATION_NAME(ANLTCS_DEGREE, ANLTCS_DEGREE_WORST)

// keys
#define ANLTCS_DEGREE_BEST_KEY      @"1dfb6d16-18a5-4f4b-92b7-2de47613458e"
#define ANLTCS_DEGREE_BETTER_KEY    @"9a9b5913-7c9c-44ff-9e2f-92e9afaeaa7c"
#define ANLTCS_DEGREE_GOOD_KEY      @"09bc9b8b-e7d6-41cf-aa37-188e7a07892e"
#define ANLTCS_DEGREE_OK_KEY        @"848ce819-db39-49ae-af52-408766b552e5"
#define ANLTCS_DEGREE_BAD_KEY       @"fe24f326-629a-408e-ac71-36d3679e7794"
#define ANLTCS_DEGREE_WORSE_KEY     @"056c9366-aeba-4eb0-abdb-851e4f10fc2b"
#define ANLTCS_DEGREE_WORST_KEY     @"77b95608-9505-4e36-89bf-b29cef296e3f"

////////////////////////////
// ANLTCS_ANSWER
////////////////////////////
typedef NS_ENUM(NSInteger, CLASSIFICATION_ANLTCS_ANSWER)
{
    // "Yes", "Maybe", "No", "Skip", "NA" for classifying answers
    CLASSIFICATION_ANLTCS_ANSWER_YES,
    CLASSIFICATION_ANLTCS_ANSWER_MAYBE,
    CLASSIFICATION_ANLTCS_ANSWER_NO,
    CLASSIFICATION_ANLTCS_ANSWER_SKIP,
    CLASSIFICATION_ANLTCS_ANSWER_NA
};

// "Yes", "Maybe", "No", "Skip", "NA"
static NSString* ANLTCS_ANSWER = @"AnnieLyticx QA";
static NSString* ANLTCS_ANSWER_YES = @"Yes";
static NSString* ANLTCS_ANSWER_MAYBE = @"Maybe";
static NSString* ANLTCS_ANSWER_NO = @"No";
static NSString* ANLTCS_ANSWER_SKIP = @"Skip";
static NSString* ANLTCS_ANSWER_NA = @"NA";

// names
#define ANLTCS_ANSWER_YES_NAME      CLASSIFICATION_NAME(ANLTCS_ANSWER, ANLTCS_ANSWER_YES)
#define ANLTCS_ANSWER_MAYBE_NAME    CLASSIFICATION_NAME(ANLTCS_ANSWER, ANLTCS_ANSWER_MAYBE)
#define ANLTCS_ANSWER_NO_NAME       CLASSIFICATION_NAME(ANLTCS_ANSWER, ANLTCS_ANSWER_NO)
#define ANLTCS_ANSWER_SKIP_NAME     CLASSIFICATION_NAME(ANLTCS_ANSWER, ANLTCS_ANSWER_SKIP)
#define ANLTCS_ANSWER_NA_NAME       CLASSIFICATION_NAME(ANLTCS_ANSWER, ANLTCS_ANSWER_NA)

// keys
#define ANLTCS_ANSWER_YES_KEY       @"d39420ef-f666-4595-b945-a2aeaf29b3a7"
#define ANLTCS_ANSWER_MAYBE_KEY     @"85301ad9-fb7e-4a22-9bb3-70358e5ad2d7"
#define ANLTCS_ANSWER_NO_KEY        @"6b3adc36-6a0e-447f-afa5-82e061b61359"
#define ANLTCS_ANSWER_SKIP_KEY      @"153a4057-acf8-4d39-a3da-b6e383003823"
#define ANLTCS_ANSWER_NA_KEY        @"e1b43670-502b-4882-b46e-17894a2bd78d"

#endif

