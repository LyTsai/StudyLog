//
//  TRMap.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/20/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRMap.h"
#import "TRMLabels.h"

@interface TRMap (PrivateMethods)
// private methods
// preResize
-(void)preResize;

// off screen drawing
- (void)drawRect_Offscreen:(CGRect)rect;

// cached image context for off screen drawing
-(void)initContext:(CGSize)size;

// create image based CGContext
-(CGContextRef)createBitmapContext:(CGSize)size;

// paint background
-(void)paintBackground:(CGContextRef)ctx
                  size:(CGRect)rect;

// resize slice angle size
-(void)setSliceSize:(TRSlice *)slice
          sliceSize:(Slice) sliceSize;

// move slice to new origin
-(void)moveSlice:(TRSlice *)slice
          origin:(CGPoint)origin;

// move slice column slider bar
-(void)moveSliceColumnSliderBar:(TRSlice *)slice
                    barPosition:(float) barPosition;

// move slice row slider bar
-(void)moveSliceRowSliderBar:(TRSlice *)slice
                 barPosition:(float) barPosition;

// object hit test
-(void)hitTest:(CGPoint)hitPt;

@end

@implementation TRMap
{
    @private
    // private properties

    // cached image context
    CGContextRef _cacheContext;

    // touch events related
    // index of object being hitten
    int _idxObj;
    // hit object
    HitObj _hitObj;

    // begin touch point
    CGPoint _ptBegin;
    // end touch point
    CGPoint _ptEnd;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self == nil)
    {
        return nil;
    }
        
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];

    _offscreen = FALSE;
    
    // cached image context
    if (_offscreen == TRUE)
    {
        _cacheContext = [self createBitmapContext:frame.size];
    }else
    {
        _cacheContext = nil;
    }

    _idxObj = -1;
    _hitObj.hitObject = TRObjs_None;

    // lables
    _lables = [[TRMLabels alloc] init];
    
    // notes
    _notes = [[TRMLabels alloc] init];

    // legend
    _legend = [[TRLegend alloc] init];
    
    // date
    _date = [[TRMLabels alloc] init];
    
    // center label
    _centerLabel = [[TRCenterLabel alloc] init];
    
    _fontSize = 1.0;
    _innerSpace = 70.0;
    _outerSpace = 100.0;
    
    _origin.x = _origin.y = 0;
    _min = .0;
    _max = .0;
     
    return self;
}

-(CGContextRef)createBitmapContext:(CGSize)size
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // {r, g, b, alpha}
    bitmapBytesPerRow   = (size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * size.height);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    context = CGBitmapContextCreate (bitmapData,
									 size.width,
									 size.height,
									 8,
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);   // kCGImageAlphaPremultipliedLast
    
    if (context== NULL)
    {
        free (bitmapData);
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

// Only override drawRect: if you perform custom drawing.

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_offscreen == TRUE)
    {
        return [self drawRect_Offscreen:rect];
    }
 
    // regular drawing
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // (1) paint background
    [self paintBackground:ctx size:rect];
    
    if (allSlices.count == 0)
    {
        return ;
    }

    // (2) Draw all slices.
    int i;
    for (i = 0; i < allSlices.count; i++)
    {
        if ([[allSlices objectAtIndex:i] isKindOfClass:[TRSlice class]])
        {
            [[allSlices objectAtIndex:i] Paint:ctx];
        }
    }
 
    // (3) paint labels
    CGPoint pos, ltPosition = _origin;
    
    ltPosition.x = rect.origin.x + 10 * _fontSize;
    ltPosition.y -= _max;
    ltPosition.y = .5 * (rect.origin.y + ltPosition.y);
    
    pos = ltPosition;
    pos = [_lables paint:ctx orderByKeys:_lables.keys alignment:TRMTextAlignment_LT lineSpace:2.0 position:pos];
    
    // (4) paint legend
    CGPoint ltLegendPosition = pos;
    ltLegendPosition.y += 20;
    
    pos = [_legend paint:ctx orderByKeys:nil alignment:TRLegendAlignment_LT lineSpace:2.0 position:ltLegendPosition];
    
    // (5) paint date
    pos = ltPosition;
    pos.x = rect.origin.x + rect.size.width - 10 * _fontSize;
    
    [_date paint:ctx orderByKeys:_date.keys alignment:TRMTextAlignment_RT lineSpace:2.0 position:pos];
    
    // (6) paint note (on the right bottom)
    pos = ltPosition;
    pos.x = rect.origin.x + rect.size.width - 10 * _fontSize;
    pos.y = _origin.y + 80;     // !!! To DO.  Use the position of end of axis
    
    [_notes paint:ctx orderByKeys:_notes.keys alignment:TRMTextAlignment_RT lineSpace:2.0 position:pos];
    
    // (7) paint center label
    [_centerLabel paint:ctx radius:(_min - 10 * _fontSize) origin:_origin];
}

