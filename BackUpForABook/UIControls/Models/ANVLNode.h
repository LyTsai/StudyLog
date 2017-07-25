//
//  ANVLNode.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "ANVLMetric.h"
#import "ANVLTypes.h"

// define KV pair collection object class
@interface ANKVM : NSObject<AVLObj>
@property(strong, nonatomic)NSMutableDictionary* kvm;
@end

// define general purpose node object class
@interface ANVLNode : NSObject<AVLObj>

// tree format representation of data.  !!! one of the node format is tree format where each node may have several children in _nodes plus its own parent.  in this format each node may also have its own content with specific format stored in obj

@property(readonly) NODECLASS type;

// information hold inside this node

// metric data in for of key-value pair where metricKey is the metric name such as ANMETRIC_VTD_RISK_AGE
@property(strong, nonatomic)ANVLMetric* metric;

// node content object reference.  object structure depends on NODECLASS type
@property(strong, nonatomic)NSObject<AVLObj>* obj;

// string info of this metric
@property(strong, nonatomic)NSString* info;
// time stamp (if valid)
@property(strong, nonatomic)NSDate* time;

// link to parent
@property(strong, nonatomic)ANVLNode* parent;

// methods
-(id)initWith:(NODECLASS)type
         info:(NSString*)info
       metric:(ANVLMetric*)metric
         time:(NSDate*) time;

-(id)initWith:(NODECLASS)type
         info:(NSString*)info
          obj:(NSObject<AVLObj>*) obj
       metric:(ANVLMetric*)metric
         time:(NSDate*) time;

// add km pairs into obj content
-(void)addContentObject:(NSString*) key
                    val:(NSObject*) val;

// read value for given key out of km pair
-(id)getContentObject:(NSString*) key;

// get all childern nodes as content of this node
-(NSArray*)subNodes;
// add sub node
-(void)addNode:(ANVLNode*)node;
// remove sub  node
-(void)removeNode:(ANVLNode*)node;
// disconnect from parent
-(void)removeFromParent;

// getting the dimension of current tree node

// length of longest branch
-(NSInteger) depth;
// total number of nodes for given depth
-(NSInteger) size:(NSInteger) branch;

@end
