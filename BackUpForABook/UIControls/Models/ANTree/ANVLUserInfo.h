//
//  ANVLUserInfo.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLNode.h"

@interface ANVLUserInfo : ANVLNode

// properties
@property(strong, nonatomic)NSString* name;
@property(strong, nonatomic)NSDictionary* contact;
@property(strong, nonatomic)NSDictionary* personal;

// methods
-(id)initWithInfo:(NSString*)name
          contact:(NSDictionary*)contact
         personal:(NSDictionary*) personal;

@end
