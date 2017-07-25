//
//  ANClassificationList.h
//  ANBookPad
//
//  Created by hui wang on 9/3/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANClassification.h"

// list of classifications supported in the system
@interface ANClassificationList : NSObject

// add classififcation: key - unique key in the system
-(void) addClassification:(NSString*)key
                     name:(NSString*)name
              displayName:(NSString*)displayName
                     info:(NSString*)info
                    color:(UIColor*)color
                    image:(UIImage*)image
                    score:(CGFloat)score;

// access the classififcation for specified calssification key
-(ANClassification*) classificationOf: (NSString*) key;
// get all supoorted keys
-(NSArray*) allClassifications;

// create sample for test purpose
+(ANClassificationList*) createSampleClassificationList;

@end
