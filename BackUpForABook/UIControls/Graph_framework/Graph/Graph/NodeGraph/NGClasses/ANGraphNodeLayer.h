//
//  ANGraphNodeLayer.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/31/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "ANLayoutNode.h"
#import "APageLayerPath.h"

// object for holding visual presentation information:
// node - reference to object that has size and location computed
// layer - reference to object that provide visual presentation for this node  
@interface ANGraphNodeLayer : NSObject

// node for data
@property(strong, nonatomic) ANLayoutNode* node;
// CALayer for node presentation
@property(strong, nonatomic) APageLayerPath* layer;

// initalize with node only
-(ANGraphNodeLayer*)initWith:(ANLayoutNode*)node;
// initalize with node and drawing layer
-(ANGraphNodeLayer*)initWith:(ANLayoutNode*)node layer:(APageLayerPath*) layer;
@end

