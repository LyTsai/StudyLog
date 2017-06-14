//
//  ACirclePopup.m
//  AProgressBars
//
//  Created by hui wang on 7/6/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ACirclePopup.h"

@interface ACirclePopup (PrivateMethods)

// test
-(void)_animat_test;

// test function
-(void)_setSampleData;

// even layout of circle bars
// show bars via animation
-(void)_animat_show_even;

// hide bars via animation
-(void)_animat_hide_even;

// for test purpose
// expand evenly
-(void)_animat_even;

// create collection of ABars that represents the groups of metric bars (based on the metric data set)

// create sample ABars collection before we define the bar chart metrics data structure
-(NSArray*) _createSampleBarCollections;

@end

@implementation ACirclePopup
{
    // collection of layers along the circle edge
    BOOL _bIsExpanded;
    
    // collection of ACircleExtendBar bar collections
    NSMutableArray *_layers;
}

- (id)initWith:(CGRect)frame
          show:(BOOL)show
{
    self = [super init];
    if (self)
    {
        self.frame = frame;
        
        _bIsExpanded = false;
        _layers = [[NSMutableArray alloc] init];
        
        // center opf circle popup set to the enter of bounds first
        _origin = CGPointMake(self.bounds.origin.x + .5 * self.bounds.size.width, self.bounds.origin.y + .5 * self.bounds.size.height);
        
        // distance from _origin to the center of circle symbol
        _radius = 80;//60;
        // pie chart size
        _size = 40;
        // angle range of areas the circles are confined within
        _beginAngle = M_PI / 3;//2.5;
        _endAngle = -M_PI / 3;//2.5;
        
        // one degree seperation
        _gapAngle = -DEGREES_TO_RADIANS(6.0);
        
        // animation settings
        _durationSymbol= .5;
        _durationPieChart = .5;
        _delay = .02;
        
        self.backgroundColor = [UIColor clearColor].CGColor;
        
        /// !!! To Do, property set later
        [self _setSampleData];
        
        // "hide" both symbol and chart initialy
        for (ACircleExtendBar* layer in _layers)
        {
            layer.pieChart.opacity = .0;
            layer.symbol.opacity = .0;
        }
        _isShow = FALSE;
        
        // show?
        if (show == TRUE)
        {
            [self show:show];
        }
    }
    
    return self;
}

// test function
-(void)_setSampleData
{
    // generate supported metric symbol collection.
    _metricSymbols = [[NSMutableDictionary alloc] init];
    
    // add all metric icon symbols
    [_metricSymbols setValue:[ASymbol_Stroke warp] forKey:@"Stroke"];
    [_metricSymbols setValue:[ASymbol_10_Year_Survival warp] forKey:@"10-Year Survival"];
    [_metricSymbols setValue:[ASymbol_Heart warp] forKey:@"CVD"];
    [_metricSymbols setValue:[ASymbol_Diabetes warp] forKey:@"Diabetes"];
    [_metricSymbols setValue:[ASymbol_NewCholestrol warp] forKey:@"New Cholestrol Guideline"];
    
    // create default metric bar layers for demo purpose
    [self setMetricCollections:[self _createSampleBarCollections]];
}

// reposition
-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    // center opf circle popup set to the enter of bounds first
    [self setOrigin:CGPointMake(self.bounds.origin.x + .5 * self.bounds.size.width, self.bounds.origin.y + .5 * self.bounds.size.height)];
}

// reposition the popup with client (bounds) area
-(void)setOrigin:(CGPoint)origin
{
    // center opf circle popup set to the enter of bounds first
    _origin = origin;
    
    // rect area for entire circle popup risk collection:
    float dx = _origin.x - (self.bounds.origin.x + .5 * self.bounds.size.width);
    float dy = _origin.y - (self.bounds.origin.y + .5 * self.bounds.size.height);
    float width = self.bounds.size.width - 2.0 * fabs(dx);
    float height = self.bounds.size.height - 2.0 * fabs(dy);
    
    CGRect popRect = CGRectMake(_origin.x - .5 * width, _origin.y - .5 * height, width, height);
    
    for(id obj in _layers)
    {
        [obj setFrame:popRect]; 
    }
}

