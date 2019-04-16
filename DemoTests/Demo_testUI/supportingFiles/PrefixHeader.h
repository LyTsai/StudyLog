//
//  PrefixHeader.pch
//  Created by LyTsai on 2018/2/25.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

#ifndef PrefixHeader_pch
#define PrefixHeader_pch

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

/* Add:
 1. for OC:
 targets -> Build Settings -> search for "Prefix Header", input the full path
 2. for Swift: after 1, change the file to .h, and
 targets -> Build Settings -> search for "Bridging Header", input the full path
 */

#import <UIKit/UIKit.h>

#endif /* PrefixHeader_pch */
