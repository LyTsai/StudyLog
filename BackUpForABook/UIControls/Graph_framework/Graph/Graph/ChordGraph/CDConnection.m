//
//  CDConnection.m
//  ChordGraph
//
//  Created by Hui Wang on 6/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDConnection.h"
#import "CDCell.h"

@implementation CDConnection

-(id)initWith:(NSString*)lable
       ring_a:(int)ring_a
      slice_a:(int)slice_a
       cell_a:(int)cell_a
  intensity_a:(float)intensity_a
       ring_b:(int)ring_b
      slice_b:(int)slice_b
       cell_b:(int)cell_b
  intensity_b:(float)intensity_b
{
    self = [super init];
    
    _a.ring = ring_a;
    _a.slice = slice_a;
    _a.cell = cell_a;
    _a.intensity = intensity_a;

    _b.ring = ring_b;
    _b.slice = slice_b;
    _b.cell = cell_b;
    _b.intensity = intensity_b;
    
    
    _attrSmallFont = [NSMutableDictionary dictionary];
    _attrLargeFont = [NSMutableDictionary dictionary];
    
    [self setSmallFont:CFSTR("Helvetica") size:10 color:[UIColor darkTextColor]];
    [self setLargeFont:CFSTR("Helvetica") size:12 color:[UIColor darkTextColor]];
    
    _label = [[NSMutableString alloc] initWithString:lable];
    _aPath = [[UIBezierPath alloc] init];
    _highlight = FALSE;
    _showTip = TRUE;
    _largeFont = FALSE;
    
    return self;
}

// accessing node
-(CnnNode*)getNode:(int)ring
             slice:(int)slice
              cell:(int)cell
{
    if (_a.ring == ring &&
        _a.slice == slice &&
        _a.cell == cell)
    {
        return &(_a);
    }else if (_b.ring == ring &&
              _b.slice == slice &&
              _b.cell == cell)
    {
        return &(_b);
    }else
    {
        return nil;
    }
}

// check if is the connector between two given nodes
-(BOOL)isConnector:(CnnNode)a
                 b:(CnnNode)b
{
    if ([self getNode:a.ring slice:a.slice cell:a.cell] == nil)
    {
        return FALSE;
    }
    
    if ([self getNode:b.ring slice:b.slice cell:b.cell] == nil)
    {
        return FALSE;
    }
    return TRUE;
}

// call back from CDCell
-(BOOL)setNodeGuiSize:(id)cell
                 left:(float)left
                right:(float)right
{
    if ([cell isKindOfClass:[CDCell class]] != TRUE)
    {
        return FALSE;
    }
    
    if ([cell isEqual:_node_a] == TRUE)
    {
        _a.left = left;
        _a.right = right;
    }else if ([cell isEqual:_node_b] == TRUE)
    {
        _b.left = left;
        _b.right = right;
    }
        
    return TRUE;
}

// get intensity of the cell node
-(float)getIntensity:(id)cell
{
    if ([cell isKindOfClass:[CDCell class]] != TRUE)
    {
        return .0;
    }
    
    if ([cell isEqual:_node_a] == TRUE)
    {
        return _a.intensity;
    }else if ([cell isEqual:_node_b] == TRUE)
    {
        return _b.intensity;
    }
    
    return .0;
}

// set very basic attributes.  other cases please operate on the objects attrSmallFont and attrLargeFont directly
-(void)setSmallFont:(CFStringRef)font
               size:(float)size
              color:(UIColor*)color
{
    if (_attrSmallFont == nil)
    {
        _attrSmallFont = [NSMutableDictionary dictionary];
    }
    
    CTFontRef lbFont = CTFontCreateWithName(font, size, NULL);
    _attrSmallFont[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    _attrSmallFont[NSForegroundColorAttributeName] = (id)[color CGColor];
}

-(void)setLargeFont:(CFStringRef)font
               size:(float)size
              color:(UIColor*)color
{
    if (_attrLargeFont == nil)
    {
        _attrLargeFont = [NSMutableDictionary dictionary];
    }
    
    CTFontRef lbFont = CTFontCreateWithName(font, size, NULL);
    _attrLargeFont[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    _attrLargeFont[NSForegroundColorAttributeName] = (id)[color CGColor];
}

// reset gui view related properties
-(void)invalidate
{
    _a.painted = FALSE;
    _b.painted = FALSE;
}

// hit test
-(BOOL)hitTest:(CGPoint)pt
{
    return [_aPath containsPoint:pt];
}

@end