// show or hide it
-(BOOL)show:(BOOL)show
{
    // show or hide?
    if (show == TRUE)
    {
        // animate the movement of symbol circles from origin to their current location once
        [self _animat_show_even];
    }else
    {
        // animate the movement of symbol circles from their current location to origin once
        [self _animat_hide_even];
    }
    
    _isShow = show;
    
    return _isShow;
}

// access to chart for the given key
-(APieBarChart*)getChart:(NSString*)key
{
    for (id obj in _layers)
    {
        if ([obj isKindOfClass:[ACircleExtendBar class]])
        {
            ACircleExtendBar* barChart = obj;
            
            if (barChart.pieChart.keyName== key)
            {
                return barChart.pieChart;
            }
        }
    }
    
    return nil;
}

// methods
// add a layer to the list
-(int)addCircleLayer:(ACircleExtendBar*)layer
{
    [_layers addObject:layer];
    return [_layers indexOfObject:layer];
}

// feed metric data (ABars) set
// all layers are created in this step
-(void)setMetricCollections:(NSArray*)metricBarsCollection
{
    // collection of ACircleExtendBar bar collections
    // clean up first
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

    // rect area for entire circle popup risk collection:
    float dx = _origin.x - (self.bounds.origin.x + .5 * self.bounds.size.width);
    float dy = _origin.y - (self.bounds.origin.y + .5 * self.bounds.size.height);
    float width = self.bounds.size.width - 2.0 * fabs(dx);
    float height = self.bounds.size.height - 2.0 * fabs(dy);
    
    CGRect popRect = CGRectMake(_origin.x - .5 * width, _origin.y - .5 * height, width, height);
    
    // add all metric collection
    for (ABars* bars in metricBarsCollection)
    {
        // (1) symbol layer
        // Make sure we have valid icon symbol layer
        APathDrawWrap* symbol = [_metricSymbols valueForKey:bars.key];
        if (symbol == nil)
        {
            symbol = [[APathDrawWrap alloc] init];
        }
        
        // pie chart layers
        ACircleExtendBar* metricBars = [[ACircleExtendBar alloc] initWith:popRect keyName:bars.key displayName:bars.metricName.text bars:bars symbol:symbol symbolRadius:10.0 bottom:_radius top:(_radius + _size) barGap:_gapAngle];
        [self addCircleLayer:metricBars];
    }
    
    // add all ACircleExtendBar layer objects into current view layer
    for (ACircleExtendBar* obj in _layers)
    {
        [self addSublayer:obj];
    }
    
    // auto layout the circle bars
    [self _autoLayout_even];
}

// even layout of circle bars
-(void)_autoLayout_even
{
    int nBars = _layers.count;
    
    float deltaAngle = (_endAngle - _beginAngle - (nBars - 1) * _gapAngle) / nBars;
    
    float b;
    
    b = _beginAngle;
    
    for (id obj in _layers)
    {
        [obj autoLayout:b endAngle:(b + deltaAngle)];
        b += (deltaAngle + _gapAngle);
        
        // !!! make sure we call to show it
        [obj setNeedsDisplay];
    }
}

/////////////////////////////////////////////////////////////////
// test functiuons
/////////////////////////////////////////////////////////////////

