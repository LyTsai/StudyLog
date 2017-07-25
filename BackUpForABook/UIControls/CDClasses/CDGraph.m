//
//  CDGraph.m
//  ChordGraph
//
//  Created by Hui Wang on 6/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDGraph.h"
#import <CoreText/CoreText.h>

@interface CDGraph (PrivateMethods)

// get size defined in font unit
-(CGRect)size:(float)fontSize;
// reset ring slice angle positions
-(void)setSliceAnglePositions;
// reset ring radius positions
-(void)setRingPositions;

// paint background
-(void)paintBackground:(CGContextRef)ctx
                  size:(CGRect)rect;
// paint title
-(void)paintTitle:(CGContextRef)ctx
           radius:(float)radius
           center:(CGPoint)origin
      frameHeight:(int)height;
// paint edge
-(void)paintEdge:(CGContextRef)ctx
          radius:(float)radius
          center:(CGPoint)origin
     frameHeight:(int)height;
// paint axis
-(void)paintAxis:(CGContextRef)ctx
          radius:(float)radius
          center:(CGPoint)origin
     frameHeight:(int)height;
// paint rings
-(void)paintRings:(CGContextRef)ctx
           center:(CGPoint)origin
      frameHeight:(int)height;

// paint connectors
-(void)paintConnections:(CGContextRef)ctx
                 center:(CGPoint)origin
            frameHeight:(int)height;
// paint one connection
-(void)paintConnection:(CGContextRef)ctx
            connection:(CDConnection*)connection
                center:(CGPoint)origin
           frameHeight:(int)height;

// paint connector messages for all highlighted connectors
-(void)paintHighlightedConnectionTips:(CGContextRef)ctx
                               center:(CGPoint)origin
                          frameHeight:(int)height;
// paint connector message along connector path
-(void)paintConnectionTip:(CGContextRef)ctx
               connection:(CDConnection*)connection
                   center:(CGPoint)origin
              frameHeight:(int)height;

// paint tip message at the center
-(void)paintTipMessage:(CGContextRef)ctx
                center:(CGPoint)origin
           frameHeight:(int)height;

// set connector ribbon path
-(void)setConnectorRibbonPath:(CDConnection*)connection
                     radius_a:(float)radius_a
                      start_a:(float)start_a
                        end_a:(float)end_a
                     radius_b:(float)radius_b
                      start_b:(float)start_b
                        end_b:(float)end_b
                       center:(CGPoint)origin;
// set up all child component size based on given unit font size
-(void)translateChildernFontSize:(float)pointsPerFontSize;

// object hit test
-(void)hitTest:(CGPoint)hitPt;

// highlight cell connectors.
// all cells on the graph
-(void)setGraphConnectorState:(BOOL)highlight;
// all cells of given ring
-(void)setRingConnectorState:(int)ring
                   highlight:(BOOL)highlight;
// all cells of slice
-(void)setSliceConnectorState:(int)slice
                    highlight:(BOOL)highlight;
// all cells of given (ring, slice)
-(void)setRingSliceConnectorState:(int)ring
                            slice:(int)slice
                        highlight:(BOOL)highlight;
// cell of (ring, slice, cell)
-(void)setCellConnectorState:(int)ring
                       slice:(int)slice
                        cell:(int)cell
                    highlight:(BOOL)highlight;

// highlight connector
-(void)setConnectorState:(void*)cnnID
               highlight:(BOOL)highlight;

@end

@implementation CDGraph

@synthesize tipMsg, bezierText, title, edge, axis;

// private data
// device points of one font unit size
float _oneUnitSize;
// position for title ring
float _titleRadiusPosition;
// position for edge ring
float _edgeRadiusPosition;
// position for axis ring
float _axisRadiusPosition;

// hit object
HitCDObj _hitObj;

// touch events
// begin touch point
CGPoint _ptBegin;
// end touch point
CGPoint _ptEnd;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _showText = TRUE;
        title = [[CDTitleRing alloc] init];
        edge = [[CDEdge alloc] init];
        axis = [[CDAxisRing alloc] init];
        
        // tip
        tipMsg = [[CDTip alloc] init];
        
        rings = [[NSMutableArray alloc] initWithCapacity:10];
        connectors = [[NSMutableSet alloc] init];
        ringPositions = [[NSMutableArray alloc] init];
        
        archor_ring = 0;
        archor_slice = 0;
        
        // inital size
        _radius = MIN(frame.size.height, frame.size.width) - 100;
        
        // object for drawing text along beziepath
        bezierText = [[ANBezierText alloc] init];
        
        // dynamic values
        _oneUnitSize = 1;
        _titleRadiusPosition = 0.0;
        _edgeRadiusPosition = .0;
        _axisRadiusPosition = .0;
    }
    return self;
}

