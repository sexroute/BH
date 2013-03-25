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
	GE_LAST_HALF_HOUR           = 1,
	GE_LAST_ONE_HOUR            = 2,
	GE_LAST_WEEK                = 3,
	GE_LAST_MONTH               = 4,
	GE_LAST_YEAR                = 5,
    
};
@interface LYUtility : NSObject
+ (BOOL)IsStringEmpty:(NSString *) apStr;
+ (NSString *)StringTrim:(NSString *)apStr;
#define IS_RETINA       ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))
+(NSString *)GetDateFormat:(NSDate *)apDate;
+(NSString *)GetRequestDate:(int) anType apDate:(NSDate *)apDate;

@end