// create sample ABars collection before we define the bar chart metrics data structure
-(NSArray*) _createSampleBarCollections
{
    NSMutableArray* barsCollection = [[NSMutableArray alloc] init];
    
    // add predicted risks:
    
    // Stroke
    ABars* stroke = [[ABars alloc] init];
    
    // array of ABar
    NSMutableArray* strokebars = [[NSMutableArray alloc] init];
    
    UIColor* color1 = [UIColor colorWithRed: .2 green: 0.9 blue: 0.2 alpha: .8];
    UIColor* color2 = [UIColor colorWithRed: .2 green: 0.9 blue: 0.2 alpha: .8];
    
    [strokebars addObject:[[ABar alloc] initWith:color1 color2:color2 height:5 value:5.0 text:@"5%"]];
    
    [stroke initPros:@"Stroke" metricName:@"Stroke" unit:@"%" bars:strokebars];
    
    [barsCollection addObject:stroke];
    
    // 10-Year Survival
    ABars* survival_10yrs = [[ABars alloc] init];
    
    // array of ABar
    NSMutableArray* survivalbars = [[NSMutableArray alloc] init];
    
    color1 = [UIColor colorWithRed: .2 green: 0.9 blue: 0.8 alpha: .8];
    color2 = [UIColor colorWithRed: .2 green: 0.9 blue: 0.8 alpha: .8];
    
    [survivalbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:10.0 value:10.0 text:@"10%"]];
    
    [survival_10yrs initPros:@"10-Year Survival" metricName:@"10-Year Survival" unit:@"%" bars:survivalbars];
    [barsCollection addObject:survival_10yrs];
    
    // CVD
    ABars* cvd = [[ABars alloc] init];
    
    // array of ABar
    NSMutableArray* cvdbars = [[NSMutableArray alloc] init];
    
    color1 = [UIColor colorWithRed: .2 green: 0.9 blue: 0.8 alpha: .8];
    color2 = [UIColor colorWithRed: .2 green: 0.9 blue: 0.8 alpha: .8];
    
    [cvdbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:15.0 value:15.0 text:@"15%"]];
    
    [cvd initPros:@"CVD" metricName:@"CVD" unit:@"%" bars:cvdbars];
    [barsCollection addObject:cvd];
    
    // Diabetes
    ABars* diabetes = [[ABars alloc] init];
    
    // array of ABar
    NSMutableArray* diabetesbars = [[NSMutableArray alloc] init];
    
    color1 = [UIColor colorWithRed: 255.0 / 255 green: 105.0 / 255 blue: 180.0 / 255 alpha: .9];
    color2 = [UIColor colorWithRed: 255.0 / 255 green: 105.0 / 255 blue: 180.0 / 255 alpha: .9];

    [diabetesbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:25.0 value:25.0 text:@"25%"]];
    
    [diabetes initPros:@"Diabetes" metricName:@"Diabetes" unit:@"%" bars:diabetesbars];
    [barsCollection addObject:diabetes];
    
    // New cholestrol guidlines
    ABars* cholestrol = [[ABars alloc] init];
    
    // array of ABar
    NSMutableArray* cholestrolbars = [[NSMutableArray alloc] init];
    
    color1 = [UIColor colorWithRed: .9 green: 0.2 blue: 0.2 alpha: .8];
    color2 = [UIColor colorWithRed: .9 green: 0.2 blue: 0.2 alpha: .8];
    
    [cholestrolbars addObject:[[ABar alloc] initWith:color1 color2:color2 height:30.0 value:30.0 text:@"30%"]];
    
    [cholestrol initPros:@"New Cholestrol Guideline" metricName:@"New Cholestrol Guideline" unit:@"%" bars:cholestrolbars];
    [barsCollection addObject:cholestrol];
    
    return barsCollection;
}

-(void)_animat_test
{
    CGPoint center = CGPointMake(100, 100);
    float radius = 80;
    float angle = M_PI / 4;
    
    // create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:center];
    [bezierPath addLineToPoint:CGPointMake(center.x + radius * cos(angle), center.x + radius * sin(angle))];
    
    // create position animation
    CAKeyframeAnimation *posAnimat = [CAKeyframeAnimation animation];
    
    posAnimat.keyPath = @"position";
    posAnimat.path = bezierPath.CGPath;
    
    // create alpha animation
    CABasicAnimation* colorAnimat = [CABasicAnimation animation];
    colorAnimat.keyPath = @"backgroundColor";
    colorAnimat.fromValue = (__bridge id)[UIColor colorWithRed: 0. green: 0. blue: 1.0 alpha: .0].CGColor;
    colorAnimat.toValue =  (__bridge id)[UIColor colorWithRed: 0. green: 0. blue: 1.0 alpha: 1.0].CGColor;
    
    // create animation group
    CAAnimationGroup *groupAnimat = [CAAnimationGroup animation];
    groupAnimat.animations = @[colorAnimat, posAnimat];
    groupAnimat.duration = 1.0;
    groupAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    // custom time function
    //groupAnimat.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :.75 :1];
    groupAnimat.delegate = self;
    
    CALayer* obj = [_layers objectAtIndex:0];
    
    [obj addAnimation:groupAnimat forKey:nil];
    
    obj.position = CGPointMake(180, 180);
}

