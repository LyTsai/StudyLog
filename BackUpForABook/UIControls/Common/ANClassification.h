//
//  ANClassification.h
//  ANBookPad
//
//  Created by hui wang on 8/28/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// class for providing generic classification
// mimic the classification entity defined in core data model
// this class is used for providing visual presentation of attached measurement value stored in table cells
@interface ANClassification : NSObject

// key, name, info, score, color, display name, color and image
// key - created in core data
@property(strong, nonatomic)NSString* key;
@property(strong, nonatomic)NSString* name;
@property(strong, nonatomic)NSString* displayName;
@property(strong, nonatomic)NSString* info;
@property(strong, nonatomic)UIColor *color;
@property(strong, nonatomic)UIImage *image;
// not the original measurement value but an assessement value for further processing.
// in case of tree ring map, the score will be used in tip message
@property float score;
 
@end
