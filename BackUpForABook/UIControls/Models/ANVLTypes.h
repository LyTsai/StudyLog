//
//  ANVLTypes.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#ifndef AnnieVisualyticsPageView_ANVLTypes_h
#define AnnieVisualyticsPageView_ANVLTypes_h

// data types (or format) represented by this node
typedef enum
{
    NODECLASS_GENERAL,                      // general purpose meaning only used as collection.  set to this type if you want to use it as generic node tree
    
    // ANVL class object.  set to this type if node is to hold object reference
    NODECLASS_ANVL_OBJECT_BEGIN,            // ANVL class object
    NODECLASS_ANVL_OBJECT_PRESENTATION,     // presentation type class.  node.obj holds object of ANVLPresentation class type
    
    NODECLASS_ANVL_OBJECT_VMGRAPH_ROOT,     // visual map graph node
    NODECLASS_ANVL_OBJECT_VMGRAPH_NODE,     // visual graph node
    
    NODECLASS_ANVL_OBJECT_END,
    
    NODECLASS_RISK,                         // risk node with sub node as risk factors
    
    // used as metric only
    NODECLASS_METRIC,                       // represents a metric
    NODECLASS_METRIC_ARRAY,                 // array of instance of same metric that can be sorted by given critiria.
    NODECLASS_METRICS_SAMPLE,               // node.obj is NSDictionary for collection of answers or values for each metric in the sub node list
    NODECLASS_QUESTIONNIER,                 // node1 - user info and node.obj is of NODECLASS_METRICS_SAMPLE.  node2 - author info and node3 - NODECLASS_METRICS_SAMPLE
    
    // as time series
    NODECLASS_TIME_SERIES_UNIFORM,          // regular time series data set
    NODECLASS_TIME_SERIES_SPARSE,           // irregular time series data set
    
    // as user information
    NODECLASS_USERINFO,                     // user information.  node.obj is NSDictionary of kv user infor
    // as address
    NODECLASS_ADDRESS,                      // address.  node.obj is NSDictionary
    
    // as metric collection:
    // physical
    NODECLASS_PHYSICAL_BEGIN,               // physical conditions
    NODECLASS_LABTEST_BLOOD,                // blood test
    NODECLASS_LABTEST_PHYSICAL,             // physical test
    NODECLASS_PHYSICAL_END,
    // years
    NODECLASS_ANNIELYTICS_BEGIN,
    NODECLASS_ANNIELYTICS_YEARS,            // anlaytics derived years
    NODECLASS_ANNIELYTICS_RISKS,            // anlaytics derived diseas risks
    NODECLASS_ANNIELYTICS_END,
    // condition
    NODECLASS_CONDITION_BEGIN,
    
    NODECLASS_CONDITION_END,
    
    NODECLASS_LABTEST_LIFESTYLE_BEGIN,      // life style
    
    NODECLASS_LABTEST_LIFESTYLE_END,
    // end of metric types
    
    // ABook metric user risk factor input card collection
    NODECLASS_ABOOK_BEGIN,
    NODECLASS_ABOOK_CARD,                   // card of one metric
    NODECLASS_ABOOK_CARDS,                  // collection of metric cards.  (all cards are kept in _nodes)
    NODECLASS_ABOOK_INFO,                   // showing information and holds source of information details only
    NODECLASS_ABOOK_AGING,                  // "aging" as detailed in "ABookMetricsScoresCollection.h"
    NODECLASS_ABOOK_SCORE,                  // risk score, represents risk calculator.  the key mapped to metric class group is stored in ANVLATTRI_STRING
    NODECLASS_ABOOK_SCORES,                 // collection of scores, _nodes is collection of NODECLASS_ABOOK_SCORE
    
    // ABook visual map for navigation, presenting and selecting user card / score
    NODECLASS_ABOOK_CARD_SCOREBOARD,
    NODECLASS_ABOOK_END,
    
    // user defined types
    NODECLASS_USER,
    NODECLASS_USER_SAMPLE_BOOK1,            // sample node collecton for test purpose
    
    NODECLASS_END
    
}NODECLASS;

#endif
