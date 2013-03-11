//
//  LYGlobalSettings.h
//  bh
//
//  Created by zhaodali on 13-2-21.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface LYGlobalSettings : NSObject

+ (NSString *) GetSetting:(NSString *) apKey;
+(BOOL) SetSetting:(NSString*)apKey apVal:(NSString*)apVal;
+ (NSString *) GetPostDataPrefix;
@end

#ifndef __SETTING_KEY__
#define __SETTING_KEY__
#define SETTING_KEY_SERVER_ADDRESS @"SERVER_ADDRESS"
#define SETTING_KEY_MIDDLE_WARE_IP @"MIDDLEWARE_IP"
#define SETTING_KEY_MIDDLE_WARE_PORT @"MIDDLEWARE_PORT"
#define SETTING_KEY_USER             @"USERNAME"
#define SETTING_KEY_PASSWORD         @"PASSWORD"
#define SETTING_KEY_SERVERTYPE       @"SERVER_TYPE"
#define SETTING_KEY_LOGIN            @"LOGIN"
#endif