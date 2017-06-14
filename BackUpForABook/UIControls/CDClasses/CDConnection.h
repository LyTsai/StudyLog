//
//  CDConnection.h
//  ChordGraph
//
//  Created by Hui Wang on 6/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>

// connection to other element (ring index, slice index, cell index)
// used for connection between two cell connectors
// each cell may have array of indexs to CDConnections that "connects" two cells

// define structure for index information of connector end
typedef struct
{
    // ring index
    int ring;
    // slice index
    int slice;
    // cell index
    int cell;
    // connectivity intensity in terms of percentage
    float intensity;
    // gui run time value.
    // start / end angle degrees
    float left;
    float right;
    // true if already painted
    BOOL painted;
}CnnNode;

// connector between two nodes a and b
@interface CDConnection : NSObject

// properties
// node a and b of connector
@property(readwrite, nonatomic)CnnNode a;
@property(nonatomic)id node_a;
@property(readwrite, nonatomic)CnnNode b;
@property(nonatomic)id node_b;
// fonts
// properties
// string drawing attributes for attributed string
// small font for showing tips for groups of highlighted connectors
@property(strong, nonatomic)NSMutableDictionary *attrSmallFont;
// large font for showing tip of highlighted connector
@property(strong, nonatomic)NSMutableDictionary *attrLargeFont;
// lable or connector text details
@property(strong,nonatomic)NSMutableString* label;
// information for visual presentation
@property(strong,nonatomic)UIBezierPath* aPath;
// show as highligthed ?
@property(nonatomic)BOOL highlight;
// show tip ?
@property(nonatomic) BOOL showTip;
// display in large font ?
@property(nonatomic)BOOL largeFont;

// methods

// init with a connection between two nodes
-(id)initWith:(NSString*)lable
       ring_a:(int)ring_a
      slice_a:(int)slice_a
       cell_a:(int)cell_a
  intensity_a:(float)intensity_a
       ring_b:(int)ring_b
      slice_b:(int)slice_b
       cell_b:(int)cell_b
  intensity_b:(float)intensity_b;

// accessing node
-(CnnNode*)getNode:(int)ring
             slice:(int)slice
              cell:(int)cell;

// check if is the connector between two given nodes
-(BOOL)isConnector:(CnnNode)a
                 b:(CnnNode)b;

// call back from CDCell
// set GUI size for the cell node
-(BOOL)setNodeGuiSize:(id)cell
                 left:(float)left
                right:(float)right;

// get intensity of the cell node
-(float)getIntensity:(id)cell;

// set very basic attributes.  other cases please operate on the objects attrSmallFont and attrLargeFont directly
-(void)setSmallFont:(CFStringRef)font
               size:(float)size
              color:(UIColor*)color;
-(void)setLargeFont:(CFStringRef)font
               size:(float)size
              color:(UIColor*)color;

// reset gui view related properties
-(void)invalidate;

// hit test
-(BOOL) hitTest:(CGPoint)pt;

@end
