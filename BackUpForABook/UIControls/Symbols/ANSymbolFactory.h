//
//  ANSymbolFactory.h
//  NodeGraph
//
//  Created by hui wang on 11/19/16.
//  Copyright © 2016 hui wang. All rights reserved.
//

#ifndef ANSymbolFactory_h
#define ANSymbolFactory_h

#import "ANSymbolFactory.h"
#import "APathDrawWrap.h"
#import "APageLayerPath.h"

APathDrawWrap* createSymbol(NSString* type, BOOL edge);

////////////////////////////////////////////////////////
// APageLayerPath type symbol (image) path
////////////////////////////////////////////////////////
typedef enum
{
    SYMBOLPATH_NULL,                    // NA
    
    SYMBOLPATH_BACKGROUND,              // background only.  no image
    
    SYMBOLPATH_FACE1,                   // little face, green
    SYMBOLPATH_FACE2,                   // little face yellow, ok, medium
    SYMBOLPATH_FACE3,
    SYMBOLPATH_FACE4,                   //
    SYMBOLPATH_FACE5,                   // little face, red and sick
    
    SYMBOLPATH_LIFESTYLE_EXERCISE,
    SYMBOLPATH_LIFESTYLE_DIET,
    SYMBOLPATH_LIFESTYLE_WELLNESS,
    
    SYMBOLPATH_SLEEPS_ENOUGH,
    SYMBOLPATH_SLEEPS_WELL,
    SYMBOLPATH_STRESS,
    SYMBOLPATH_ALCOHOL,
    SYMBOLPATH_ALZHEIMERS,
    SYMBOLPATH_ASPIRIN,
    SYMBOLPATH_BERRIES,
    SYMBOLPATH_EXERCISE,
    SYMBOLPATH_FISH,
    SYMBOLPATH_FISHOIL,
    SYMBOLPATH_FOLICACID,
    SYMBOLPATH_MANAGEWEIGHTS,
    SYMBOLPATH_MEDIATE,
    SYMBOLPATH_MEMORY,
    SYMBOLPATH_SLIMDOWNWAIST,
    SYMBOLPATH_SMOKING,
    SYMBOLPATH_SUPPORT,
    SYMBOLPATH_VEGETABLES
    
}SYMBOLPATH;

APageLayerPath* createSymbolLayerPath(SYMBOLPATH type);

APageLayerPath* getRandomSymbolPath();
APageLayerPath* getRandomSymbolPath_Face();

#endif /* ANSymbolFactory_h */