// add one ring
-(CDRing*)addRing
{
    CDRing *ring = [[CDRing alloc] init];
    
    if (rings == nil)
    {
        rings = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    [rings addObject:ring];
    
    return ring;
}

// number of rings
-(int)numberOfRings
{
    return rings.count;
}

// access ring at given position
-(CDRing*)getRing:(int)position
{
    if (rings == nil || position >= rings.count)
    {
        return nil;
    }
    
    return [rings objectAtIndex:position];
}

// remove all ring, connection objects
-(void)removeAllRings
{
    [rings removeAllObjects];
    [connectors removeAllObjects];
}

// aceess to cell
-(CDCell*)cell:(int)ring
         slice:(int)slice
          cell:(int)cell
{
    if (rings == nil)
    {
        return nil;
    }
    
    if ([rings objectAtIndex:ring] == nil)
    {
        return nil;
    }
    
    if ([[rings objectAtIndex:ring] getSlice:slice] == nil)
    {
        return nil;
    }
    
    if (cell >= [[rings objectAtIndex:ring] getSlice:slice].cells.count)
    {
        return nil;
    }
    
    return [[[rings objectAtIndex:ring] getSlice:slice].cells objectAtIndex:cell];
}

-(int)numberOfConnectors
{
    return connectors.count;
}

-(CDConnection*)connectorOf:(void*)obj
{
    return [connectors member:(__bridge id)(obj)];
}

// add connection between two cells.  return CDConnection*
-(id)connectCells:(NSString*)lable
           ring_a:(int)ring_a
          slice_a:(int)slice_a
           cell_a:(int)cell_a
      intensity_a:(float)intensity_a
           ring_b:(int)ring_b
          slice_b:(int)slice_b
           cell_b:(int)cell_b
      intensity_b:(float)intensity_b
{
    CDCell* a = [self cell:ring_a slice:slice_a cell:cell_a];
    CDCell* b = [self cell:ring_b slice:slice_b cell:cell_b];
    
    if (a == nil || b == nil)
    {
        return nil;
    }
    
    CDConnection *cnn = [[CDConnection alloc] initWith:lable ring_a:ring_a slice_a:slice_a cell_a:cell_a intensity_a:intensity_a ring_b:ring_b slice_b:slice_b cell_b:cell_b intensity_b:intensity_b];
    cnn.node_a = a;
    cnn.node_b = b;
    
    [connectors addObject:cnn];
    
    // add cnn into cell connectors of a and b
    if (a.connectorIDs == nil)
    {
        a.connectorIDs = [[NSMutableArray alloc] init];
    }
    
    if (b.connectorIDs == nil)
    {
        b.connectorIDs = [[NSMutableArray alloc] init];
    }
    
    [a.connectorIDs addObject:cnn];
    [b.connectorIDs addObject:cnn];
    
    return cnn;
}

// remove connection
-(void)removeConnection:(CnnNode)a
                      b:(CnnNode)b
{
    // find connector that connects a and b
    id obj = nil;
    bool found = false;
    for (obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue;
        }
        
        // is connector between a and b?
        if([obj isConnector:a b:b] == TRUE)
        {
            found = true;
            break;
        }
    }
    
    if (found != true)
    {
        return ;
    }
    
    // disconnect from a
    if ([self cell:a.ring slice:a.slice cell:a.cell] != nil)
    {
        [[self cell:a.ring slice:a.slice cell:a.cell] removeConnector:obj];
    }
    
    // disconnect from b
    if ([self cell:b.ring slice:b.slice cell:b.cell] != nil)
    {
        [[self cell:b.ring slice:b.slice cell:b.cell] removeConnector:obj];
    }
    
    // remove from connectors
    [connectors removeObject:obj];
}

