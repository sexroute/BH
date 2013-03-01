//
//  LYGlobalSettings.m
//  bh
//
//  Created by zhaodali on 13-2-21.
//
//

#import "LYGlobalSettings.h"

@implementation LYGlobalSettings

static sqlite3 *contactDB = nil;
static NSMutableDictionary * g_pSettingsDic = nil;
static NSArray *dirPaths = nil;
static NSString *docsDir = nil;
static NSString * databasePath = nil;
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

+ (void)InitDatabase
{
      
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SETTING(ID TEXT PRIMARY KEY , VAL TEXT)";
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
                NSLog(@"创建表失败\n");
            }
            
            sqlite3_close(contactDB);
        }
        else
        {
            NSLog(@"创建/打开数据库失败"); ;
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
    @synchronized(self)
    {
        
      [LYGlobalSettings InitDatabase];
      [g_pSettingsDic setObject:@"http://bhxz808.3322.org:8090" forKey:(SETTING_KEY_SERVER_ADDRESS)];
      [g_pSettingsDic setObject:@"222.199.224.145" forKey:(SETTING_KEY_MIDDLE_WARE_IP)];
      [g_pSettingsDic setObject:@"7005" forKey:(SETTING_KEY_MIDDLE_WARE_PORT)];

      [g_pSettingsDic setObject:@"http://192.168.12.100:8080" forKey:(SETTING_KEY_SERVER_ADDRESS)];
      [g_pSettingsDic setObject:@"192.168.123.213" forKey:(SETTING_KEY_MIDDLE_WARE_IP)];
      [g_pSettingsDic setObject:@"7001" forKey:(SETTING_KEY_MIDDLE_WARE_PORT)];
    
    
      [g_pSettingsDic setObject:@"" forKey:(SETTING_KEY_USER)];
      [g_pSettingsDic setObject:@"" forKey:(SETTING_KEY_PASSWORD)];
      [g_pSettingsDic setObject:@"1" forKey:(SETTING_KEY_SERVERTYPE)];
    }
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
