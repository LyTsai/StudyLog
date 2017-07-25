//
//  TRLabel.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TRShowStyle.h"

// represnts the label style used in the tree ring.  used by TRAxisTick etc 
@interface TRLabel : NSObject

// properties for controlling the font style
// font size information for the label

// font size information for the remainder label
// fontSizeLarge and fontSizeSmall between two ends of row axis
@property(nonatomic)float fontSizeLarge;
@property(nonatomic)float fontSizeSmall;
@property(nonatomic)float fontSize_Remainder; 

// show underline for first letter
@property(nonatomic)BOOL underLine;
// position starting which attrRemainderDictionary attributes will be used
@property(nonatomic)int maxNumberOfFullSizeLetters;
// shadow color
@property(strong, nonatomic)UIColor *blurColor;
// shadow style
@property(nonatomic)CGSize blurSize;
@property(nonatomic)float blurRadius;

// lable string
// full string
@property(nonatomic)NSString *fullString;
// short string in case of limited space
@property(nonatomic) NSString *shortString;
// string drawing attributes for attributed string
@property(strong, nonatomic)NSMutableDictionary *attrDictionary;
// string drawing attributes for the remaining string in case of not enough area for the full string
@property(strong, nonatomic)NSMutableDictionary *attrRemainderDictionary;

// methods
// call to update attributed string to reflect the current font properties
-(void)updateAttributedString;

@end
