//
//  ACircleBarPanel.m
//  AProgressBars
//
//  Created by hui wang on 7/21/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ACircleBarPanel.h"

@interface ACircleBarPanel (PrivateMethods)

// test function
-(void)_setSampleData;

// shape styles
-(void)_setShapeStyle1;

// even layout of circle bars
// show bars via animation
-(void)_animat_show_even;

// hide bars via animation
-(void)_animat_hide_even;

// for test purpose
// expand evenly
-(void)_animat_even;

// auto_layout
// return elements for the given row with specified column size
-(NSArray*)rowElements:(int)nCols
                 nRow:(int)nRow;

// compute number of rows and columns based on aspect ratio of rect area
-(void)_gridLayoutByAspectRatio;

// evenly layout the circle bars regardless the size weight
-(void)_autoLayout_even;

// layout bars by size weights
-(void)_autoLayout_weight;

// refresh gui
-(void)_refreshDisplay;

// create sample ABars collection before we define the bar chart metrics data structure
-(NSArray*) _createSampleBarCollections;

@end

// array data
int rows23[2][3] = {{1,3,2}, {5,4,6}};
int rows34[2][4] = {{1,3,2,4}, {5,7,6,8}};
int rows25[2][5] = {{1,3,7,4,2}, {5,10,9,8,6}};
int rows26[2][6] = {{1,5,3,4,2,6}, {7,11,9,10,8,12}};
int rows27[2][7] = {{1,7,5,3,4,2,6},{13,11,9,10,8,14,12}};
int rows28[2][8] = {{1,5,3,7,2,6,4,8}, {9,13,11,15,10,14,12,16}};

@implementation ACircleBarPanel
{
    @private
    // collection of ACircularBarChart collections
    NSMutableArray *_layers;
    
    // number of cells per row
    int _nCols;
    // number of rows
    int _nRows;
}

// create the object
- (id)initWith:(CGRect)frame
          show:(BOOL)show
{
    self = [super init];
    
    if (self)
    {
        _gap = 18;
        _barSize = 8;
        
        super.frame = frame;
        
        // set show style
        [self _setShapeStyle1];
        
        /// !!! To Do, property set later
        [self _setSampleData];
        
        // "hide" both symbol and chart initialy
        for (ACircularBarChart* layer in _layers)
        {
            layer.opacity = 1.0;
        }
        _isShow = FALSE;
        //
        
        // show?
        if (show == TRUE)
        {
            [self show:show];
        }
    }
    
    return self;
}

-(void)_setShapeStyle1
{
    //self.backgroundColor = [UIColor colorWithRed: .9 green: 0.8 blue: 0.6 alpha: .2].CGColor;
    self.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: .8].CGColor;
    //self.backgroundColor = [UIColor clearColor].CGColor;
    self.shadowOffset = CGSizeMake(0, 2);
    self.shadowRadius = 3.0;
    self.shadowColor = [UIColor blackColor].CGColor;
    self.shadowOpacity = 0.6;
    self.borderColor = [UIColor lightGrayColor].CGColor;
    self.borderWidth = 2.0;
    self.cornerRadius = 10.0;
}

// drawing method
- (void)drawInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    // (1) draw round rect edges
    
    // (2) background
    
    // (3) draw all chart title
    CGRect textArea;
    int w, h;
    
    for (ACircularBarChart* chart in _layers)
    {
        // location of chart
        CGRect rc = chart.frame;
        
        // display title right below rc
        w = chart.bars.metricName.attributedText.size.width + 2;
        h =chart.bars.metricName.attributedText.size.height + 2;
        
        textArea = CGRectMake(rc.origin.x + (rc.size.width) / 2 - w / 2, rc.origin.y + rc.size.height + h / 2, w, h);
        
        [chart.bars.metricName paint:context rect:textArea];

    }
    
    CGContextRestoreGState(context);
}

// add one circle bar chart into collection
-(int)addCircleBarChartLayer:(ACircularBarChart*)layer
{
    [_layers addObject:layer];
    return [_layers indexOfObject:layer];
}

