//
//  ANVLNode.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLNode.h"

// ANKVM
@implementation ANKVM

-(instancetype)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    _kvm = [[NSMutableDictionary alloc] init];
    
    return self;
}

// class key identifying this object class
-(NSString*)getKey
{
    return @"ANKVM";
}
// match to this object?
-(bool)match:(NSString*)key
{
    return [key isEqualToString:[self getKey]];
}

@end

// ANVLNode
@implementation ANVLNode
{
    @private
    
    // node children hold inside this node
    NSMutableArray* _nodes;
}

-(id)init
{
    if (self == nil)
    {
        self = [super init];
    }

    _type = NODECLASS_GENERAL;
    _info = nil;
    _metric = nil;
    _obj = nil;
    _time = nil;
    
    return self;
}

-(id)initWith:(NODECLASS)type
         info:(NSString*)info
       metric:(ANVLMetric*)metric
         time:(NSDate*) time
{
    if (self == nil)
    {
        self = [super init];
    }
    
    _type = type;
    _info = info;
    _obj = [[ANKVM alloc] init];
    _metric = metric;
    _time = time;
    
    _parent = nil;
    
    return self;
}

-(id)initWith:(NODECLASS)type
         info:(NSString*)info
          obj:(NSObject<AVLObj>*) obj
       metric:(ANVLMetric*)metric
         time:(NSDate*) time
{
    if (self == nil)
    {
        self = [super init];
    }
    
    _type = type;
    _info = info;
    _obj = obj;
    _metric = metric;
    _time = time;
    
    _parent = nil;
    
    return self;
}

// add km pairs into obj content
-(void)addContentObject:(NSString*) key
                    val:(NSObject*) val
{
    if (_obj != nil && [_obj isKindOfClass:[ANKVM class]])
    {
        [((ANKVM*)_obj).kvm setObject:val forKey:key];
    }
}

// read value for given key out of km pair
-(id)getContentObject:(NSString*) key
{
    if (self.obj == nil || [self.obj isKindOfClass:[ANKVM class]] == FALSE)
    {
        return nil;
    }
    
    return [((ANKVM*)_obj).kvm objectForKey:key];
}

// class key identifying this object class
-(NSString*)getKey
{
    return @"ANVLNode";
}
// match to this object?
-(bool)match:(NSString*)key
{
    return TRUE;
}

// get all childern nodes
-(NSArray*)subNodes
{
    return _nodes;
}

// add sub node
-(void)addNode:(ANVLNode*)node
{
    if (node == nil)
    {
        return ;
    }
    
    if (_nodes == nil)
    {
        _nodes = [[NSMutableArray alloc] init];
    }
    
    // remove node from its parent
    [node removeFromParent];
    
    // add into cuurent node collection
    [_nodes addObject:node];
    
    // set parent
    node.parent = self;
}

// remove sub  node
-(void)removeNode:(ANVLNode*)node
{
    if (node == nil || _nodes == nil)
    {
        return ;
    }
    
    [_nodes removeObject:node];
}

// disconnect from parent
-(void)removeFromParent
{
    if (_parent == nil)
    {
        return ;
    }
    
    [_parent removeNode:self];
    _parent = nil;
}

// getting the dimension of current tree node
// length of longest branch
-(NSInteger) depth
{
    NSInteger n = 1;
    
    if (_nodes == nil)
    {
        return n;
    }
    
    for (id obj in _nodes)
    {
        if ([obj isKindOfClass:[ANVLNode class]] == FALSE)
        {
            continue;
        }
        
        n += [(ANVLNode*)obj depth];
    }
    
    return n;
}

// total number of nodes for given depth
-(NSInteger) size:(NSInteger) branch
{
    if (branch == 0)
    {
        return _nodes.count;
    }
 
    NSInteger n = 0;
    
    for (id obj in _nodes)
    {
        if ([obj isKindOfClass:[ANVLNode class]] == FALSE)
        {
            continue;
        }
        
        n += [(ANVLNode*)obj size:(branch - 1)];
    }

    return n;
}

@end
