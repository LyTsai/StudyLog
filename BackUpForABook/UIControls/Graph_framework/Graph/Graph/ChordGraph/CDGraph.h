//
//  CDGraph.h
//  ChordGraph
//
//  Created by Hui Wang on 6/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDRing.h"
#import "CDConnection.h"
#import "CDAxisRing.h"
#import "CDTitleRing.h"
#import "CDTip.h"
#import "ANBezierText.h"
#import "CDEdge.h"
#import "Define.h"

// chord graph is made of collection rings, ribbon connections
@interface CDGraph : UIControl{
    // title ring
    CDTitleRing *title;
    // edge ring
    CDEdge *edge;
    // axis ring
    CDAxisRing *axis;
    // collection of data CDRing
    NSMutableArray *rings;
    // collection of CDConnection that has all defined connection nodes among rings collection
    NSMutableSet *connectors;
    // connector tip messages
    // draw text onto Beizier path
    ANBezierText* bezierText;
    // chord graph tip message
    // tip message
    CDTip *tipMsg;
    
    // archor slice (ring, slice).  means to center this slice to 90 degree position
    // archor ring to distribute the slice sizes
    int archor_ring;
    // archor slice to be centered at 90 degree
    int archor_slice;
    // run time data
    NSMutableArray *ringPositions;
}

// properties
// rect size of root frame for coordinate system adjustment (left, bottom) => (left, top)
// visual space information
@property(nonatomic)CGRect hostFrame;
// chord graph origin position
@property(nonatomic)CGPoint origin;
// chord graph size (0, radius) range.  !!! this value is in device unit not font size
@property(nonatomic)float radius;

// show ring (title) text
@property(nonatomic)BOOL showText;
//show axis
@property(nonatomic)BOOL showAxis;

// title object
@property(strong, nonatomic)CDTitleRing *title;
// edge object
@property(strong, nonatomic)CDEdge *edge;
// axis ring
@property(strong, nonatomic)CDAxisRing *axis;
// tip message
// connector tip message
@property(strong, nonatomic) ANBezierText* bezierText;
// chord graph tip message
@property(strong, nonatomic) CDTip* tipMsg;

// methods

// access ring objects
// add one ring
-(CDRing*)addRing;
// number of rings
-(int)numberOfRings;
// access ring at given position
-(CDRing*)getRing:(int)position;
// remove all ring
-(void)removeAllRings;

// aceess ring cell
-(CDCell*)cell:(int)ring
         slice:(int)slice
          cell:(int)cell;

// access cell connectors
-(int)numberOfConnectors;
-(CDConnection*)connectorOf:(void*)obj;
// add connection between two cells. return CDConnection* connection object
-(id)connectCells:(NSString*)lable
           ring_a:(int)ring_a
          slice_a:(int)slice_a
           cell_a:(int)cell_a
      intensity_a:(float)intensity_a
           ring_b:(int)ring_b
          slice_b:(int)slice_b
           cell_b:(int)cell_b
      intensity_b:(float)intensity_b;
// remove connection
-(void)removeConnection:(CnnNode)a
                      b:(CnnNode)b;

// set archor ring / slice that is going to be center at 90 degree position
-(void)setArchorSlice:(int)ring
                slice:(int)slice;

// "rotate" the graph left or right by one slice
-(void)rotate:(BOOL)left;

// set size of chord graph
// !!! caller needs to decide when to call onDirtyView to make sure the view and data in sync
// version that use font size.
// radius - in font size
-(void)setCDSize:(CGPoint)origin
          radius:(float)radius;

// paint the graph
-(void)paint:(CGContextRef)ctx;

// call to make sure gui layout are all in sync between view and data set
-(void)onDirtyView;

// add two test ring data set for test purpose
-(void)createTestData;

@end