// feed with metric data (ABars) set.  see function "_createSampleBarCollections"
-(void)setMetricCollections:(NSArray*)metricBarsCollection
{
    // clean up ACircularBarChart collection first
    if (_layers)
    {
        // clear all cuyrrent object
        for (id obj in _layers)
        {
            [obj removeFromSuperlayer];
        }
        
        // clean up
        [_layers removeAllObjects];
    }else
    {
        _layers = [[NSMutableArray alloc] init];
    }

    // add all ABars into _layers
    for (ABars* bars in metricBarsCollection)
    {
        // wrap bars into ACircularBarChart object
        ACircularBarChart* circleBarchart = [[ACircularBarChart alloc] initWith:bars keyName:bars.key displayName:bars.metricName.text barSize:_barSize];
        
        // add into _layers collection
        [self addCircleBarChartLayer:circleBarchart];
    }
    
    // add all ACircularBarChart layer objects into current view layer
    for (ACircularBarChart* obj in _layers)
    {
        [self addSublayer:obj];
    }
    
    // grid dimension
    [self _gridLayoutByAspectRatio];
    
    // auto layout the circle bars
    [self _autoLayout_even];
}

-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    // grid dimension
    [self _gridLayoutByAspectRatio];
    
    // auto layout the circle bars
    [self _autoLayout_even];
}

// compute number of rows and columns based on aspect ratio of rect area
-(void)_gridLayoutByAspectRatio
{
    // total rect area
    CGRect rc = self.bounds;
    float r = rc.size.width / (rc.size.height + 1.0);
    
    // (1) compute the number of cells for each row based on the aspect ratio of rc
    //_nCols = (_layers.count + 1.0) * r / (1.0 + r);
    //_nRows = _layers.count / _nCols;
    _nCols = round(sqrt(_layers.count * r));
    _nRows = _layers.count / _nCols;
    
    if (_layers.count % _nCols > 0)
    {
        _nRows++;
    }
}

// evenly layout the circle bars regardless the size weight
-(void)_autoLayout_even
{
    int i, j, n;
    int size, sizex, sizey, x, y, dx, dy;
    
    CGRect rc = self.bounds;

    // compute for size of each cell
    sizex = (rc.size.width - _gap * (_nCols + 1)) / _nCols;
    sizey = (rc.size.height - _gap * (_nRows + 1)) / _nRows;
    
    size = MIN(sizex, sizey);
    
    // seperation between cells along x and y direction
    dx = (rc.size.width - _nCols * size) / (_nCols + 1);
    dy = (rc.size.height - _nRows * size) / (_nRows + 1);
    
    for (i = 0; i < _nRows; i++)
    {
        n = i * _nCols;
        
        for (j = 0; j < _nCols && (n + j) < _layers.count; j++)
        {
            // start position
            x = dx + (size + dx) * j;
            y = dy + (size + dy) * i;
            
            ACircularBarChart* chart = [_layers objectAtIndex:(n + j)];
            chart.frame = CGRectMake(x, y, size, size);
        }
    }
    
    // refresh GUI
    [self _refreshDisplay];
}

// layout bars by size weights
-(void)_autoLayout_weight
{
    int i, j, n;
    int size, sizex, sizey, x, y, dx, dy;
    
    CGRect rc = self.bounds;
    
    // compute for size of each cell
    sizex = (rc.size.width - _gap * (_nCols + 1)) / _nCols;
    sizey = (rc.size.height - _gap * (_nRows + 1)) / _nRows;
    
    size = MIN(sizex, sizey);
    
    // seperation between cells along x and y direction
    dx = (rc.size.width - _nCols * size) / (_nCols + 1);
    dy = (rc.size.height - _nRows * size) / (_nRows + 1);
    
    for (i = 0; i < _nRows; i++)
    {
        n = i * _nCols;
        
        // compute for "weigthed" size in this row
        int w, sizew, wsize;
        
        w = 0;
        for (j = 0; j < _nCols && (n + j) < _layers.count; j++)
        {
            ACircularBarChart* pChart = [_layers objectAtIndex:(n + j)];
            w += pChart.bars.sizeWeight;
        }
        
        // size per weight
        sizew = (_nCols * size ) / w;
        
        // set size for all cell
        for (j = 0; j < _nCols && (n + j) < _layers.count; j++)
        {
            ACircularBarChart* pChart = [_layers objectAtIndex:(n + j)];
            
            // center position
            x = dx + (size + dx) * j + .5 * size;
            y = dy + (size + dy) * i + .5 * size;
            
            // weighted size
            wsize = sizew * pChart.bars.sizeWeight;
            wsize = MIN(wsize, (size + _gap));
            
            pChart.frame = CGRectMake(x - wsize / 2, y - wsize / 2, wsize, wsize);
        }
    }

    // refresh GUI
    [self _refreshDisplay];
}

