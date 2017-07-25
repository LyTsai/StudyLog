//
//  ANVisualTypes.h
//  ABook_iPhone
//
//  Created by hui wang on 5/26/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#ifndef ABook_iPhone_ANVisualTypes_h
#define ABook_iPhone_ANVisualTypes_h

// defines annielyticx visual presentation types
typedef enum
{
    ANVISUALTYPE_NA,                            // not defined
    ANVISUALTYPE_QA_CARD_YES_NO_SKIP,           // three buttons
    ANVISUALTYPE_QA_CARD_NORMAL_ABNORMAL_SKIP,  // "normal", "abnormal" and "skip" or "NA" three buttons
    ANVISUALTYPE_QA_CARD_YES_NO,                // two buttons
    ANVISUALTYPE_QA_CARD_NORMAL_ABNORMAL,       // "normal" and "abnormal" two buttons
    ANVISUALTYPE_QA_CARD_VALUE_BAR_DONE_SKIP
}ANVISUALTYPE;

#endif
