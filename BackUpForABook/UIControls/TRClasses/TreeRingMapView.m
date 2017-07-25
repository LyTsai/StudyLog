//
//  TreeRingMapView.m
//  ATreeRingMap
//
//  Created by hui wang on 9/5/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TreeRingMapView.h"

#import "TRMetricDataTable.h"
#import "TRDataTableFactory.h"

@implementation TreeRingMapView

// tree ring map
TRMap *treeRingMap;

// place to load data table set for viewing in tree ring map
TRDataTableFactory *dataTableSource;
//初始化
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        treeRingMap = [[TRMap alloc] initWithFrame:frame];
        dataTableSource = [[TRDataTableFactory alloc] init];
    }
     
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setSize:self.bounds];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setSize:bounds];
}

-(void)setSize:(CGRect)frame
{
    if (treeRingMap == nil)
    {
        return;
    }
    
    [self setTMapSize:treeRingMap frame:frame];
}

// get number of ring slices
-(int)numberOfSlices
{
    if (treeRingMap == nil)
    {
        return 0;
    }
    
    return [treeRingMap numberOfSlices];
}

// access the slice
-(TRSlice*)getSlice:(int)position
{
    if (treeRingMap == nil)
    {
        return nil;
    }
    
    return [treeRingMap getSlice:position];
}

// load data table into ring slice
-(void)loadDataTableIntoSlice:(TRMetricDataTable*)dataTable
                        slice:(TRSlice*)slice
{
    if (slice && dataTable)
    {
        [slice showMetricDataTable:dataTable];
    }
}

// set slice style
-(void)setSliceStyle:(TRSlice*)slice
               style:(SliceViewStyle)style
{
    if (slice == nil)
    {
        return ;
    }
    
    [slice setStyle:style];
}

// return the rect are of one letter with given font size
// get size defined in font unit
-(CGRect)fontPointSize:(float)fontSize
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

-(void)setTMapSize:(TRMap*)treeRingMap frame:(CGRect)frame
{
    if (treeRingMap == nil)
    {
        return ;
    }
    
    treeRingMap.fontSize = [self fontPointSize:1.0].size.height;
    treeRingMap.frame = frame;
    [treeRingMap autoResize:frame];
 
    // redraw the map
    [treeRingMap setNeedsDisplay];
}

// create one slice tree ring map
-(void)addOneSlice:(float)begin
               end:(float)end
{
    if (treeRingMap == nil)
    {
        return ;
    }
    
    // create two ring slices:
    NSMutableArray* slicePositions = [[NSMutableArray alloc] init];
    
    // degree ranges for two slices: (0 - 180)
    [slicePositions addObject:[NSNumber numberWithFloat:begin]]; 
    [slicePositions addObject:[NSNumber numberWithFloat:end]];
    
    // compose tree ring map with specified ring slices
    [treeRingMap composeTreeRingMap:slicePositions];
    
    return ;
}

-(void)addTwoSlices:(float)begin
                mid:(float)mid
                end:(float)end
{
    if (treeRingMap == nil)
    {
        return ;
    }
    
    // create two ring slices:
    NSMutableArray* slicePositions = [[NSMutableArray alloc] init];
    
    // degree ranges for two slices: (0 - 45, 45 - 180)
    [slicePositions addObject:[NSNumber numberWithFloat:begin]];
    [slicePositions addObject:[NSNumber numberWithFloat:mid]];
    [slicePositions addObject:[NSNumber numberWithFloat:end]];
    
    // compose tree ring map with specified ring slices
    [treeRingMap composeTreeRingMap:slicePositions];
    
    return ;
}

// create N-slices tree ring map
-(void)addNSlices:(NSMutableArray*)slicePositions
{
    if (treeRingMap == nil)
    {
        return ;
    }

    // compose tree ring map with specified ring slices
    [treeRingMap composeTreeRingMap:slicePositions];
    
    return ;
}

