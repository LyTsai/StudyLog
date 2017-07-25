//
//  ANVLUserInfo.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLUserInfo.h"

@implementation ANVLUserInfo

-(NODECLASS)type
{
    return NODECLASS_USERINFO;
}

// methods
-(id)initWithInfo:(NSString*)name
          contact:(NSDictionary*)contact
         personal:(NSDictionary*) personal
{
    if (self == nil)
    {
        self = [super init];
    }
    
    _name = name;
    _contact = contact;
    _personal = personal;
    
    return self;
}

@end