// off screen drawing
- (void)drawRect_Offscreen:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
  
    // draw everythong onto the cached context
    // offscreen drawing
    // (1) paint background
    [self paintBackground:_cacheContext size:rect];
    
    // (2) Draw all slices.
    int i;
    for (i = 0; i < allSlices.count; i++)
    {
        if ([[allSlices objectAtIndex:i] isKindOfClass:[TRSlice class]])
        {
            [[allSlices objectAtIndex:i] Paint:_cacheContext];
        }
    }
    
    // done drawing on cached context
    // get image
    CGImageRef cacheImage = CGBitmapContextCreateImage(_cacheContext);
    // put the image onto current device context
    CGContextDrawImage(ctx, rect, cacheImage);
    
    // done
    CGImageRelease(cacheImage);
}

// touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // hit position
    _ptBegin = [touch locationInView:self];
    
    // object hit test
    [self hitTest:_ptBegin];
    
    // did we hit the axis ?
    TRSlice *hitSlice = nil;
    if (_idxObj >= 0 && (_hitObj.hitObject == TRObjs_Column_Axis || _hitObj.hitObject == TRObjs_Row_Axis))
    {
        // slice object
        hitSlice = [allSlices objectAtIndex:_idxObj];
        
        // Center position
        CGPoint center = hitSlice.origin;
        
        // {angle, radius} point position
        CGFloat r = hypotf(_ptBegin.x - center.x, _ptBegin.y - center.y);
        
        float endAngle = .0;
        endAngle = 180.0 * atan(-(_ptBegin.y - center.y) / (_ptBegin.x - center.x)) / 3.14;
        if ((_ptBegin.x - center.x) < 0)
        {
            endAngle += 180;
        }
        
        if (hitSlice == nil)
        {
            return ;
        }
        
        if (_hitObj.hitObject == TRObjs_Column_Axis)
        {
            // the column bar hit event should be handled inside the slice and ask for update display after
            [self moveSliceColumnSliderBar:hitSlice barPosition:endAngle];
            [self setNeedsDisplay];
        }else if (_hitObj.hitObject == TRObjs_Row_Axis)
        {
            // the row bar hit event should be handled inside the slice and ask for update display after
            [self moveSliceRowSliderBar:hitSlice barPosition:r];
            [self setNeedsDisplay];
        }
     }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _ptEnd = [touch locationInView:self];
    
    if (_idxObj < 0 || _hitObj.hitObject == TRObjs_None)
    {
        return ;
    }
    
    TRSlice *hitSlice = nil;
    
    // walking down the list of supported object types
    if (_hitObj.hitObject == TRObjs_Arrows_Begin ||
        _hitObj.hitObject == TRObjs_Arrows_End ||
        _hitObj.hitObject == TRObjs_ColumnBar ||
        _hitObj.hitObject == TRObjs_RowBar)
    {
        // slice object
        hitSlice = [allSlices objectAtIndex:_idxObj];
        
        if (hitSlice == nil)
        {
            return ;
        }
    
        // Center position
        CGPoint center = hitSlice.origin;
        
        // {angle, radius} point position
        CGFloat r = hypotf(_ptEnd.x - center.x, _ptEnd.y - center.y);
        
        float endAngle = .0;
        endAngle = 180.0 * atan(-(_ptEnd.y - center.y) / (_ptEnd.x - center.x)) / 3.14;
        if ((_ptEnd.x - center.x) < 0)
        {
            endAngle += 180;
        }
        
        Slice size = hitSlice.size;
        
        if (_hitObj.hitObject == TRObjs_Arrows_Begin)
        {
            // change the size of hitted slice first
            size.right = endAngle;
            [self setSliceSize:hitSlice sliceSize:size];
            
            // divider between two slices
            if (_idxObj >= 1)
            {
                hitSlice = [allSlices objectAtIndex:(_idxObj - 1)];
                size = hitSlice.size;
                size.left = endAngle;
                [self setSliceSize:hitSlice sliceSize:size];
            }
            
            [self autoFit];
            [self.layer setNeedsDisplay];
        }else if (_hitObj.hitObject == TRObjs_Arrows_End)
        {
            // change the size of hitted slice first
            size.left = endAngle;
            [self setSliceSize:hitSlice sliceSize:size];
            
            // divider between two slices
            if (_idxObj < ([allSlices count] - 1))
            {
                hitSlice = [allSlices objectAtIndex:(_idxObj + 1)];
                size = hitSlice.size;
                size.right = endAngle;
                [self setSliceSize:hitSlice sliceSize:size];
            }
            
            [self autoFit];
            [self.layer setNeedsDisplay];
        }else if (_hitObj.hitObject == TRObjs_ColumnBar)
        {
            // the column bar hit event should be handled inside the slice and ask for update display after
            [self moveSliceColumnSliderBar:hitSlice barPosition:endAngle];
            [self setNeedsDisplay];
        }else if (_hitObj.hitObject == TRObjs_RowBar)
        {
            // the row bar hit event should be handled inside the slice and ask for update display after
            [self moveSliceRowSliderBar:hitSlice barPosition:r];
            [self setNeedsDisplay];
        }
    }
    
    _ptBegin = _ptEnd;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _hitObj.hitObject = TRObjs_None;
    [self touchesEnded:touches withEvent:event];
}

