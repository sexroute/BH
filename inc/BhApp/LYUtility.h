//
//  LYUtility.h
//  bh
//
//  Created by zhaodali on 13-3-13.
//
//

#import <Foundation/Foundation.h>

enum TIME_TYPE
{
	GE_LAST_FIVE_MINUTES        = 0,
	GE_LAST_HALF_HOUR           ,
	GE_LAST_ONE_HOUR            ,
    GE_LAST_DAY                 ,
	GE_LAST_WEEK                ,
    GE_LAST_HALF_MONTH          ,
	GE_LAST_MONTH               ,
    GE_LAST_3_MONTH             ,
    GE_LAST_HALF_YEAR           ,
	GE_LAST_YEAR                ,
    GE_LAST_3_YEAR              ,
    GE_LAST_SAME                ,
    
};
@interface LYUtility : NSObject
+ (BOOL)IsStringEmpty:(NSString *) apStr;
+ (NSString *)StringTrim:(NSString *)apStr;
#define IS_RETINA       ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))
+(NSString *)GetRequestDate:(NSDate *)apDate;
+(NSString *)GetRequestDate:(int) anType apDate:(NSDate *)apDate;
+(NSString *)GetRequestDateByString:(int) anType apDate:(NSString *)apDate;

@end