// add two ring for test purpose
-(void)createTestData
{
    [self removeAllRings];
    
    // connector tip
    bezierText.alignment = CurveTextAlignment_Center;
    
    // general tip message in the center
    tipMsg.showTip = FALSE;
    
    // ring title string style
    title.style = RingTextStyle_Ori_Circle | RingTextStyle_AlignMiddle;
    
    // !!! add one ring
    CDRing* newRing = [self addRing];
    
    // !!! all rings have the same number of slices
    //  create 3 slices
    [newRing createSlices:3];
    
    // first ring is palce in the out most ring position
    newRing.showTop = TRUE;
    newRing.topEdgeColor = [UIColor darkGrayColor];
    newRing.showBottom = TRUE;
    newRing.bottomEdgeColor = [UIColor lightGrayColor];
    
    // attributed symbol string
    NSMutableDictionary* textAttributes = [NSMutableDictionary dictionary];
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica"), newRing.size - 4, NULL);
    textAttributes[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    BackgroudStyle cellBackgroundStyle = BackgroudStyle_Color_Gradient;  // BackgroudStyle_Color_Fill;
    HighLightStyle cellHighLightStyle = HighLightStyle_Fill;             // HighLightStyle_Gradient
    
    int i, nCells = 10;
    // first slice
    CDRingSlice* riskFactors = [newRing getSlice:0];
    riskFactors.label = [[NSMutableString alloc] initWithString:@"Risk Factors"];
    riskFactors.backgropund.bkgColor = [UIColor colorWithRed:.8 green:.2 blue:0 alpha:.2];
    riskFactors.backgropund.edgeColor = [UIColor colorWithRed:.8 green:.2 blue:0 alpha:.4];
    
    [riskFactors createCells:nCells];
    for (i = 0; i < nCells; i++)
    {
        CDCell *oneCell = [riskFactors cell:i];
        oneCell.showImage = FALSE;
        oneCell.showSymbol = TRUE;
        oneCell.showBackground = TRUE;
        oneCell.backgropund.style = cellBackgroundStyle;
        oneCell.backgropund.highlightStyle = cellHighLightStyle;
        oneCell.backgropund.bkgColor = [UIColor colorWithRed:.8 green:.2 blue:0 alpha:.2];
        oneCell.backgropund.edgeColor = [UIColor colorWithRed:.8 green:.2 blue:0 alpha:.4];
        oneCell.backgropund.highlightColor = [UIColor colorWithRed:.8 green:.2 blue:0 alpha:.8];
        oneCell.symbol = [[NSMutableString alloc] initWithFormat:@"%d", i];
        oneCell.symbolAttributes = textAttributes;
        oneCell.sizeWeight = i + 1;
    }
    
    // second slice
    CDRingSlice* risks = [newRing getSlice:1];
    risks.label = [[NSMutableString alloc] initWithString:@"Diseases"];
    risks.backgropund.bkgColor = [UIColor colorWithRed:1.0 green:.0 blue:0 alpha:.2];
    risks.backgropund.edgeColor = [UIColor colorWithRed:1.0 green:.0 blue:0 alpha:.4];
    
    nCells = 8;
    [risks createCells:nCells];
    for (i = 0; i < nCells; i++)
    {
        CDCell *oneCell = [risks cell:i];
        oneCell.showImage = FALSE;
        oneCell.showSymbol = TRUE;
        oneCell.showBackground = TRUE;
        oneCell.backgropund.style = cellBackgroundStyle;
        oneCell.backgropund.highlightStyle = cellHighLightStyle;
        oneCell.backgropund.bkgColor = [UIColor colorWithRed:1.0 green:.0 blue:0 alpha:.4];
        oneCell.backgropund.edgeColor = [UIColor colorWithRed:1.0 green:.0 blue:0 alpha:.6];
        oneCell.backgropund.highlightColor = [UIColor colorWithRed:1.0 green:.0 blue:0 alpha:.8];
        oneCell.symbol = [[NSMutableString alloc] initWithFormat:@"%d", i];
        oneCell.symbolAttributes = textAttributes;
        oneCell.sizeWeight = nCells - i + 1;
    }

    // third slice
    CDRingSlice* actions = [newRing getSlice:2];
    actions.label = [[NSMutableString alloc] initWithString:@"Control Actions"];
    actions.backgropund.bkgColor = [UIColor colorWithRed:.13 green:.545 blue:.13 alpha:.2];
    actions.backgropund.edgeColor = [UIColor colorWithRed:.13 green:.545 blue:.13 alpha:0.4];
    
    nCells = 18;
    [actions createCells:nCells];
    for (i = 0; i < nCells; i++)
    {
        CDCell *oneCell = [actions cell:i];
        oneCell.showImage = FALSE;
        oneCell.showSymbol = TRUE;
        oneCell.showBackground = TRUE;
        oneCell.backgropund.style = cellBackgroundStyle;
        oneCell.backgropund.highlightStyle = cellHighLightStyle;
        oneCell.backgropund.bkgColor = [UIColor colorWithRed:.0 green:1.0 blue:0 alpha:.6];
        oneCell.backgropund.edgeColor = [UIColor colorWithRed:.13 green:.545 blue:.13 alpha:.8];
        oneCell.backgropund.highlightColor = [UIColor colorWithRed:.0 green:1.0 blue:0 alpha:.8];
        oneCell.symbol = [[NSMutableString alloc] initWithFormat:@"%d", i];
        oneCell.symbolAttributes = textAttributes;
        oneCell.sizeWeight = nCells - i + 1;
    }
    
    /////////////////////////////////////
    // add another ring
    /////////////////////////////////////
    // !!! add one ring
    newRing = [self addRing];
    
    newRing.showTop = FALSE;
    newRing.showBottom = TRUE;
    newRing.bottomEdgeColor = [UIColor lightGrayColor];
    
    // attributed symbol string
    textAttributes = [NSMutableDictionary dictionary];
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), newRing.size - 4, NULL);
    textAttributes[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    // !!! all rings have the same number of slices
    //  create 3 slices
    [newRing createSlices:3];
    
    nCells = 10;
    // first slice
    riskFactors = [newRing getSlice:0];
    [riskFactors.label setString:@"Risk Factors"];
    riskFactors.backgropund.bkgColor = [UIColor colorWithRed:.2 green:.8 blue:0 alpha:.2];
    riskFactors.backgropund.edgeColor = [UIColor colorWithRed:.2 green:.8 blue:0 alpha:.4];
    
    [riskFactors createCells:nCells];
    for (i = 0; i < nCells; i++)
    {
        CDCell *oneCell = [riskFactors cell:i];
        oneCell.showImage = FALSE;
        oneCell.showSymbol = TRUE;
        oneCell.showBackground = TRUE;
        oneCell.backgropund.style = cellBackgroundStyle;
        oneCell.backgropund.highlightStyle = cellHighLightStyle;
        oneCell.backgropund.bkgColor = [UIColor colorWithRed:.2 green:.8 blue:0 alpha:.2];
        oneCell.backgropund.edgeColor = [UIColor colorWithRed:.2 green:.8 blue:0 alpha:.4];
        oneCell.backgropund.highlightColor = [UIColor colorWithRed:.2 green:.8 blue:0 alpha:.8];
        oneCell.symbol = [[NSMutableString alloc] initWithFormat:@"%d", i];
        oneCell.symbolAttributes = textAttributes;
        oneCell.sizeWeight = nCells - i + 1;
    }
    
    // second slice
    risks = [newRing getSlice:1];
    [risks.label setString:@"Diseases"];
    risks.backgropund.bkgColor = [UIColor colorWithRed:1.0 green:.0 blue:.6 alpha:.2];
    risks.backgropund.edgeColor = [UIColor colorWithRed:1.0 green:.0 blue:.6 alpha:.4];
    
    nCells = 8;
    [risks createCells:nCells];
    for (i = 0; i < nCells; i++)
    {
        CDCell *oneCell = [risks cell:i];
        oneCell.showImage = FALSE;
        oneCell.showSymbol = TRUE;
        oneCell.showBackground = TRUE;
        oneCell.backgropund.style = cellBackgroundStyle;
        oneCell.backgropund.highlightStyle = cellHighLightStyle;
        oneCell.backgropund.bkgColor = [UIColor colorWithRed:1.0 green:.0 blue:.6 alpha:.2];
        oneCell.backgropund.edgeColor = [UIColor colorWithRed:1.0 green:.0 blue:.6 alpha:.4];
        oneCell.backgropund.highlightColor = [UIColor colorWithRed:1.0 green:.0 blue:0 alpha:.8];
        oneCell.symbol = [[NSMutableString alloc] initWithFormat:@"%d", i];
        oneCell.symbolAttributes = textAttributes;
        oneCell.sizeWeight = i + 1;
    }
    
    // third slice
    actions = [newRing getSlice:2];
    [actions.label setString:@"Control Actions"];
    actions.backgropund.bkgColor = [UIColor colorWithRed:.0 green:.0 blue:1.0 alpha:.2];
    actions.backgropund.edgeColor = [UIColor colorWithRed:.0 green:.0 blue:1.0 alpha:.4];
    
    nCells = 18;
    [actions createCells:nCells];
    for (i = 0; i < nCells; i++)
    {
        CDCell *oneCell = [actions cell:i];
        oneCell.showImage = FALSE;
        oneCell.showSymbol = TRUE;
        oneCell.showBackground = TRUE;
        oneCell.backgropund.style = cellBackgroundStyle;
        oneCell.backgropund.highlightStyle = cellHighLightStyle;
        oneCell.backgropund.bkgColor = [UIColor colorWithRed:.0 green:.0 blue:1.0 alpha:.2];
        oneCell.backgropund.edgeColor = [UIColor colorWithRed:.0 green:.0 blue:1.0 alpha:.4];
        oneCell.backgropund.highlightColor = [UIColor colorWithRed:.0 green:.0 blue:1.0 alpha:.8];
        oneCell.symbol = [[NSMutableString alloc] initWithFormat:@"%d", i];
        oneCell.symbolAttributes = textAttributes;
        oneCell.sizeWeight = i + 1;
    }

    // set up connections
    NSString *cnnTip = [NSString stringWithFormat:@"%d chance a cause b while %d chance b cause a", (int)(.2 * 100), (int)(.1 * 100)];
    
    // (0, 0, 0) <-> (0, 1, 0) intensity = .1
    [self connectCells:cnnTip ring_a:0 slice_a:0 cell_a:0 intensity_a:.2 ring_b:0 slice_b:1 cell_b:0 intensity_b:.1];
    
    // (0, 0, 0) <-> (1, 2, 0) intensity = .1
    [self connectCells:@"connection" ring_a:0 slice_a:0 cell_a:0 intensity_a:.2 ring_b:1 slice_b:2 cell_b:0 intensity_b:.1];

    // (0, 1, 0) <-> (1, 2, 0) intensity = .1
    [self connectCells:@"connection" ring_a:0 slice_a:1 cell_a:0 intensity_a:.2 ring_b:1 slice_b:2 cell_b:0 intensity_b:.1];
    // (0, 1, 0) <-> (1, 2, 8) intensity = .1
    [self connectCells:@"connection" ring_a:0 slice_a:1 cell_a:0 intensity_a:.2 ring_b:1 slice_b:2 cell_b:8 intensity_b:.9];
    
    // (1, 2, 0) <-> (1, 2, 0) intensity = .1
    [self connectCells:@"connection" ring_a:1 slice_a:3 cell_a:0 intensity_a:.2 ring_b:1 slice_b:2 cell_b:0 intensity_b:.9];
    // (1, 2, 0) <-> (1, 2, 0) intensity = .1
    [self connectCells:@"connection" ring_a:1 slice_a:2 cell_a:0 intensity_a:.2 ring_b:1 slice_b:2 cell_b:4 intensity_b:.8];
    
    // (0, 1, 6) <-> (1, 2, 3) intensity = .1
    [self connectCells:@"connection" ring_a:0 slice_a:1 cell_a:0 intensity_a:.2 ring_b:1 slice_b:2 cell_b:3 intensity_b:.1];
    // (0, 1, 6) <-> (1, 2, 8) intensity = .1
    [self connectCells:@"connection" ring_a:0 slice_a:1 cell_a:0 intensity_a:.2 ring_b:1 slice_b:3 cell_b:8 intensity_b:.9];
}

