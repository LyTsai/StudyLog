//
//  ANHotSpot.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APageLayerPath.h"

@interface ANHotSpot : NSObject

@property CGPoint center;                       // hot spot location
@property CGSize size;                          // hot spot size (active area)
@property (strong, nonatomic) APageLayerPath* symbol; // loaded symbol at this spot

-(id)initWith:(CGPoint)center
         size:(CGSize)size;

@end
