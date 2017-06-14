#ifndef AnnieLytics_Define_h
#define AnnieLytics_Define_h

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(degree)  ((M_PI * degree) / 180)

#define _RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// rgb
typedef struct
{
    float r;
    float g;
    float b;
    float a;
}RGB;

// structure for ring visual object layout
typedef struct
{
    float left;     // angle in degree
    float right;    // angle in degree
    float top;      // radius
    float bottom;   // radius
}Slice;

// Background style
typedef enum
{
    BackgroudStyle_None,            // no background filling
    BackgroudStyle_Color_Fill,      // fill with color
    BackgroudStyle_Color_Gradient   // gradient color fill
}BackgroudStyle;

// slider bar position
typedef enum
{
    BarPosition_None    = 1,        // no slider bar
    BarPosition_LT,                 // left or top
    BarPosition_RB                  // right or bottom
}BarPosition;

// tree ring map object types
typedef enum
{
    TRObjs_None     = 1,            // none
    TRObjs_Arrows_Begin,            // begin splitter arrow
    TRObjs_Arrows_End,              // end splitter arrow
    TRObjs_ColumnBar,               // column slider bar for columns distribution
    TRObjs_Cell,                    // cell on the grid
    TRObjs_Column,                  // column
    TRObjs_Column_Line,             // column grid line
    TRObjs_Column_Axis,             // colmn axis
    TRObjs_Column_Axis_Label,       // column axis label
    TRObjs_RowBar,                  // row slider bar for row distribution
    TRObjs_Row,                     // row
    TRObjs_Row_Line,                // row grid line
    TRObjs_Row_Axis,                // row axis
    TRObjs_Row_Axis_Label           // row axis lable
}TRObjs;

// tree ring hit test result
typedef struct
{
    TRObjs hitObject;               // type of object being hit
    NSInteger sliceIndex;           // tree ring slice index
    NSInteger col;                  // cell column index
    NSInteger row;                  // cell row index
}HitObj;

// chord graph hit test result
// structure for chord graph objects used for hit test
typedef enum
{
    CDObjs_None     = 1,
    CDObjs_Title,                   // ring slice title (ring index, slice index)
    CDObjs_Axis,                    // axis label (ring index, slice index, label index)
    CDObjs_Ring,                    // ring index
    CDObjs_Slice,                   // ring slice (ring index, slice index)
    CDObjs_Cell,                    // ring index, slice index and cell index
    CDObjs_Cnn                      // connector (CDConnection*)
}CDObjs;

// structure for saving hitting object information
typedef struct
{
    CDObjs hitObject;
    NSInteger ringIndex;
    NSInteger sliceIndex;
    NSInteger cellIndex;
    void* pcnn;
}HitCDObj;

// tick position distribution style
typedef enum
{
    AxisTickStyle_Even  = 1,        // even distribution
    AxisTickStyle_Linear_MinMax,    // the intervals between positions change linearly for the given slope
    AxisTickStyle_Linear_MaxMin 
}AxisTickStyle;

// cell drawing style
typedef enum
{
    CellValueShow_None  = 1,        // do not display
    CellValueShow_Flat,             // flat display
    CellValueShow_Flat_Gradient,    // flat gradient display
    CellValueShow_3D                // 3D style
}CellValueShow;

// cell visual shape if draw with image in memroy
typedef enum
{
    CellValueShape_None = 1,        // no show
    CellValueShape_Dot,             // dot
    CellValueShape_Cross,           // cross
    CellValueShape_Circle,          // circle
    CellValueShape_Image            // look up in predefined image list
}CellValueShape;

// slice border style
typedef enum
{
    SliceBorder_None    = 1,        // no border line
    SliceBorder_Line,               // thin line goes with "curcle" bar only
    SliceBorder_Solid,              // solid line with specified width
    SliceBorder_Dash,               // dashed line
    SliceBorder_Pops,               // pops out
    SliceBorder_Metal               // metal like 
}SliceBorder;

// grid line style
typedef enum
{
    GridLine_None       = 1,        // no grid line
    GridLine_Solid,                 // solid line
    GridLine_Dash,                  // dash line
    GridLine_Neon                   // neon light style
}GridLine;

// tick label oroentation
typedef enum
{
    TickLableOrientation_0  = 1,    // show label horizantal
    TickLableOrientation_90,        // show label vertical
    TickLableOrientation_Radius,    // show lable along the radius direction
    TickLableOrientation_Angle      // dynamicly decide on the right angle
}TickLableOrientation;

// slice angle size style
typedef enum
{
    SliceSize_Fixed     = 1,        // fixed angle size
    SliceSize_Auto                  // automatic resize up to the allowed maximum size
}SliceSize;

// drawing style for highlighted state
typedef enum
{
    HighLightStyle_Fill     = 1,
    HighLightStyle_Gradient
}HighLightStyle;

#endif