// test case 1
-(void)test_1
{
    if (treeRingMap == nil)
    {
        return ;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    CGRect pointSize = [self fontPointSize:1.0];
    
    // set font size
    treeRingMap.fontSize = pointSize.size.height;

    // (1) two slices tree ring map
    [self addTwoSlices:0.0 mid:45.0 end:180.0];
    
    // set tree ring map size
    [self setSize:self.bounds];
    
    // set inital tree ring slice tables for testing purpose
    TRSlice* oneSlice;
    
    int i;
    for (i = 0; i < [self numberOfSlices]; i++)
    {
        oneSlice = [self getSlice:i];
        if (oneSlice != nil)
        {
            // create test data for each ring slice
            [oneSlice.table createTestTable];
            oneSlice.pointsPerFontSize = pointSize.size.height;
        }
    }
    
    [treeRingMap onDirtyView];
    
    // end of settng up tree ring map
    
    [self addSubview:treeRingMap];
}

// x axis - name and photo, y axis - risk factors with two slices of static and dynamic risk factors
-(void)test_VTD_GAME_OF_SCORE_Static_Dynamic
{
    if (treeRingMap == nil)
    {
        return ;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    //通过这个方法得到一个Helvetica字体,1.0大小的"a"字母的Rect
    CGRect pointSize = [self fontPointSize:1.0];
    
    // set font size
    //fontSize
    treeRingMap.fontSize = pointSize.size.height;
    
    // (1) two slices tree ring map
    [self addTwoSlices:0.0 mid:60.0 end:180.0];
    
    // (2) set slice styles
    if ([self getSlice:0] != nil)
    {
        [self setSliceStyle:[self getSlice:0] style:SliceViewStyle_1];
        [self getSlice:0].pointsPerFontSize = pointSize.size.height;
        [self getSlice:0].rightBorderStyle = SliceBorder_Metal;
        
        [self getSlice:0].angleAxis.fishyEye = FALSE;
        [self getSlice:0].ringAxis.fishyEye = FALSE;
        
        [[self getSlice:0].angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:.0 green:.0 blue: 1.0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
    
        [self getSlice:0].grid.evenRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1.0];
        [self getSlice:0].grid.oddRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
        
        // focusing lines
        [self getSlice:0].grid.rowFocus = 5;
    }
    
    if ([self getSlice:1] != nil)
    {
        [self setSliceStyle:[self getSlice:1] style:SliceViewStyle_2];
        [self getSlice:1].pointsPerFontSize = pointSize.size.height;
        [self getSlice:1].leftBorderStyle = SliceBorder_Metal;
        
        [self getSlice:1].angleAxis.fishyEye = FALSE;
        [self getSlice:1].ringAxis.fishyEye = FALSE;
        
        [[self getSlice:1].angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:.0 / 255.0 green:16.0 / 255.0 blue:255.0 / 255.0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
        
        [self getSlice:1].grid.evenRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1.0];
        [self getSlice:1].grid.oddRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
        
        // focusing lines
        [self getSlice:1].grid.rowFocus = 5;
        [self getSlice:1].grid.columnFocus = 3;
    }
    
    // (3) set tree ring map inital size
    //设置初始化frame
    [self setSize:self.bounds];
    
    //(4) load test data into two slices
    //
    TRMetricDataTable* tableOne = [dataTableSource createLowVitDGameOfScoresTable_Static];
    TRMetricDataTable* tableTwo = [dataTableSource createLowVitDGameOfScoresTable_Dynamic];
    
    // (5) load test data into two slices
    //给两个slice分别添加数据
    [self loadDataTableIntoSlice:tableOne slice:[self getSlice:1]];
    [self loadDataTableIntoSlice:tableTwo slice:[self getSlice:0]];
    
    // (6) add lables
    //添加左上角的标题label
    [self addTestLabels:treeRingMap];
    //[self addTestLabels_Chinese:treeRingMap];
    
    // (7) set center label
    [self setCenterLabel:treeRingMap];
    
    // (8) make sure to call for view update
    [treeRingMap onDirtyView];
    
    // (9) end of settng up tree ring map
    [self addSubview:treeRingMap];
}
////MH.dingf test function1
-(void)testForShowTreeRingMap:(TRMetricDataTable *)dataTableA and:(TRMetricDataTable *)dataTableB andLabelString:(NSMutableArray *)labelStringArr{
    if (treeRingMap == nil)
    {
        return ;
    }
    
    CGRect pointSize = [self fontPointSize:1.0];
    
    //fontSize
    treeRingMap.fontSize = pointSize.size.height;
    
    // (1) two slices tree ring map
    [self addTwoSlices:0.0 mid:60.0 end:180.0];
    
    // (2) set slice styles
    if ([self getSlice:0] != nil)
    {
        [self setSliceStyle:[self getSlice:0] style:SliceViewStyle_1];
        [self getSlice:0].pointsPerFontSize = pointSize.size.height;
        [self getSlice:0].rightBorderStyle = SliceBorder_Metal;
        
        [self getSlice:0].angleAxis.fishyEye = FALSE;
        [self getSlice:0].ringAxis.fishyEye = FALSE;
        
        [[self getSlice:0].angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:.0 green:.0 blue: 1.0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
        
        [self getSlice:0].grid.evenRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1.0];
        [self getSlice:0].grid.oddRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
        
        // focusing lines
        [self getSlice:0].grid.rowFocus = 5;
    }
    
    if ([self getSlice:1] != nil)
    {
        [self setSliceStyle:[self getSlice:1] style:SliceViewStyle_2];
        [self getSlice:1].pointsPerFontSize = pointSize.size.height;
        [self getSlice:1].leftBorderStyle = SliceBorder_Metal;
        
        [self getSlice:1].angleAxis.fishyEye = FALSE;
        [self getSlice:1].ringAxis.fishyEye = FALSE;
        
        [[self getSlice:1].angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:.0 / 255.0 green:16.0 / 255.0 blue:255.0 / 255.0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
        
        [self getSlice:1].grid.evenRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1.0];
        [self getSlice:1].grid.oddRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
        
        // focusing lines
        [self getSlice:1].grid.rowFocus = 5;
        [self getSlice:1].grid.columnFocus = 3;
    }
    
    // (3) set tree ring map inital size
    //设置初始化frame
    [self setSize:self.bounds];
    
    //(4) load test data into two slices
    //
    
    
    // (5) load test data into two slices
    //给两个slice分别添加数据
    [self loadDataTableIntoSlice:dataTableA slice:[self getSlice:1]];
    [self loadDataTableIntoSlice:dataTableB slice:[self getSlice:0]];
    
    // (6) add lables
    //添加五个position的所有的label。
    for (int i = 0; i < labelStringArr.count; i++) {
        //得到各个方位的数组的集合，注：最后一个是center label,数组中只有一个值
        NSMutableArray *positionLabelStringArr = labelStringArr[i];
        [self testAddLabels:treeRingMap andLabels:positionLabelStringArr andPosition:i];
    }
    
    
    
    
    //[self addTestLabels_Chinese:treeRingMap];
    
    // (7) set center label
    //[self setCenterLabel:treeRingMap];
    
    // (8) make sure to call for view update
    [treeRingMap onDirtyView];
    
    // (9) end of settng up tree ring map
    [self addSubview:treeRingMap];
}
////MH.dingf test function2
-(void)testForShowMeasurement:(TRMetricDataTable *)dataTableA and:(TRMetricDataTable *)dataTableB {
    if (treeRingMap == nil)
    {
        return ;
    }
    
    CGRect pointSize = [self fontPointSize:1.0];
    
    //fontSize
    treeRingMap.fontSize = pointSize.size.height;
    
    // (1) two slices tree ring map
    [self addTwoSlices:0.0 mid:60.0 end:180.0];
    
    // (2) set slice styles
    if ([self getSlice:0] != nil)
    {
        [self setSliceStyle:[self getSlice:0] style:SliceViewStyle_1];
        [self getSlice:0].pointsPerFontSize = pointSize.size.height;
        [self getSlice:0].rightBorderStyle = SliceBorder_Metal;
        
        [self getSlice:0].angleAxis.fishyEye = FALSE;
        [self getSlice:0].ringAxis.fishyEye = FALSE;
        
        [[self getSlice:0].angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:.0 green:.0 blue: 1.0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
        
        [self getSlice:0].grid.evenRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1.0];
        [self getSlice:0].grid.oddRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
        
        // focusing lines
        [self getSlice:0].grid.rowFocus = 5;
    }
    
    if ([self getSlice:1] != nil)
    {
        [self setSliceStyle:[self getSlice:1] style:SliceViewStyle_2];
        [self getSlice:1].pointsPerFontSize = pointSize.size.height;
        [self getSlice:1].leftBorderStyle = SliceBorder_Metal;
        
        [self getSlice:1].angleAxis.fishyEye = FALSE;
        [self getSlice:1].ringAxis.fishyEye = FALSE;
        
        [[self getSlice:1].angleAxis.title setStringAttributes:@"Helvetica-Bold" size:14.0 foregroundColor:[UIColor colorWithRed:.0 / 255.0 green:16.0 / 255.0 blue:255.0 / 255.0 alpha:.8] strokeColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.4] strokeWidth:-3.0];
        
        [self getSlice:1].grid.evenRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1.0];
        [self getSlice:1].grid.oddRowBackgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.8];
        
        // focusing lines
        [self getSlice:1].grid.rowFocus = 5;
        [self getSlice:1].grid.columnFocus = 3;
    }
    
    // (3) set tree ring map inital size
    //设置初始化frame
    [self setSize:self.bounds];
    
    //(4) load test data into two slices
    //
    
    
    // (5) load test data into two slices
    //给两个slice分别添加数据
    [self loadDataTableIntoSlice:dataTableA slice:[self getSlice:1]];
    [self loadDataTableIntoSlice:dataTableB slice:[self getSlice:0]];
    
    //[self addTestLabels_Chinese:treeRingMap];
    
    // (7) set center label
    //[self setCenterLabel:treeRingMap];
    
    // (8) make sure to call for view update
    [treeRingMap onDirtyView];
    
    // (9) end of settng up tree ring map
    [self addSubview:treeRingMap];
}