// hit test walking down the object list. _idxObj will be -1 if hit no object
-(void)hitTest:(CGPoint)hitPt
{
    _idxObj = -1;
    
    // go over object (ring slices) list
    int i;
    for (i = 0; i < allSlices.count; i++)
    {
        if ([[allSlices objectAtIndex:i] isKindOfClass:[TRSlice class]])
        {
            _hitObj = [[allSlices objectAtIndex:i] HitTest:_ptBegin];
            
            if (_hitObj.hitObject != TRObjs_None)
            {
                _idxObj = i;
                _hitObj.sliceIndex = i;
                return ;
            }
        }
    }
}

// compose tree ring map by passing a set of tree slice angle positions.  usually called at initialization phase
-(void)composeTreeRingMap:(NSArray*)slicePositions
{
    if (slicePositions.count <= 1)
    {
        return ;
    }
    
    // clear allSlices first
    if (allSlices == nil)
    {
        allSlices = [[NSMutableArray alloc] init];
    }else
    {
        [allSlices removeAllObjects];
    }
    
    // creates tree slices
    int i;
    float b, e;
    TRSlice *sliceObj = nil;
    Slice sliceSize;
    
    // slice begin angle position
    b = [[slicePositions objectAtIndex:0] floatValue];
    
    for (i = 0; i < (slicePositions.count - 1); i++)
    {
        // slice end angle position
        e = [[slicePositions objectAtIndex:(i + 1)] floatValue];
        
        // create one slice object and add it to allSlices collections
        sliceObj = [[TRSlice alloc] init];
        
        sliceObj.parent = self.layer;
        // slice angle range (b, e)
        sliceSize = sliceObj.size;
        sliceSize.right = b;
        sliceSize.left = e;
        sliceObj.size = sliceSize;
        
        // only slices on left and right most has row lables
        if (i == 0)
        {
            // right most slice
            sliceObj.background.style = BackgroudStyle_Color_Fill;
            sliceObj.rowBarStyle = BarPosition_RB;
            sliceObj.rowLabelOnLeft = FALSE;
            sliceObj.rowLabelOnRight = TRUE;
            sliceObj.leftBorderStyle = SliceBorder_Line;
            sliceObj.rightBorderStyle = SliceBorder_Metal;
        }else if (i == (slicePositions.count - 2))
        {
            // left most slice
            sliceObj.background.style = BackgroudStyle_Color_Fill; //BackgroudStyle_Color_Gradient;
            sliceObj.rowBarStyle = BarPosition_RB; //BarPosition_LT;
            sliceObj.rowLabelOnLeft = TRUE;
            sliceObj.rowLabelOnRight = FALSE;
            sliceObj.leftBorderStyle = SliceBorder_Metal;
            sliceObj.rightBorderStyle = SliceBorder_Line;
        }else
        {
            sliceObj.background.style = BackgroudStyle_Color_Fill;
            sliceObj.rowBarStyle = BarPosition_None;
            sliceObj.rowLabelOnLeft = FALSE;
            sliceObj.rowLabelOnRight = FALSE;
            
            sliceObj.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            sliceObj.leftBorderStyle = SliceBorder_Line;    // SliceBorder_Solid;
            sliceObj.rightBorderStyle = SliceBorder_Line;   // SliceBorder_Solid;
        }
        
        // add it into collection allSlices
        [allSlices addObject:sliceObj];
        
        b = e;
    }
}