// call to make sure tree ring slices are all in sync between view and data set
-(void)onDirtyView
{
    [self setSliceAnglePositions];
}

// reset ring slice angle positions.  called after setting up data and angle sizes
-(void)setSliceAnglePositions
{
    // get archor ring
    CDRing *archorRing = nil;
    if (archor_ring >= rings.count || archor_ring < 0)
    {
        archorRing = [rings objectAtIndex:0];
    }else
    {
        archorRing = [rings objectAtIndex:archor_ring];
    }
    
    if (archorRing == nil)
    {
        return ;
    }
    
    if ([archorRing numberOfSlices] <= 0)
    {
        return ;
    }
    
    // ring slice positions
    NSMutableArray *sliceWidths;
    
    int i, totalCells, nLargeSlices;
    float gap = archorRing.gap;
    float angleSpace = 360.0 - [archorRing numberOfSlices] * gap;
    
    totalCells = 0;
    for (i = 0; i < [archorRing numberOfSlices]; i++)
    {
        totalCells += [[archorRing getSlice:i] numberOfCells];
    }
    
    // cell width
    float cellWidth = angleSpace / totalCells;
    
    // go over all slices to assign run time size
    sliceWidths = [[NSMutableArray alloc] initWithCapacity:[archorRing numberOfSlices]];
    
    for (i = 0; i < [archorRing numberOfSlices]; i++)
    {
        [sliceWidths addObject:[NSNumber numberWithFloat: cellWidth * [[archorRing getSlice:i] numberOfCells]]];
    }
    
    // check if any of the ring slices has more that what is allowed
    nLargeSlices = 0;
    angleSpace = 360.0 - ([archorRing numberOfSlices] + 1) * gap;
    totalCells = 0;
    for (i = 0; i < [archorRing numberOfSlices]; i++)
    {
        if ([[sliceWidths objectAtIndex:i] floatValue] >= [archorRing getSlice:i].maxSize)
        {
            nLargeSlices++;
            angleSpace -= [archorRing getSlice:i].maxSize;
        }else
        {
            totalCells += [[archorRing getSlice:i] numberOfCells];
        }
    }
    
    if (nLargeSlices > 0)
    {
        cellWidth = angleSpace / totalCells;
        
        for (i = 0; i < [archorRing numberOfSlices]; i++)
        {
            if ([[sliceWidths objectAtIndex:i] floatValue] >= [archorRing getSlice:i].maxSize)
            {
                sliceWidths[i] = [NSNumber numberWithFloat:[archorRing getSlice:i].maxSize];
            }else
            {
                sliceWidths[i] = [NSNumber numberWithFloat:([[archorRing getSlice:i] numberOfCells] * cellWidth)];
            }
        }
    }
    
    // now we have size for each rong slice in sliceWidths.  set each ring slices
    float start = .0, end = .0;
    
    start = .0;
    for (i = 0; i < [archorRing numberOfSlices]; i++)
    {
        end = start + [[sliceWidths objectAtIndex:i] floatValue];
        [archorRing getSlice:i].right = start;
        [archorRing getSlice:i].left = end;
        start = end + archorRing.gap;
    }
    
    // find shift that would center the archor ring slice
    CDRingSlice *archorSlice = [archorRing getSlice:archor_slice];
    if (archorSlice == nil)
    {
        archorSlice = [archorRing getSlice:0];
    }
    
    if (archorSlice == nil)
    {
        return ;
    }
    
    float shift = 90. - (archorSlice.left + archorSlice.right) * .5;
    
    for (i = 0; i < [archorRing numberOfSlices]; i++)
    {
        [archorRing getSlice:i].left = [archorRing getSlice:i].left + shift;
        [archorRing getSlice:i].right = [archorRing getSlice:i].right + shift;
        
        [[archorRing getSlice:i] onDirtyView];
    }
    
    // copy the slice positions from archor ring into other rings
    int j;
    for (j = 0; j < rings.count; j++)
    {
        if (j == archor_ring || [[rings objectAtIndex:j] isKindOfClass:[CDRing class]] == FALSE)
        {
            continue;
        }
        
        CDRing *oneRing = [rings objectAtIndex:j];
        
        for (i = 0; i < [oneRing numberOfSlices]; i++)
        {
            [oneRing getSlice:i].left = [archorRing getSlice:i].left;
            [oneRing getSlice:i].right = [archorRing getSlice:i].right;
            
            [[oneRing getSlice:i] onDirtyView];
        }
    }
}

