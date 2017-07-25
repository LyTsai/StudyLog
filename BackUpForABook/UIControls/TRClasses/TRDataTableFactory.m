//
//  TRDataTableFactory.m
//  ATreeRingMap
//
//  Created by hui wang on 12/25/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRDataTableFactory.h" 
#import "TRNode.h"

@implementation TRDataTableFactory

-(id)init
{
    self = [super init];
    
    return self;
}

//////////////////////////////////////////////////////////////////////////////////
// create table object using new format
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// create game of scores slices
// x - name / phtos
// y - low Vt D risk factors
//////////////////////////////////////////////////////////////////////////////
// risk factor (metric) string names:
#define AGE             @"Age"
#define SKIN            @"Skin Color"
#define BODYFAT         @"Body Fat"
#define Environment     @"Environment"
#define Latitude        @"Latitude"
#define SUNExposure     @"Sun Exposure"
#define Season          @"Season"
#define Pregnancy       @"Pregnancy"
#define Diet            @"Diet Pattern"
#define DNA             @"DNA"
#define VITD            @"Vit D3 level"
#define Diseaases       @"Diseases"
#define Medications     @"Medications"

-(void)loadSampleMetricValueTable_LowVtD_GameOfScore_StaticFactors:(TRMetricDataTable*)table
{
    if (table == nil)
    {
        return ;
    }
    
    // (2) all columns in the table
    NSMutableArray* columnKeys = [[NSMutableArray alloc] init];
    
    [columnKeys addObject:AGE];
    [columnKeys addObject:SKIN];
    [columnKeys addObject:Environment];
    [columnKeys addObject:Latitude];
    [columnKeys addObject:Season];
    [columnKeys addObject:Pregnancy];
    [columnKeys addObject:DNA];
    [columnKeys addObject:Diseaases];
    [columnKeys addObject:Medications];
    
    // (3) create the table columns
    [table createTableColumnKeys:columnKeys];
    
    // (4) create and feed table ANDataTableCell objects
    
    int viewSize = 20;
    
    // in this version we first create a row of data before adding into table
    // add row of metric measurements
    NSDictionary* oneRow = [[NSMutableDictionary alloc] init];
    
    // john
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    [table addRow:@"John" cells:oneRow];
    
    viewSize = 30;
    
    // Susan
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    
    [table addRow:@"Susan" cells:oneRow];
    
    // David
    viewSize = 25;
   
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    
    [table addRow:@"David" cells:oneRow];
    
    // Jennifer
    viewSize = 20;
    
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    
    [table addRow:@"Jennifer" cells:oneRow];
 
    // linda
    viewSize = 20;
    
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    
    [table addRow:@"Linda" cells:oneRow];
    
    // Mark
    viewSize = 20;
    
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    
    [table addRow:@"Mark" cells:oneRow];
    
    // Susan
    viewSize = 38;
    
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    [table addRow:@"Susan" cells:oneRow];
    
    // Jacson
    viewSize = 20;
    
    oneRow = [[NSMutableDictionary alloc] init];
    
    // AGE
    [oneRow setValue:[ANDataTableCell createWith:AGE
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Young"] forKey:AGE];
    // SKIN
    [oneRow setValue:[ANDataTableCell createWith:SKIN
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Dark"] forKey:SKIN];
    // Environment
    [oneRow setValue:[ANDataTableCell createWith:Environment
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"Mixture"] forKey:Environment];
    // Latitude
    [oneRow setValue:[ANDataTableCell createWith:Latitude
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face5.png"]
                                        viewSize:viewSize
                                             tip:@"Pollution"] forKey:Latitude];
    // Season
    [oneRow setValue:[ANDataTableCell createWith:Season
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"Summer"] forKey:Season];
    // Pregnancy
    [oneRow setValue:[ANDataTableCell createWith:Pregnancy
                                          symbol:@""
                                           value:2
                                           image:[UIImage imageNamed:@"face2.png"]
                                        viewSize:viewSize
                                             tip:@"Pregnant"] forKey:Pregnancy];
    // DNA
    [oneRow setValue:[ANDataTableCell createWith:DNA
                                          symbol:@""
                                           value:1
                                           image:[UIImage imageNamed:@"face3.png"]
                                        viewSize:viewSize
                                             tip:@"DNA"] forKey:DNA];
    // Diseaases
    [oneRow setValue:[ANDataTableCell createWith:Diseaases
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Diseaases];
    // Medications
    [oneRow setValue:[ANDataTableCell createWith:Medications
                                          symbol:@""
                                           value:0
                                           image:[UIImage imageNamed:@"face1.png"]
                                        viewSize:viewSize
                                             tip:@"None"] forKey:Medications];
    [table addRow:@"Jacson" cells:oneRow];
}

// game of scores slice of risk factors static / under control
-(TRMetricDataTable*)createLowVitDGameOfScoresTable_Static
{
    // (1) create a TRMetricDataTable table object
    TRMetricDataTable* table = [[TRMetricDataTable alloc] initWithTitle:@"-- Low Vitmin D Static Risk Factors -- "];
    
    // (2) load sample metric data set into table
    [self loadSampleMetricValueTable_LowVtD_GameOfScore_StaticFactors:table];
    
    return table;

}

-(TRMetricDataTable*)createLowVitDGameOfScoresTable_Dynamic
{
    // (1) create a TRMetricDataTable table object
    TRMetricDataTable* table = [[TRMetricDataTable alloc] initWithTitle:@"-- Controllable Risk Factors-- "];
    
    // (2) load sample metric data set into table
    [self loadSampleMetricValueTable_LowVtD_GameOfScore_StaticFactors:table];
    
    return table;
}

@end
