//
//  TRAxisTick.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/25/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRLabel.h"

// representing axis tick object that has information includs visual presentation and string etc
@interface TRAxisTick : NSObject

// properties
// row or column index of TRSliceGrid this tick is associated with
@property(nonatomic) NSInteger gridIndex;
// view coordinate position for this tick view location.  this is the tick position along the axis direction
@property(nonatomic)float viewOffset;
// tick offset away from axis (vertical direction).  computed from _spaceBetweenAxisAndLable at axis level
@property(nonatomic)float viewSpace;
// label drawing style such as: font, size, color, glowing and orientation etc
@property(nonatomic) TRLabel *label;

-(id)initWith:(NSInteger)seriesID
 viewPosition:(float)viewOffset
        space:(float)viewSpace;

@end