// reset ring radius positions ringPositions.  called before painting all objects
-(void)setRingPositions
{
    CGRect size = [self size:1.0];
    
    // get font unit size first
    _oneUnitSize = size.size.height;
    [self translateChildernFontSize:(_oneUnitSize)];
    
    // follow the object orders along radius direction
    
    // title ring position
    if (_showText == TRUE && title != nil)
    {
        _titleRadiusPosition = _radius - title.runtimeSize;
    } 
    
    // edge ring position
    if (edge != nil)
    {
        _edgeRadiusPosition = _titleRadiusPosition - edge.runtimeSize;
    }
    
    // axis ring position
    if (_showAxis == TRUE && axis != nil)
    {
        _axisRadiusPosition = _edgeRadiusPosition - axis.runtimeSize;
    }else
    {
        _axisRadiusPosition = _edgeRadiusPosition;
    }
    
    // data ring positions starts from _axisRadiusPosition
    if (ringPositions == nil)
    {
        ringPositions = [[NSMutableArray alloc] initWithCapacity:rings.count];
    }else
    {
        [ringPositions removeAllObjects];
    }
    
    int i;
    float ringPos = _axisRadiusPosition;
    
    for (i = 0; i < rings.count; i++)
    {
        if ([[rings objectAtIndex:i] isKindOfClass:[CDRing class]] == FALSE)
        {
            continue;
        }
        
        CDRing *oneRing = [rings objectAtIndex:i];
        ringPos -= oneRing.runtimeSize;
        [ringPositions addObject:[NSNumber numberWithFloat:ringPos]];
    }
}

// return the rect are of one letter with given font size
// get size defined in font unit
-(CGRect)size:(float)fontSize
{
    NSMutableDictionary *attrDictionary = [NSMutableDictionary dictionary];
    
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica"), fontSize, NULL);
    attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"a" attributes:attrDictionary];
    
    // get string label size
    CGRect txtSize = [attString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
    
    return txtSize;
}

// set archor ring / slice
-(void)setArchorSlice:(int)ring
                slice:(int)slice
{
    archor_ring = ring;
    archor_slice = slice;
}

// !!! caller needs to decide when to call onDirtyView to make sure the view and data in sync
// radius - in font size
-(void)setCDSize:(CGPoint)origin
          radius:(float)radius
{
    _origin = origin;
    _radius = radius;
    _hostFrame = self.bounds;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // paint graph
    [self paint:ctx];
}

// paint background
-(void)paintBackground:(CGContextRef)ctx
                  size:(CGRect)rect
{
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextFillRect(ctx, rect);
}

// paint graph
-(void)paint:(CGContextRef)ctx
{
    // setup ring positions
    [self setRingPositions];
    
    // paint titles
    if (_showText && title != nil)
    {
        [self paintTitle:ctx radius:_titleRadiusPosition center:_origin frameHeight:_hostFrame.size.height];
    }
    
    // paint edge
    if (edge != nil)
    {
        [self paintEdge:ctx radius:_edgeRadiusPosition center:_origin frameHeight:_hostFrame.size.height];
    }
    
    // paint axis
    if (_showAxis && axis != nil)
    {
        [self paintAxis:ctx radius:_axisRadiusPosition center:(_origin) frameHeight:_hostFrame.size.height];
    }
    
    // paint all rings
    [self paintRings:ctx center:_origin frameHeight:_hostFrame.size.height];
    
    // paint all connections
    [self paintConnections:ctx center:(_origin) frameHeight:_hostFrame.size.height];
    
    // paint text messages for each highlighted connector ribbons along the ribbon path
    [self paintHighlightedConnectionTips:ctx center:_origin frameHeight:_hostFrame.size.height];
    
    // paint tip message
    [self paintTipMessage:ctx center:_origin frameHeight:_hostFrame.size.height];
}

// paint title
-(void)paintTitle:(CGContextRef)ctx
           radius:(float)radius
           center:(CGPoint)origin
      frameHeight:(int)height
{
    if (title == nil || rings.count <= 0)
    {
        return ;
    }
    
    // save current context
    CGContextSaveGState(ctx);
    
    // paint title
    CDRing* archorRing;
    if (archor_ring >= rings.count || archor_ring < 0)
    {
        archorRing = [rings objectAtIndex:0];
    }else
    {
        archorRing = [rings objectAtIndex:archor_ring];
    }

    [title paint:ctx archorRing:archorRing radius:radius center:origin frameHeight:height];
    
    // restore the original contest
    CGContextRestoreGState(ctx);
}

// paint edge
-(void)paintEdge:(CGContextRef)ctx
          radius:(float)radius
          center:(CGPoint)origin
     frameHeight:(int)height
{
    // save current context
    CGContextSaveGState(ctx);
    
    Slice size;
    
    size.bottom = radius;
    size.top = size.bottom + edge.runtimeSize;
    size.right = 0.0;
    size.left = 360.0;
    
    [edge.background paint:ctx layout:size center:origin];
    
    // restore the original contest
    CGContextRestoreGState(ctx);
}

// paint axis
-(void)paintAxis:(CGContextRef)ctx
          center:(CGPoint)origin
          radius:(float)radius
     frameHeight:(int)height
{
    // save current context
    CGContextSaveGState(ctx);
    
    
    // restore the original contest
    CGContextRestoreGState(ctx);
}

// paint rings
-(void)paintRings:(CGContextRef)ctx
           center:(CGPoint)origin
      frameHeight:(int)height
{
    int i, j;
    float rPosition, size;
    
    for (i = 0; i < rings.count; i++)
    {
        CDRing *oneRing = [rings objectAtIndex:i];
        rPosition = [[ringPositions objectAtIndex:i] floatValue];
        size = oneRing.size * _oneUnitSize;
        
        // paint all ring slices
        for (j = 0; j < oneRing.numberOfSlices; j++)
        {
            [[oneRing getSlice:j] paint:ctx center:origin bottom:rPosition top:(rPosition + size) frameHeight:height];
        }
        
        // paint ring edge borders
        [oneRing paint:ctx radius:rPosition size:size center:origin];
    }
}

