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
 
 "a prefix header file
 导入多次使用的头文件

 路径：（可以在左侧的list中看到名字，上面到项目名，或者$(SRCROOT)/项目名/…"    "创建PCH file类型文件（Other里），输入#import 头文件或框架
 添加：targets的Build Settings中，搜索Prefix Header，双击在出现的框中输入pch文件的路径）。编译之后，系统在每个类中都自动导入了文件。
 —————————— OC到此就好了——————————
 在Swift中，需要桥接。把文件后缀改成.h，修改对应路径，Build Settings里搜索Bridging Header然后输入路径。
 "
 */

#import <UIKit/UIKit.h>

#endif /* PrefixHeader_pch */