// end of test functions
//////////////////////////////////////////////////////////////////////

// animate the symbol circles expand evenly (to its current locations)
-(void)_animat_show_even
{
    if (_layers.count <= 0)
    {
        return ;
    }
    
    int i = 0;
    
    // animate circle symbols
    for (ACircleExtendBar* obj in _layers)
    {
        //////////////////////////////////////////////////////
        // anaimation for obj.symbol
        // !!! create a path from "origin" to its current location
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        
        [bezierPath moveToPoint:_origin];
        [bezierPath addLineToPoint:obj.symbolPos];
 
        // create position animation
        CAKeyframeAnimation *posAnimat = [CAKeyframeAnimation animation];
        
        posAnimat.keyPath = @"position";
        posAnimat.path = bezierPath.CGPath;
        
        // create opacity animation
        CABasicAnimation* showAnimat = [CABasicAnimation animation];

        showAnimat.keyPath = @"opacity";
        showAnimat.fromValue = [NSNumber numberWithFloat:.0];
        showAnimat.toValue = [NSNumber numberWithFloat:1.0];
        
        // attach layer symbol object id
        [showAnimat setValue:obj.symbol forKey:@"symbol"];
        // attach layer index
        [showAnimat setValue:[NSNumber numberWithInt:i] forKey:@"index"];
        
        // create animation group
        CAAnimationGroup *groupAnimat = [CAAnimationGroup animation];
        
        groupAnimat.animations = @[showAnimat, posAnimat];
        groupAnimat.duration = _durationSymbol;
        
        // time function
        groupAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //groupAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        // custom time function
        //groupAnimat.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :.75 :1];
        
        groupAnimat.beginTime = CACurrentMediaTime() + i * _delay;
        groupAnimat.delegate = self;
        groupAnimat.fillMode = kCAFillModeForwards;
        groupAnimat.removedOnCompletion = NO;
        
        // animation on APathDrawWrap
        [obj.symbol addAnimation:groupAnimat forKey:nil];
        // end of obj.symbol animation
        
        ///////////////////////////////////////////////////////////////
        // anaimation for obj.pieChart
        // create opacity animation
        CABasicAnimation* showPieAnimat = [CABasicAnimation animation];
        
        showPieAnimat.keyPath = @"opacity";
        showPieAnimat.fromValue = [NSNumber numberWithFloat:.0];
        showPieAnimat.toValue = [NSNumber numberWithFloat:1.0];
        showPieAnimat.duration = _durationPieChart;
        showPieAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        showPieAnimat.beginTime = CACurrentMediaTime() + _durationSymbol + i * _delay;
        
        showPieAnimat.fillMode = kCAFillModeForwards;
        showPieAnimat.removedOnCompletion = NO;
        showPieAnimat.delegate = self;
        
        [showPieAnimat setValue:obj.pieChart forKey:@"piechart"];
        [obj.pieChart addAnimation:showPieAnimat forKey:nil];
        
        // move onto next pie bar chart
        i++;
    }
}