// paint connector ribbons
-(void)paintConnections:(CGContextRef)ctx
                 center:(CGPoint)origin
            frameHeight:(int)height
{
    id obj;
    
    for (obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue;
        }
        
        // we have one CDConnection object
        [self paintConnection:ctx connection:obj center:origin frameHeight:height];
    }
}

// paint one connection
-(void)paintConnection:(CGContextRef)ctx
            connection:(CDConnection*)connection
                center:(CGPoint)origin
           frameHeight:(int)height
{
    CGContextSaveGState(ctx);
    
    CDCell *node;
    
    if (connection.a.intensity > connection.b.intensity)
    {
        node = connection.node_a;
    }else
    {
        node = connection.node_b;
    }
    
    if (connection.highlight == TRUE)
    {
        CGContextSetFillColorWithColor(ctx, node.backgropund.highlightColor.CGColor);
    }else
    {
        CGContextSetFillColorWithColor(ctx, node.backgropund.bkgColor.CGColor);
    }
    CGContextSetStrokeColorWithColor(ctx, node.backgropund.edgeColor.CGColor);
    
    CGContextSetLineWidth(ctx, .5);
    
    CGContextBeginPath(ctx);
    
    float radius_a, radius_b;
    
    radius_a = [[ringPositions objectAtIndex:connection.a.ring] floatValue];
    radius_b = [[ringPositions objectAtIndex:connection.b.ring] floatValue];
    
    // create path and save it in connection for later hit testing
    [self setConnectorRibbonPath:connection radius_a:radius_a start_a:connection.a.right end_a:connection.a.left radius_b:radius_b start_b:connection.b.right end_b:connection.b.left center:origin];
    
    CGContextAddPath(ctx, connection.aPath.CGPath);
    
    // draw the path
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}

// update visual connector path saved in connectionn object
-(void)setConnectorRibbonPath:(CDConnection*)connection
                     radius_a:(float)radius_a
                      start_a:(float)start_a
                        end_a:(float)end_a
                     radius_b:(float)radius_b
                      start_b:(float)start_b
                        end_b:(float)end_b
                       center:(CGPoint)origin
{
    if (connection == nil)
    {
        return ;
    }
    
    if (connection.aPath == nil)
    {
        // new object
        connection.aPath = [[UIBezierPath alloc] init];
    }else
    {
        // empty all sub paths
        [connection.aPath removeAllPoints];
    }
    
    // create new path into connection object
    // use coordinate of 4 points area:
    // p1 - left/top defined by node_a right
    // p2 - left/bottom defined by node_a left
    // p3 - right/bottom defined by node_b right
    // p4 - right/top define by node_b top
    
    // start from p3:
    CGPoint p3 = CGPointMake(origin.x + radius_b * cosf(DEGREES_TO_RADIANS(start_b)), origin.y - radius_b * sinf(DEGREES_TO_RADIANS(start_b)));
    // coonect to p1:
    CGPoint p1 = CGPointMake(origin.x + radius_a * cosf(DEGREES_TO_RADIANS(start_a)), origin.y - radius_a * sinf(DEGREES_TO_RADIANS(start_a)));
    
    // start from p3 - node b
    [connection.aPath moveToPoint:p3];
    // add arc path to p4 - node b
    [connection.aPath addArcWithCenter:origin radius:radius_b startAngle:-DEGREES_TO_RADIANS(start_b) endAngle:-DEGREES_TO_RADIANS(end_b) clockwise:FALSE];
    
    // add path to p1 - node a
    [connection.aPath addQuadCurveToPoint:p1 controlPoint:origin];
    // add arc path to p2 - node a
    [connection.aPath addArcWithCenter:origin radius:radius_a startAngle:-DEGREES_TO_RADIANS(start_a) endAngle:-DEGREES_TO_RADIANS(end_a) clockwise:FALSE];
    // add path back to p3
    [connection.aPath addQuadCurveToPoint:p3 controlPoint:origin];
    
    // close path
    [connection.aPath closePath];
}

// paint connector messages for all highlighted connectors
-(void)paintHighlightedConnectionTips:(CGContextRef)ctx
                               center:(CGPoint)origin
                          frameHeight:(int)height
{
    id obj;
    CDConnection * cnn;
    
    for (obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] != TRUE)
        {
            continue;
        }
        
        cnn = obj;
        if (cnn.highlight)
        {
            // draw the highlighted connector
            [self paintConnectionTip:ctx connection:cnn center:origin frameHeight:height];
        }
    }
}

// paint connector message along connector path
-(void)paintConnectionTip:(CGContextRef)ctx
               connection:(CDConnection*)connection
                   center:(CGPoint)origin
              frameHeight:(int)height
{
    // (1) find the two points that would produce the top path:
    float l_a, l_r, r_a, r_r;
    
    if (connection.a.left > connection.b.left)
    {
        // a node on the left side
        l_a = connection.a.right;
        l_r = [[ringPositions objectAtIndex:connection.a.ring] floatValue];
        
        r_a = connection.b.left;
        r_r = [[ringPositions objectAtIndex:connection.b.ring] floatValue];
    }else
    {
        // a node on the right side
        l_a = connection.b.right;
        l_r = [[ringPositions objectAtIndex:connection.b.ring] floatValue];
        
        r_a = connection.a.left;
        r_r = [[ringPositions objectAtIndex:connection.a.ring] floatValue];
    }
    
    // point p1 and p2:
    CGPoint p1 = CGPointMake(origin.x + l_r * cosf(DEGREES_TO_RADIANS(l_a)), origin.y + l_r * sinf(DEGREES_TO_RADIANS(l_a)));
    CGPoint p2 = CGPointMake(origin.x + r_r * cosf(DEGREES_TO_RADIANS(r_a)), origin.y + r_r * sinf(DEGREES_TO_RADIANS(r_a)));
    
    // (2) path between the two points
    CDCell *node;
    
    if (connection.a.intensity > connection.b.intensity)
    {
        node = connection.node_a;
    }else
    {
        node = connection.node_b;
    }
    
    // draw tip text along path
    if (connection.showTip)
    {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:connection.label attributes:(connection.largeFont == TRUE ? connection.attrLargeFont : connection.attrSmallFont)];
    
        // paint the text
        [bezierText paintTextOnQuadBezier:ctx text:attString p0:p1 p1:origin p2:p2 frameHeight:height];
    }
}