-(void)addGenervon3BioMarkerLegends:(TRMap*)treeRingMap
{
    UIColor* red = [UIColor colorWithRed:1.0 green:.0 blue: .0 alpha:.8];
    UIColor* yellow = [UIColor colorWithRed:1.0 green:.84 blue:.0 alpha:1.0];
    UIColor* green = [UIColor colorWithRed:.0 green:1.0 blue:.0 alpha:.8];
    UIColor* blue = [UIColor colorWithRed:.0 green:.0 blue:1.0 alpha:.8];
    
    // legend green
    [treeRingMap.legend addEntry:@"green" view:[[ANMetricView alloc] initWithValue:@"green" min:.0 max:100.0 fillColor:green edgeColor:green] label:[[ANText alloc] initWithFont:@"Helvetica" size:14.0 shadow:FALSE underline:FALSE]];
    [[treeRingMap.legend getLabel:@"green"].text setString:@"Disease Modification - Up Regulate"];
    
    // legend blue
    [treeRingMap.legend addEntry:@"blue" view:[[ANMetricView alloc] initWithValue:@"blue" min:.0 max:100.0 fillColor:blue edgeColor:blue] label:[[ANText alloc] initWithFont:@"Helvetica" size:14.0 shadow:FALSE underline:FALSE]];
    [[treeRingMap.legend getLabel:@"blue"].text setString:@"Disease Modification - Down Regulate"];
    
    // legend yellow
    [treeRingMap.legend addEntry:@"yellow" view:[[ANMetricView alloc] initWithValue:@"yellow" min:.0 max:100.0 fillColor:yellow edgeColor:yellow] label:[[ANText alloc] initWithFont:@"Helvetica" size:14.0 shadow:FALSE underline:FALSE]];
    [[treeRingMap.legend getLabel:@"yellow"].text setString:@"High or low end of range"];
    
    // legend red
    [treeRingMap.legend addEntry:@"red" view:[[ANMetricView alloc] initWithValue:@"red" min:.0 max:100.0 fillColor:red edgeColor:red] label:[[ANText alloc] initWithFont:@"Helvetica" size:14.0 shadow:FALSE underline:FALSE]];
    [[treeRingMap.legend getLabel:@"red"].text setString:@"Abnormal or Disease Progression"];
    
    return ;
}