// get number of slices
-(int)numberOfSlices
{
    return allSlices.count;
}

// access to ring slice
-(TRSlice*)getSlice:(int)position
{
    if (allSlices == nil || allSlices.count == 0)
    {
        return nil;
    }
    
    return [allSlices objectAtIndex:position];
}

// set visual space for the tree ring map.  make sure the control is set with frame size first
-(void)setTRSize:(CGPoint)origin
             min:(float)min
             max:(float)max
{
    Slice sliceSize;
    TRSlice *oneSlice;
    
    int i;
    for (i = 0; i < allSlices.count; i++)
    {
        if( [[allSlices objectAtIndex:i] isKindOfClass:[TRSlice class]] )
        {
            oneSlice = [allSlices objectAtIndex:i];
            
            sliceSize = oneSlice.size;
            sliceSize.bottom = min;
            sliceSize.top = max;
            
            oneSlice.hostFrame = self.bounds;
            oneSlice.size = sliceSize;
            oneSlice.origin = origin;
        }
    }
    
    // make a note
    _origin = origin;
    _min = min;
    _max = max;
}

// auto resize the tree ring map
-(void)autoResize:(CGRect)size
{
    // set tree ring map size
    // _rmin (70) font point in inner circle area
    float rmin = _innerSpace * _fontSize;
    
    // maximum possible radius
    float rmax = .5 * size.size.width;
    
    // initially at the center location
    CGPoint origin = CGPointMake(size.size.width / 2, size.size.height / 2);
    
    // adjust ring size and position to best fit into given size.
    // adjustments in rmin, rmax and origin
    float d = 0.0;
    if ([self numberOfSlices] >= 1)
    {
        TRSlice* oneSlice = [self getSlice:0];
        if ((oneSlice.size.right < 0.0 || oneSlice.size.right > 180.0) &&
            ABS(sinf(DEGREES_TO_RADIANS(oneSlice.size.right))) > d)
        {
            d = ABS(sinf(DEGREES_TO_RADIANS(oneSlice.size.right)));
        }
        
        oneSlice = [self getSlice:([self numberOfSlices] - 1)];
        if ((oneSlice.size.left < .0 || oneSlice.size.left > 180.0) &&
            ABS(sinf(DEGREES_TO_RADIANS(oneSlice.size.left))) > d)
        {
            d = ABS(sinf(DEGREES_TO_RADIANS(oneSlice.size.left)));
        }
    }else
    {
        d = 1.0;
    }
    
    // adjustment in rmax
    if ((1.0 + d) * rmax > size.size.height)
    {
        rmax = size.size.height / (1.0 + d);
    }
    
    // set origin
    origin.y = size.origin.y + rmax;
    
    // shrink tree ring by _outerSpace (60 font points)
    float dR = _outerSpace * _fontSize;
    
    rmax -= dR;
    origin.y += .5 * dR;
    
    // center position, radius for bottom and top rings
    [self setTRSize:origin min:rmin max:rmax];
    
    // dirty view
    [self onDirtyView];
    
    // sync up slice size
    [self onSize];
}

-(void)autoFit
{
    [self autoResize:self.bounds];
}

// call to make sure tree ring slices are all in sync between view and data set
-(void)onDirtyView
{
    // (1) sync up with each slice components sucn as x and y axis
    for (int i = 0; i < [self numberOfSlices]; i++)
    {
        [[self getSlice:i] onDirtyView];
    }
}

-(void)onSize
{
    for (int i = 0; i < [self numberOfSlices]; i++)
    {
        [[self getSlice:i] onSize];
    }
}

// set slice size
-(void)setSliceSize:(TRSlice *)slice
          sliceSize:(Slice) sliceSize
{
    // hosting frame bound for coordinate conversion
    slice.hostFrame = self.bounds;
    // slice bound
    slice.size = sliceSize;
    [slice onDirtyView];
}

// move slice to new origin
-(void)moveSlice:(TRSlice *)slice
          origin:(CGPoint)origin
{
    slice.origin = origin;
}

// move slice column slider bar
-(void)moveSliceColumnSliderBar:(TRSlice *)slice
                    barPosition:(float) barPosition
{
    [slice setColumnAxisSliderBarPosition:barPosition];
}

// move slice row slider bar
-(void)moveSliceRowSliderBar:(TRSlice *)slice
                 barPosition:(float) barPosition
{
    [slice setRowAxisSliderBarPosition:barPosition];
}

// paint background
-(void)paintBackground:(CGContextRef)ctx
                  size:(CGRect)rect
{
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextFillRect(ctx, rect);
}

@end