// paint tip message at the center
-(void)paintTipMessage:(CGContextRef)ctx
                center:(CGPoint)origin
           frameHeight:(int)height
{
    if (tipMsg == nil || ringPositions.count == 0)
    {
        return ;
    }
    
    [tipMsg paint:ctx radius:([[ringPositions objectAtIndex:(ringPositions.count - 1)] floatValue]) center:origin frameHeight:height];
    
    return ;
}

// set up all child component size based on given unit font size
-(void)translateChildernFontSize:(float)pointsPerFontSize
{
    [title translateChildernFontSize:pointsPerFontSize];
    [axis translateChildernFontSize:pointsPerFontSize];
    [edge translateChildernFontSize:pointsPerFontSize];
    
    id obj;
    
    for (obj in rings)
    {
        [obj translateChildernFontSize:pointsPerFontSize];
    }
}

////////////////////////////////////////////////////////////////
// touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // hit position
    _ptBegin = [touch locationInView:self];
    
    // object hit test
    [self hitTest:_ptBegin];
    
    // did we hit any objects?
    if (_hitObj.hitObject == CDObjs_None)
    {
        // no.  remove all special settings
        
        // remove tip
        
        // remove all highlight
        
        // show all default
        
        [self setNeedsDisplay];
        return ;
    }
    
    // yes.  deal with all cases
    if (_hitObj.hitObject == CDObjs_Axis)
    {
        // hit axis
        
    }else if (_hitObj.hitObject == CDObjs_Title)
    {
        // hit title text
        // remove highlight first
        [self setGraphConnectorState:FALSE];
        // set slice connectors
        [self setSliceConnectorState:_hitObj.sliceIndex highlight:TRUE];
        [self setNeedsDisplay];
    }else if (_hitObj.hitObject == CDObjs_Ring)
    {
        // hit ring.  hight connector to this ring
        // remove highlught first
        [self setGraphConnectorState:FALSE];
        // set ring highlight state
        [self setRingConnectorState:_hitObj.ringIndex highlight:TRUE];
        [self setNeedsDisplay];
    }else if (_hitObj.hitObject == CDObjs_Slice)
    {
        // hit ring slice.  highlight connectors to this ring slice
        // remove highlught first
        [self setGraphConnectorState:FALSE];
        // set slice highlight state
        [self setRingSliceConnectorState:_hitObj.ringIndex slice:_hitObj.sliceIndex highlight:TRUE];
        [self setNeedsDisplay];
    }else if (_hitObj.hitObject == CDObjs_Cell)
    {
        // hit cell        
        // highlight all connectors to this cell
        // remove highlight first
        [self setGraphConnectorState:FALSE];
        // set cel highlight state
        [self setCellConnectorState:_hitObj.ringIndex slice:_hitObj.sliceIndex cell:_hitObj.cellIndex highlight:TRUE];
        [self setNeedsDisplay];
    }else if (_hitObj.hitObject == CDObjs_Cnn)
    {
        // hot connector.  highlight this connector
        [self setConnectorState:_hitObj.pcnn highlight:TRUE];
        [self setNeedsDisplay];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _ptEnd = [touch locationInView:self];
    
    if (_hitObj.hitObject == CDObjs_None)
    {
        float delta = _ptEnd.x - _ptBegin.x;
        
        // change graph size
        CGPoint center = self.origin;
        float radius = self.radius + delta;
        
        [self setCDSize:center radius:radius];
        [self onDirtyView];
        [self setNeedsDisplay];
        
        _ptBegin = _ptEnd;
        return ;
    }else if (_hitObj.hitObject == CDObjs_Title)
    {
        float endAngle = .0;
        endAngle = 180.0 * atan(-(_ptEnd.y - _origin.y) / (_ptEnd.x - _origin.x)) / 3.14;
        if ((_ptEnd.x - _origin.x) < 0)
        {
            endAngle += 180;
        }
        
        float beginAngle = .0;
        beginAngle = 180.0 * atan(-(_ptBegin.y - _origin.y) / (_ptBegin.x - _origin.x)) / 3.14;
        if ((_ptBegin.x - _origin.x) < 0)
        {
            beginAngle += 180;
        }

        if (endAngle > beginAngle)
        {
            // rotate left
            [self rotate:TRUE];
            
        }else if (endAngle < beginAngle)
        {
            // rotate right
            [self rotate:FALSE];
        }
        
        [self onDirtyView];
        [self setNeedsDisplay];
        
        _ptBegin = _ptEnd;
        _hitObj.hitObject = CDObjs_None;
        return ;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self drawBitmap];
    [self setNeedsDisplay];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
    
    //_hitObj.hitObject = TRObjs_None;
}

// object hit test.  result is ssaved in _hitObj
-(void)hitTest:(CGPoint)hitPt
{
    _hitObj.hitObject = CDObjs_None;
    _hitObj.pcnn = 0;
    
    // (1) hit ring title?
    if (title != nil)
    {
        CDRing* archorRing;
        if (archor_ring >= rings.count || archor_ring < 0)
        {
            archorRing = [rings objectAtIndex:0];
        }else
        {
            archorRing = [rings objectAtIndex:archor_ring];
        }

        _hitObj = [title hitTest:hitPt archorRing:archorRing radius:_titleRadiusPosition center:_origin];
        if (_hitObj.hitObject != CDObjs_None)
        {
            return ;
        }
    }
    
    // (2) hit axis ? _axisRadiusPosition
    if (axis != nil)
    {
        _hitObj = [axis hitTest:hitPt radius:_axisRadiusPosition center:_origin];
        if (_hitObj.hitObject != CDObjs_None)
        {
            return ;
        }
    }
    
    // (3) hit ring cell?
    int i;
    float rPosition;
    
    for (i = 0; i < rings.count; i++)
    {
        if ([[rings objectAtIndex:i] isKindOfClass:[CDRing class]] == FALSE)
        {
            continue;
        }
        
        CDRing* oneRing = [rings objectAtIndex:i];
        rPosition = [[ringPositions objectAtIndex:i] floatValue];
    
        _hitObj = [oneRing hitTest:hitPt ring:i radius:rPosition center:_origin];
        
        if (_hitObj.hitObject == CDObjs_Ring)
        {
            return ;
        }else if (_hitObj.hitObject != CDObjs_None)
        {
            return ;
        }
    }
    
    // (4) hit node connectors?
    id obj;
    for (obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue;
        }
        
        if ([(CDConnection*)obj hitTest:hitPt] == TRUE)
        {
            _hitObj.hitObject = CDObjs_Cnn;
            _hitObj.pcnn = (__bridge void*)obj;
            return ;
        }
    }
}