// end of Genervon test cases
////////////////////////////////////////////////////////////////////////////////

// add labels

-(void)testAddLabels:(TRMap *)treeRingMap andLabels:(NSMutableArray *)stringsArr andPosition:(int) positionNumber{
    // title
    if (positionNumber == 0) {
        for (int i = 0; i < stringsArr.count; i++) {
            NSMutableArray *string = stringsArr[i];
            NSString *name = string[0];
            NSString *text = string[1];
            [treeRingMap.lables addLabel:[NSString stringWithFormat:@"%d",i] label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
            [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].name = [NSMutableString stringWithString:name];
            [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].text = [NSMutableString stringWithString:text];
            if (i == 3) {
                [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].textFillColor = [UIColor redColor];
                [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].textStrokeColor = [UIColor darkGrayColor];
            }else if (i == 4){
                [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].textFillColor = [UIColor redColor];
                [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].textStrokeColor = [UIColor darkGrayColor];
            }else if (i == 5){
                [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].textFillColor = [UIColor yellowColor];
                [treeRingMap.lables getLabel:[NSString stringWithFormat:@"%d",i]].textStrokeColor = [UIColor darkGrayColor];
            }
        }
        
    }else if (positionNumber == 4){
        NSMutableArray *centerLabelStringArr = stringsArr[0];
        NSString *info = centerLabelStringArr[0];
        NSString *value = centerLabelStringArr[1];
        NSString *title = centerLabelStringArr[2];
        treeRingMap.centerLabel.metricInfo.text = [NSMutableString stringWithString:info];
        treeRingMap.centerLabel.metricInfo.textFillColor = [UIColor blackColor];
        treeRingMap.centerLabel.metricInfo.textStrokeColor = [UIColor darkGrayColor];
        
        treeRingMap.centerLabel.metricValue.text = [NSMutableString stringWithString:value];
        treeRingMap.centerLabel.metricValue.textFillColor = [UIColor redColor];
        treeRingMap.centerLabel.metricValue.textStrokeColor = [UIColor blackColor];
        
        treeRingMap.centerLabel.title.text = [NSMutableString stringWithString:title];
        treeRingMap.centerLabel.title.textFillColor = [UIColor darkGrayColor];
        treeRingMap.centerLabel.title.textStrokeColor = [UIColor grayColor];
        
        
    }
}

-(void)addTestLabels:(TRMap*)treeRingMap;
{
    // labels
    
    // title
    [treeRingMap.lables addLabel:@"title" label:[[ANNamedText alloc] initWithFont:@"Helvetica-Bold" size:12.0 shadow:FALSE underline:TRUE]];
    [treeRingMap.lables getLabel:@"title"].text = [NSMutableString stringWithString:@"Annielyticx Healthspan Assurance Tree of Life"];
    
    // name
    [treeRingMap.lables addLabel:@"name" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"name"].name = [NSMutableString stringWithString:@"Name: "];
    [treeRingMap.lables getLabel:@"name"].text = [NSMutableString stringWithString:@"Peter Pan"];
    
    // race
    [treeRingMap.lables addLabel:@"race" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"race"].name = [NSMutableString stringWithString:@"Ethnicity: "];
    [treeRingMap.lables getLabel:@"race"].text = [NSMutableString stringWithString:@"American"];
    
    // smoke
    [treeRingMap.lables addLabel:@"smoke" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"smoke"].name = [NSMutableString stringWithString:@"Smoke: "];
    [treeRingMap.lables getLabel:@"smoke"].text = [NSMutableString stringWithString:@"Moderate"];
    [treeRingMap.lables getLabel:@"smoke"].textFillColor = [UIColor redColor];
    [treeRingMap.lables getLabel:@"smoke"].textStrokeColor = [UIColor darkGrayColor];
    
    // leisure
    [treeRingMap.lables addLabel:@"leisure" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"leisure"].name = [NSMutableString stringWithString:@"Physical Activity: "];
    [treeRingMap.lables getLabel:@"leisure"].text = [NSMutableString stringWithString:@"Low"];
    [treeRingMap.lables getLabel:@"leisure"].textFillColor = [UIColor yellowColor];
    [treeRingMap.lables getLabel:@"leisure"].textStrokeColor = [UIColor darkGrayColor];
    
    // medication
    [treeRingMap.lables addLabel:@"medication" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"medication"].name = [NSMutableString stringWithString:@"Medication: "];
    [treeRingMap.lables getLabel:@"medication"].text = [NSMutableString stringWithString:@"Statin"];
    [treeRingMap.lables getLabel:@"medication"].textFillColor = [UIColor orangeColor];
    [treeRingMap.lables getLabel:@"medication"].textStrokeColor = [UIColor darkGrayColor];
    
    // date
    [treeRingMap.date addLabel:@"title" label:[[ANNamedText alloc] initWithFont:@"Helvetica-Bold" size:12.0 shadow:FALSE underline:TRUE]];
    [treeRingMap.date getLabel:@"title"].text = [NSMutableString stringWithString:@"Issue date"];
    
    // today's date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    [treeRingMap.date addLabel:@"date" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.date getLabel:@"date"].text = [NSMutableString stringWithString:dateString];
}

-(void)addTestLabels_Chinese:(TRMap*)treeRingMap;
{
    // labels
    
    // title
    [treeRingMap.lables addLabel:@"title" label:[[ANNamedText alloc] initWithFont:@"Helvetica-Bold" size:12.0 shadow:FALSE underline:TRUE]];
    [treeRingMap.lables getLabel:@"title"].text = [NSMutableString stringWithString:@"annielyticx Healthspan保证识别卡"];
    
    // name
    [treeRingMap.lables addLabel:@"name" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"name"].name = [NSMutableString stringWithString:@"姓名: "];
    [treeRingMap.lables getLabel:@"name"].text = [NSMutableString stringWithString:@"彼得潘"];
    
    // race
    [treeRingMap.lables addLabel:@"race" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"race"].name = [NSMutableString stringWithString:@"种族: "];
    [treeRingMap.lables getLabel:@"race"].text = [NSMutableString stringWithString:@"白种人"];
    
    // smoke
    [treeRingMap.lables addLabel:@"smoke" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"smoke"].name = [NSMutableString stringWithString:@"吸烟: "];
    [treeRingMap.lables getLabel:@"smoke"].text = [NSMutableString stringWithString:@"适度"];
    [treeRingMap.lables getLabel:@"smoke"].textFillColor = [UIColor redColor];
    [treeRingMap.lables getLabel:@"smoke"].textStrokeColor = [UIColor darkGrayColor];
    
    // leisure
    [treeRingMap.lables addLabel:@"leisure" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"leisure"].name = [NSMutableString stringWithString:@"业余活动: "];
    [treeRingMap.lables getLabel:@"leisure"].text = [NSMutableString stringWithString:@"不足"];
    [treeRingMap.lables getLabel:@"leisure"].textFillColor = [UIColor yellowColor];
    [treeRingMap.lables getLabel:@"leisure"].textStrokeColor = [UIColor darkGrayColor];
    
    // medication
    [treeRingMap.lables addLabel:@"medication" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.lables getLabel:@"medication"].name = [NSMutableString stringWithString:@"服用药物: "];
    [treeRingMap.lables getLabel:@"medication"].text = [NSMutableString stringWithString:@"降低胆固醇"];
    [treeRingMap.lables getLabel:@"medication"].textFillColor = [UIColor orangeColor];
    [treeRingMap.lables getLabel:@"medication"].textStrokeColor = [UIColor darkGrayColor];
    
    // date
    [treeRingMap.date addLabel:@"title" label:[[ANNamedText alloc] initWithFont:@"Helvetica-Bold" size:12.0 shadow:FALSE underline:TRUE]];
    [treeRingMap.date getLabel:@"title"].text = [NSMutableString stringWithString:@"发行日期"];
    
    // today's date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    [treeRingMap.date addLabel:@"date" label:[[ANNamedText alloc] initWithFont:@"Helvetica" size:12.0 shadow:FALSE underline:FALSE]];
    [treeRingMap.date getLabel:@"date"].text = [NSMutableString stringWithString:dateString];
}

-(void)setCenterLabel:(TRMap*)treeRingMap;
{
    treeRingMap.centerLabel.metricInfo.text = [NSMutableString stringWithString:@"Your Heart Years: "];
    treeRingMap.centerLabel.metricInfo.textFillColor = [UIColor blackColor];
    treeRingMap.centerLabel.metricInfo.textStrokeColor = [UIColor darkGrayColor];
    
    treeRingMap.centerLabel.metricValue.text = [NSMutableString stringWithString:@"-20"];
    treeRingMap.centerLabel.metricValue.textFillColor = [UIColor redColor];
    treeRingMap.centerLabel.metricValue.textStrokeColor = [UIColor blackColor];
    
    treeRingMap.centerLabel.title.text = [NSMutableString stringWithString:@"Tree Of Life"];
    treeRingMap.centerLabel.title.textFillColor = [UIColor darkGrayColor];
    treeRingMap.centerLabel.title.textStrokeColor = [UIColor grayColor];
}

@end