// refresh gui
-(void)_refreshDisplay
{
    for (ACircularBarChart* obj in _layers)
    {
        [obj setNeedsDisplay];
    }
}

// show or hide it
-(BOOL)show:(BOOL)show
{
    _isShow = show;
    return _isShow;
}

// access to chart for the given key
-(ACircularBarChart*)getChart:(NSString*)key
{
    for (id obj in _layers)
    {
        if ([obj isKindOfClass:[ACircularBarChart class]])
        {
            ACircularBarChart* barChart = obj;
            
            if (barChart.keyName == key)
            {
                return barChart;
            }
        }
    }
    
    return nil;
}

-(void)_setSampleData
{
    // create default metric bar layers for demo purpose
    [self setMetricCollections:[self _createSampleBarCollections]];
}

// create sample ABars collection before we define the bar chart metrics data structure
-(NSArray*) _createSampleBarCollections
{
    NSMutableArray* barsCollection = [[NSMutableArray alloc] init];
    
    // blood pressure
    ABars* bp = [[ABars alloc] init];
    bp.sizeWeight = 2.0;
    
    UIColor* color1 = [UIColor colorWithRed: .9 green: 0.2 blue: 0.2 alpha: .8];
    UIColor* color2 = [UIColor colorWithRed: .9 green: 0.2 blue: 0.2 alpha: .8];
    
    // array of ABar
    NSMutableArray* bpbars = [[NSMutableArray alloc] init];
    [bpbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:50 value:80.0 text:@"80"]];
    [bpbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:55 value:120.0 text:@"120"]];
    
    [bp initPros:@"bp" metricName:@"Blood Pressure" unit:@" " bars:bpbars];
    
    [barsCollection addObject:bp];
    // end bp
    
    // bmi
    ABars* bmi = [[ABars alloc] init];

    // array of ABar
    color1 = [UIColor colorWithRed: 255.0 / 255 green: 105.0 / 255 blue: 180.0 / 255 alpha: .9];
    color2 = [UIColor colorWithRed: 255.0 / 255 green: 105.0 / 255 blue: 180.0 / 255 alpha: .9];

    NSMutableArray* bmibars = [[NSMutableArray alloc] init];
    [bmibars addObject:[[ABar alloc] initWith:color1 color2:color2 height:45 value:37.1 text:@"37.1"]];
    
    [bmi initPros:@"bmi" metricName:@"BMI" unit:@" " bars:bmibars];
    
    [barsCollection addObject:bmi];
    // end bmi
    
    // serum Vitamin D3
    ABars* serumVitaminD3 = [[ABars alloc] init];
    serumVitaminD3.sizeWeight = 3.0;
    
    // array of ABar
    color1 = [UIColor colorWithRed: 34.0 / 255 green: 139.0 / 255 blue: 34.0 / 255 alpha: .9];
    color2 = [UIColor colorWithRed: 34.0 / 255 green: 139.0 / 255 blue: 34.0 / 255 alpha: .9];

    NSMutableArray* serumVitaminD3bars = [[NSMutableArray alloc] init];
    [serumVitaminD3bars addObject:[[ABar alloc] initWith:color1 color2:color2 height:60 value:45.6 text:@"45.6"]];
    
    [serumVitaminD3 initPros:@"serumVitaminD3" metricName:@"Serum Vitamin D3" unit:@" " bars:serumVitaminD3bars];
    
    [barsCollection addObject:serumVitaminD3];
    // end of serum Vitamin D3
    
    // waist line
    ABars* waistline = [[ABars alloc] init];
    
    // array of ABar
    color1 = [UIColor colorWithRed: 255.0 / 255.0 green: 215.0 / 255.0 blue: .0 / 255 alpha: .8];
    color2 = [UIColor colorWithRed: 255.0 / 255.0 green: 215.0 / 255.0 blue: .0 / 255 alpha: .8];
    
    NSMutableArray* waistlinebars = [[NSMutableArray alloc] init];
    [waistlinebars addObject:[[ABar alloc] initWith:color1 color2:color2 height:70 value:37.1 text:@"37.1"]];
    
    [waistline initPros:@"waistline" metricName:@"Wist Line" unit:@" " bars:bmibars];
    
    [barsCollection addObject:waistline];
    // end waist line
    
    // blood clucose
    ABars* bloodclucose = [[ABars alloc] init];
    bloodclucose.sizeWeight = 2.0;
    
    // array of ABar
    color1 = [UIColor colorWithRed: .0 / 255 green: 255.0 / 255 blue: .0 / 255 alpha: .8];
    color2 = [UIColor colorWithRed: .0 / 255 green: 255.0 / 255 blue: .0 / 255 alpha: .8];
    
    NSMutableArray* bloodclucosebars = [[NSMutableArray alloc] init];
    [bloodclucosebars addObject:[[ABar alloc] initWith:color1 color2:color2 height:80 value:113 text:@"113"]];
    
    [bloodclucose initPros:@"BloodClucose" metricName:@"Blood Clucose" unit:@" " bars:bloodclucosebars];
    
    [barsCollection addObject:bloodclucose];
    // end blood clucose
    
    // triglycerides
    ABars* triglycerides = [[ABars alloc] init];
    
    // array of ABar
    color1 = [UIColor colorWithRed: 255.0 / 255.0 green: 215.0 / 255.0 blue: .0 / 255 alpha: .8];
    color2 = [UIColor colorWithRed: 255.0 / 255.0 green: 215.0 / 255.0 blue: .0 / 255 alpha: .8];
    
    NSMutableArray* triglyceridesbars = [[NSMutableArray alloc] init];
    [triglyceridesbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:55 value:113 text:@"113"]];
    
    [triglycerides initPros:@"Triglycerides" metricName:@"Triglycerides" unit:@" " bars:triglyceridesbars];
    
    [barsCollection addObject:triglycerides];
    // end triglycerides
    
    // total cholesterol
    ABars* totalcholesterol = [[ABars alloc] init];
    
    // array of ABar
    color1 = [UIColor colorWithRed: 255.0 / 255.0 green: 255.0 / 255.0 blue: .0 / 255 alpha: .8];
    color2 = [UIColor colorWithRed: 255.0 / 255.0 green: 255.0 / 255.0 blue: .0 / 255 alpha: .8];
    
    NSMutableArray* totalcholesterolbars = [[NSMutableArray alloc] init];
    [totalcholesterolbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:58 value:69 text:@"69"]];
    
    [totalcholesterol initPros:@"TotalCholesterol" metricName:@"Total Cholesterol" unit:@" " bars:totalcholesterolbars];
    
    [barsCollection addObject:totalcholesterol];
    // end total cholesterol

    // hdl
    ABars* hdl = [[ABars alloc] init];
    
    // array of ABar
    
    color1 = [UIColor colorWithRed: 255.0 / 255.0 green: .0 / 255.0 blue: .0 / 255 alpha: .8];
    color2 = [UIColor colorWithRed: 255.0 / 255.0 green: .0 / 255.0 blue: .0 / 255 alpha: .8];
    
    NSMutableArray* hdlbars = [[NSMutableArray alloc] init];
    [hdlbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:65 value:46.1 text:@"46.1"]];
    
    [hdl initPros:@"HDL" metricName:@"HDL" unit:@" " bars:hdlbars];
    
    [barsCollection addObject:hdl];
    // end hdl
    
    // ldl
    ABars* ldl = [[ABars alloc] init];
    ldl.sizeWeight = 2.5;
    
    // array of ABar
    color1 = [UIColor colorWithRed: .0 / 255.0 green: 255.0 / 255.0 blue: .0 / 255 alpha: .8];
    color2 = [UIColor colorWithRed: .0 / 255.0 green: 255.0 / 255.0 blue: .0 / 255 alpha: .8];
    
    NSMutableArray* ldlbars = [[NSMutableArray alloc] init];
    [ldlbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:45 value:263.1 text:@"263.1"]];
    
    [ldl initPros:@"LDL" metricName:@"LDL" unit:@" " bars:ldlbars];
    
    [barsCollection addObject:ldl];

    // end ldl
    
    return barsCollection;
}

@end