// all cells on the graph
-(void)setGraphConnectorState:(BOOL)highlight
{
    // apply to entire connector set
    CDConnection* cnn;
    for (id obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        // lighlight the connector
        cnn = obj;
        cnn.highlight = highlight;
        
        // highlight the cells
        CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
        CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
        
        if (aCell != nil)
        {
            aCell.backgropund.highlight = highlight;
        }
        
        if (bCell)
        {
            bCell.backgropund.highlight = highlight;
        }
    }
}

// all cells of given ring
-(void)setRingConnectorState:(int)ring
                   highlight:(BOOL)highlight
{
    // apply to all cells with the gven ring index
    CDConnection* cnn;
    for (id obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        cnn = obj;
        if (cnn.a.ring != ring && cnn.b.ring != ring)
        {
            continue;
        }
        
        // highlight the connector
        cnn.highlight = highlight;
        
        // highlight the connector cells
        // lighlight the connector
        cnn = obj;
        cnn.highlight = highlight;
        
        // highlight the cells
        CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
        CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
        
        if (aCell != nil)
        {
            aCell.backgropund.highlight = highlight;
        }
        
        if (bCell)
        {
            bCell.backgropund.highlight = highlight;
        }
    }
}

// all cells of slice
-(void)setSliceConnectorState:(int)slice
                    highlight:(BOOL)highlight
{
    // apply to all cells with the gven ring and slice index
    CDConnection* cnn;
    for (id obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        cnn = obj;
        
        if (cnn.a.slice != slice && cnn.b.slice != slice)
        {
            continue;
        }
        
        // highlight the connector
        cnn.highlight = highlight;
        
        // highlight the connector cells
        // lighlight the connector
        cnn = obj;
        cnn.highlight = highlight;
        
        // highlight the cells
        CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
        CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
        
        if (aCell != nil)
        {
            aCell.backgropund.highlight = highlight;
        }
        
        if (bCell)
        {
            bCell.backgropund.highlight = highlight;
        }
    }
}

// all cells of given (ring, slice)
// all cells of given (ring, slice)
-(void)setRingSliceConnectorState:(int)ring
                            slice:(int)slice
                        highlight:(BOOL)highlight
{
    // apply to all cells with the gven ring and slice index
    CDConnection* cnn;
    for (id obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        cnn = obj;
        if (cnn.a.ring != ring && cnn.b.ring != ring)
        {
            continue;
        }
        
        if (cnn.a.slice != slice && cnn.b.slice != slice)
        {
            continue;
        }
        
        // highlight the connector
        cnn.highlight = highlight;
        
        // highlight the connector cells
        // lighlight the connector
        cnn = obj;
        cnn.highlight = highlight;
        
        // highlight the cells
        CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
        CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
        
        if (aCell != nil)
        {
            aCell.backgropund.highlight = highlight;
        }
        
        if (bCell)
        {
            bCell.backgropund.highlight = highlight;
        }
    }
}

// cell of (ring, slice, cell)
-(void)setCellConnectorState:(int)ring
                       slice:(int)slice
                        cell:(int)cell
                   highlight:(BOOL)highlight
{
    // apply to all cells with the gven ring, slice and cell index
    CDConnection* cnn;
    for (id obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        cnn = obj;
        if (cnn.a.ring != ring && cnn.b.ring != ring)
        {
            continue;
        }
        
        if (cnn.a.slice != slice && cnn.b.slice != slice)
        {
            continue;
        }
        
        if (cnn.a.cell != cell && cnn.b.cell != cell)
        {
            continue;
        }
        
        // highlight the connector
        cnn.highlight = highlight;
        
        // highlight the connector cells
        // lighlight the connector
        cnn = obj;
        cnn.highlight = highlight;
        
        // highlight the cells
        CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
        CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
        
        if (aCell != nil)
        {
            aCell.backgropund.highlight = highlight;
        }
        
        if (bCell)
        {
            bCell.backgropund.highlight = highlight;
        }
    }
}

// highlight connector
-(void)setConnectorState:(void*)cnnID
               highlight:(BOOL)highlight
{
    // reset all first
    id obj;
    CDConnection* cnn;
    
    for (obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        cnn = obj;
        
        if (((__bridge void*)obj) != cnnID)
        {
            // reset if not cnnID
            cnn.highlight = FALSE;
            
            // two ends
            CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
            CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
            
            if (aCell != nil)
            {
                aCell.backgropund.highlight = FALSE;
            }
            
            if (bCell)
            {
                bCell.backgropund.highlight = FALSE;
            }
        }else
        {
            // highlight matched connector
            cnn.highlight = highlight;
        }
    }
    
    // go over all connectors again to highlight the ending cells of highlighted connector
    for (obj in connectors)
    {
        if ([obj isKindOfClass:[CDConnection class]] == FALSE)
        {
            continue ;
        }
        
        if (((__bridge void*)obj) != cnnID)
        {
            // no match
            continue;
        }
        
        cnn = obj;
        
        // two ends
        CDCell *aCell = [self cell:cnn.a.ring slice:cnn.a.slice cell:cnn.a.cell];
        CDCell *bCell = [self cell:cnn.b.ring slice:cnn.b.slice cell:cnn.b.cell];
        
        if (aCell != nil)
        {
            aCell.backgropund.highlight = highlight;
        }
        
        if (bCell)
        {
            bCell.backgropund.highlight = highlight;
        }
    }
    
    return ;
}

// "rotate" the graph left or right by one slice
-(void)rotate:(BOOL)left
{
    // get total number of slices.  all rings have the same number of slices
    if ([rings objectAtIndex:archor_ring] == nil)
    {
        return ;
    }
    
    int nSlices = [[rings objectAtIndex:archor_ring] numberOfSlices];
    
    int archorSlice = left ? (archor_slice - 1) : (archor_slice + 1);
    
    if (archorSlice >= nSlices)
    {
        archorSlice = archorSlice % nSlices;
    }else if (archorSlice < 0)
    {
        archorSlice += nSlices;
    }
    
    [self setArchorSlice:archor_ring slice:archorSlice];
    
    return ;
}

@end
