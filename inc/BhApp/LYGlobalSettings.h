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

+ (NSString *) GetSettingString:(NSString *) apKey;
+ (NSString *) GetSettingString:(NSString *) apKey apStrDefault:(NSString *) apStrDefault;
+(BOOL) SetSettingString:(NSString*)apKey apVal:(NSString*)apVal;

+ (int) GetSettingInt:(NSString *) apKey;
+ (int) GetSettingInt:(NSString *) apKey anDefault:(int) anDefault;
+(BOOL) SetSettingInt:(NSString*)apKey apVal:(int)anVal;

+ (double) GetSettingDouble:(NSString *) apKey;
+ (double) GetSettingDouble:(NSString *) apKey adblDefault:(double) adblDefault;
+(BOOL) SetSettingDouble:(NSString*)apKey apVal:(double)adblVal;

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
#define SETTING_KEY_SELECTED_GROUP        @"SELECTED_GROUP"
#define SETTING_KEY_SELECTED_COMPANY      @"SELECTED_COMPANY"
#define SETTING_KEY_SELECTED_FACTORY      @"SELECTED_FACTORY"
#define SETTING_KEY_SELECTED_SET          @"SELECTED_SET"
#define SETTING_KEY_SELECTED_PLANT_TYPE          @"SELECTED_PLANT_TYPE"
#define SETTING_KEY_STYLE                 @"STYLE"

#pragma mark 诊断相关
#define SETTING_DEAULT_FAULT @"对中不良"
#define SETTING_KEY_FAULT @"faults"
#define SETTING_KEY_ADVICE @"advice"

#define NETWORK_TIMEOUT 10
#endif
