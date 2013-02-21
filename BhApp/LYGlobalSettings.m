//
//  LYGlobalSettings.m
//  bh
//
//  Created by zhaodali on 13-2-21.
//
//

#import "LYGlobalSettings.h"

@implementation LYGlobalSettings


static NSMutableDictionary * g_pSettingsDic = nil;
+ (void)InitSetting
{
    @synchronized(self)
    {
        if (nil == g_pSettingsDic) {
            g_pSettingsDic = [[NSMutableDictionary alloc] init];
            [LYGlobalSettings initDict];
        }    

    }
   
}

+(NSString *) GetSetting:(NSString *) apKey
{
    NSString * lpRetValue = nil;
    if (nil!= apKey)
    {
        @synchronized(self)
        {
            if (nil == g_pSettingsDic) {
                [LYGlobalSettings InitSetting];
            }
            id lpDataInDic = [g_pSettingsDic objectForKey:apKey];
            if (nil != lpDataInDic && ([lpDataInDic isKindOfClass :[NSString class]]))
            {
                lpRetValue = [NSString stringWithFormat:@"%@",(NSString *)lpDataInDic];
            }
        }
    }
    
    if (nil ==lpRetValue) {
        lpRetValue = [NSString stringWithFormat:@""];
    }
    return  lpRetValue;
}
+ (void) initDict
{
    [g_pSettingsDic setObject:@"http://bhxz808.3322.org:8090" forKey:(SETTING_KEY_SERVER_ADDRESS)];
    [g_pSettingsDic setObject:@"222.199.224.145" forKey:(SETTING_KEY_MIDDLE_WARE_IP)];
    [g_pSettingsDic setObject:@"7005" forKey:(SETTING_KEY_MIDDLE_WARE_PORT)];
    [g_pSettingsDic setObject:@"" forKey:(SETTING_KEY_USER)];
    [g_pSettingsDic setObject:@"" forKey:(SETTING_KEY_PASSWORD)];
    [g_pSettingsDic setObject:@"1" forKey:(SETTING_KEY_SERVERTYPE)];
}
- (id)init
{
    self = [super init];
   
    return self;
}
+ (NSString *) GetPostDataPrefix
{
 
    NSString * lpPostDataPreFix = [NSString stringWithFormat:@"MIDDLE_WARE_IP=%@&MIDDLE_WARE_PORT=%@&SERVER_TYPE=%@&operator=%@&password=%@",[LYGlobalSettings GetSetting:SETTING_KEY_MIDDLE_WARE_IP ],[LYGlobalSettings GetSetting:SETTING_KEY_MIDDLE_WARE_PORT],[LYGlobalSettings GetSetting:SETTING_KEY_SERVERTYPE],[LYGlobalSettings GetSetting:SETTING_KEY_USER],[LYGlobalSettings GetSetting:SETTING_KEY_PASSWORD]];
    return lpPostDataPreFix;
}
@end