// hide bars via animation
-(void)_animat_hide_even
{
    if (_layers.count <= 0)
    {
        return ;
    }
    
    int i = 0;
    
    // animate circle symbols
    for (ACircleExtendBar* obj in _layers)
    {
        //////////////////////////////////////////////////////
        // anaimation for obj.pieChart first !!! when hide
        // create opacity animation
        CABasicAnimation* showPieAnimat = [CABasicAnimation animation];
        
        showPieAnimat.keyPath = @"opacity";
        showPieAnimat.fromValue = [NSNumber numberWithFloat:1.0];
        showPieAnimat.toValue = [NSNumber numberWithFloat:.0];
        showPieAnimat.duration = _durationPieChart;
        showPieAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        showPieAnimat.beginTime = CACurrentMediaTime() + i * _delay;
        
        showPieAnimat.fillMode = kCAFillModeForwards;
        showPieAnimat.removedOnCompletion = NO;
        showPieAnimat.delegate = self;
        
        [showPieAnimat setValue:obj.pieChart forKey:@"piechart"];
        
        [obj.pieChart addAnimation:showPieAnimat forKey:nil];

        //////////////////////////////////////////////////////
        // anaimation for obj.symbol
        // !!! create a path from "origin" to its current location
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        
        [bezierPath moveToPoint:obj.symbolPos];
        [bezierPath addLineToPoint:_origin];

        // create position animation
        CAKeyframeAnimation *posAnimat = [CAKeyframeAnimation animation];
        
        posAnimat.keyPath = @"position";
        posAnimat.path = bezierPath.CGPath;
        
        // create opacity animation
        CABasicAnimation* showAnimat = [CABasicAnimation animation];
        
        showAnimat.keyPath = @"opacity";
        showAnimat.fromValue = [NSNumber numberWithFloat:1.0];
        showAnimat.toValue = [NSNumber numberWithFloat:.0];
        
        // attach layer symbol object id
        [showAnimat setValue:obj.symbol forKey:@"symbol"];
        // attach layer index
        [showAnimat setValue:[NSNumber numberWithInt:i] forKey:@"index"];
        
        // create animation group
        CAAnimationGroup *groupAnimat = [CAAnimationGroup animation];
        
        groupAnimat.animations = @[showAnimat, posAnimat];
        groupAnimat.duration = _durationSymbol;
        
        // time function
        groupAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //groupAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        // custom time function
        //groupAnimat.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :.75 :1];
        
        groupAnimat.beginTime = CACurrentMediaTime() + _durationSymbol + i * _delay;
        groupAnimat.delegate = self;
        groupAnimat.fillMode = kCAFillModeForwards;
        groupAnimat.removedOnCompletion = NO;
        
        // animation on APathDrawWrap
        [obj.symbol addAnimation:groupAnimat forKey:nil];
        // end of obj.symbol animation
        
        // move onto next pie bar chart
        i++;
    }
}

// delegate functions
-(void)animationDidStop:(id)anim finished:(BOOL)flag
{
    if ([anim isKindOfClass:[CAAnimationGroup class]])
    {
        CAAnimationGroup* animGroup = anim;
    
        NSArray* anims = animGroup.animations;
    
        for (id obj in anims)
        {
            if ([obj isKindOfClass:[CABasicAnimation class]])
            {
                CABasicAnimation* opaAnimat = obj;
            
                APathDrawWrap* symbol = [opaAnimat valueForKey:@"symbol"];
                int index = [[opaAnimat valueForKey:@"index"] integerValue];
                
                /*  no need of doing this because of using kCAFillModeForwards
                [CATransaction begin];
                [CATransaction setDisableActions:TRUE];
                
                symbol.opacity = [opaAnimat.toValue floatValue];
                
                [CATransaction commit];
                */
            }
        }
    }else if ([anim isKindOfClass:[CABasicAnimation class]])
    {
        CABasicAnimation* pieAnimat = anim;
        
        APieBarChart* pieChart = [pieAnimat valueForKey:@"piechart"];
        
        /*
        [CATransaction begin];
        [CATransaction setDisableActions:TRUE];
        
        pieChart.opacity = [pieAnimat.toValue floatValue];
        
        [CATransaction commit];
        */
    }
}

// calculate and return estimated size
-(float)estimateCircleRadius
{
    float maxLen = 0;
    
    for (ACircleExtendBar* obj in _layers)
    {
        if ((obj.pieChart.bars.metricName.attributedText.size.width + 2) > maxLen)
        {
            maxLen = obj.pieChart.bars.metricName.attributedText.size.width + 2;
        }
    }
    
    return _radius + _size + maxLen;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
