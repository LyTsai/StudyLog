//
//  ANMetricListFactory.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/12/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANMetricListFactory.h"

@implementation ANMetricListFactory

// useful functions:
// create default supported metric list
+(ANMetricList*)createDefaultMetricsList
{
    ANMetricList* metricList = [[ANMetricList alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"defaultMetricList" ofType:@"json"];
    NSData* content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString* jsonString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
    NSError * error = nil;
    NSArray * array = [ANMetric arrayOfModelsFromString:jsonString error:&error];
    for(id metric in array)
    {
        [metricList addMetric:metric];
    }
    return metricList;
}

// add one metric onto list
// metricList - metric list
// key - metric key for identifying the metric
// name - metric display name
// unitSymbol - metric unit symbol string
// unitType - metric unit type (!!! one of supported metric type)
// validMin, validMax - min and max range of valid metric value
// normalMin, normalMax - min and max range of normal metric value
+(void)addMetricOntoList:(ANMetricList*)metricList
                     key:(NSString*)key
                    name:(NSString *)name
                    unit:(NSString *)unitSymbol
                unitType:(int)unitType
             value_class:(MetricClass)value_class
{
    // create brand new metric object
    ANMetric* newMetric = [[ANMetric alloc] init];
    
    newMetric.key = key;
    newMetric.name = name;
    newMetric.unit_symbol = unitSymbol;
    newMetric.unit_type = unitType;
    newMetric.value_class = value_class;
    
    // add newly created metric object onto metricList list
    [metricList addMetric:newMetric];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
// create ANMetric object.  will be called to for converting supported metrics from core data
// after creating ANMetric object you may call the methods of ANMetric to add ranges: addNormalRange, addValidRange
// key, name, info - from metric entity attributes
// unitType, unitSymbol - from metric relationships "withUnit"
// value_class - from metric relationship "withType"
+ (ANMetric*) createMetric:(NSString *)key
                      name:(NSString *)name
                      info:(NSString *)info
                      unit:(NSString *)unitSymbol
                  unitType:(int)unitType
               value_class:(MetricClass)value_class
{
    // create brand new metric object
    ANMetric* newMetric = [[ANMetric alloc] init];
    
    newMetric.key = key;
    newMetric.name = name;
    newMetric.unit_symbol = unitSymbol;
    newMetric.unit_type = unitType;
    newMetric.value_class = value_class;
    
    return newMetric;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
// create ANMetricView object.  the same use as ANMetric object
// key - metric key the one from metric entity
// name - metric name this view is created for
// classifier - provides the function of "mapping" given metric value to classification (view)
+(ANMetricView*) createMetricView:(NSString *)key
                             name:(NSString *)name
                       classifier:(ANClassifier*)classifier
{
    // create a view
    ANMetricView* view = [[ANMetricView alloc] init];
    
    view.tipMsg = classifier.classification.info;
    view.fillcolor = classifier.classification.color;
    view.image = classifier.classification.image;
    
    /*
    view.min = min;
    view.max = max;
    */
    
    return view;
}

// load all supported metrics onto given metric list
+(void)loadAllSuopportedMetrics_Annielyticx:(ANMetricList*)metricList
{
    NSString* metricKey;
    
    //1 "TC" metric
    metricKey = ANMETRIC_TC;
    
    // "TC"
    // add metric "TC"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Total Cholesterol"
                       unit:@"mg/dl"
                   unitType:1
                value_class:MetricClass_Measurement];
    // End "TC"
    
    //2 "LDL"
    metricKey = ANMETRIC_LDL;
    // add metric "LDL"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"LDL cholesterol"
                       unit:@"mg/dl"
                   unitType:1
                value_class:MetricClass_Measurement];
    // end LDL
    
    //3 "HDL"
    metricKey = ANMETRIC_HDL;
    // add metric "HDL"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"HDL Cholesterol"
                       unit:@"mg/dl"
                   unitType:1
                value_class:MetricClass_Measurement];
    // end "HDL"
    
    //4 "TRIG"
    metricKey = ANMETRIC_TRIG;
    // add metric "TRIG"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Triglycerides"
                       unit:@"mg/dl"
                   unitType:1
                value_class:MetricClass_Measurement];
    // end "TRIG"
    
    //5 "BMI"
    metricKey = ANMETRIC_BMI;
    // add metric "BMI"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"BMI"
                       unit:@""
                   unitType:1
                value_class:MetricClass_Measurement];
    // end BMI
    
    // 6"ABSI"
    metricKey = ANMETRIC_ABSI;
    // add metric "ABSI"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"ABSI"
                       unit:@""
                   unitType:1
                value_class:MetricClass_Measurement];
    // end ABSI
    
    //7 "BG"
    metricKey = ANMETRIC_BG;
    // add metric "BG"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Blood Glucose"
                       unit:@"mg/dl"
                   unitType:1
                value_class:MetricClass_Measurement];
    // end "BG"
    
    //8 "BP"
    metricKey = ANMETRIC_BP_SYS;
    // add metric "BG"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Blood Pressure"
                       unit:@"mm Hg"
                   unitType:1
                value_class:MetricClass_Measurement];
    
    // end BP
    
    // 9SVD3
    metricKey = ANMETRIC_GHI_BLOODTEST_D3;
    // add metric "SVD3"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Serum Vit D3"
                       unit:@"ng/dl"
                   unitType:1
                value_class:MetricClass_Measurement];
    // end SVD3
    
    //11 HeartYears
    metricKey = ANMETRIC_HEART_YEARS;
    // add metric "HeartYears"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Heart Years"
                       unit:@"years"
                   unitType:1
                value_class:MetricClass_Measurement];
    
    // end HeartYears
    
    // 12CVD
    metricKey = ANMETRIC_CVD_RISK;
    // add metric "CVD"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"CVD"
                       unit:@"%"
                   unitType:1
                value_class:MetricClass_Measurement];
    
    // end CVD
    
    // 13Stroke
    metricKey = ANMETRIC_STROKE_RISK;
    // add metric "Stroke"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Stroke"
                       unit:@"%"
                   unitType:1
                value_class:MetricClass_Measurement];
    // end Stroke
    
    //14 Diabetes
    metricKey = ANMETRIC_DIABETES_RISK;
    // add metric "Diabetes"
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:@"Diabetes"
                       unit:@"%"
                   unitType:1
                value_class:MetricClass_Measurement];
    
    // end Diabetes
    
    ///////////////////////////////////////////////////////////
    // Vitmin D deficincy risk factors
    
    // add metric ANMETRIC_GHI_AGE
    metricKey = ANMETRIC_GHI_AGE;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_AGE
                       unit:UNIT_STRING_YEARS
                   unitType:UNIT_YEARS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_SKIN
    metricKey = ANMETRIC_GHI_SKIN;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_SKIN
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_BODY_FAT
    metricKey = ANMETRIC_GHI_BODY_FAT;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_BODY_FAT
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_ENVIRONMENT
    metricKey = ANMETRIC_GHI_ENVIRONMENT;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_ENVIRONMENT
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_LATITUDE
    metricKey = ANMETRIC_GHI_LATITUDE;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_LATITUDE
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_SUNEXPOSURE
    metricKey = ANMETRIC_GHI_SUNEXPOSURE;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_SUNEXPOSURE
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_SEASON
    metricKey = ANMETRIC_GHI_SEASON;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_SEASON
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_PREGNANCY
    metricKey = ANMETRIC_GHI_PREGNANCY;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_PREGNANCY
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_DIET
    metricKey = ANMETRIC_GHI_DIET;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_DIET
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_DNAGEN
    metricKey = ANMETRIC_GHI_DNAGEN;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_DNAGEN
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_BLOODTEST_D3
    metricKey = ANMETRIC_GHI_BLOODTEST_D3;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_BLOODTEST_D3
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_DISEASE
    metricKey = ANMETRIC_GHI_DISEASE;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_DISEASE
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // add metric ANMETRIC_GHI_MEDICATION
    metricKey = ANMETRIC_GHI_MEDICATION;
    [self addMetricOntoList:metricList
                        key:metricKey
                       name:ANMETRIC_GHI_MEDICATION
                       unit:UNIT_STRING_ABS
                   unitType:UNIT_ABS
                value_class:MetricClass_Classification];
    
    // end of Vitmin D deficincy
}
// end of loading annielytics supported metric and metric view objects

@end
