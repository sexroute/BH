//
//  LYUtility.m
//  bh
//
//  Created by zhaodali on 13-3-13.
//
//

#import "LYUtility.h"

@implementation LYUtility
+(BOOL) IsStringEmpty:(NSString *)apStr
{
    if ((nil==apStr) || ([[apStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0))
    {
        return YES;
    }
    
    return NO;
    
}

+ (NSString *)StringTrim:(NSString *)apStr
{
    if (nil== apStr || !([apStr isKindOfClass:[NSString class]]))
    {
        return apStr;
    }
    
    NSString * lpStr = [[apStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]copy];
    
    return  [lpStr autorelease];
    
}

+(NSString *) GetDateFormat:(NSDate *)apDate
{
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'" options:0 locale:nil];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    NSDate * lpDate = apDate;
    if (nil == lpDate)
    {
        lpDate = [NSDate date];
    }
    NSString * lpDateStr = [formatter stringFromDate:lpDate];
    
    return lpDateStr;
}
+(NSString *)GetRequestDate:(int) anType apDate:(NSDate *)apDate
{
    NSDate * lpDate = apDate;
    if (nil == lpDate)
    {
        lpDate = [NSDate date];
    }
    NSDate * lpDateRet = nil;
    switch (anType) {
        case GE_LAST_FIVE_MINUTES:
            lpDateRet = [NSDate dateWithTimeInterval:-5*60 sinceDate:lpDate];
            break;
        case GE_LAST_HALF_HOUR:
            lpDateRet = [NSDate dateWithTimeInterval:-30*60 sinceDate:lpDate];
            break;
        case GE_LAST_ONE_HOUR:
            lpDateRet = [NSDate dateWithTimeInterval:-60*60 sinceDate:lpDate];
            break;
        case GE_LAST_WEEK:
            lpDateRet = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_MONTH:
            lpDateRet = [NSDate dateWithTimeInterval:183*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_YEAR:
            lpDateRet = [NSDate dateWithTimeInterval:365*24*60*60 sinceDate:lpDate];
            break;
        default:
            break;
    }
    
    NSString *lpRet = [LYUtility GetDateFormat:lpDateRet];
    return lpRet;
}
@end
