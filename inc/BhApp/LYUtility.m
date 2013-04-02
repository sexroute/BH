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

+(NSString *)GetRequestDateByString:(int) anType apDate:(NSString *)apDate
{
    NSDate * lpDate = nil;
    if (nil== apDate || !([apDate isKindOfClass:[NSString class]]))
    {
        lpDate = [NSDate date];
    }else
    {
        NSDateFormatter *df = [[[NSDateFormatter alloc] init]autorelease];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        lpDate = [df dateFromString: apDate];
    }
    
    return [LYUtility GetRequestDate:anType apDate:lpDate];
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

+(NSString *) GetRequestDate:(NSDate *)apDate
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
+(NSString *)GetRequestStr:(int) anType
{
    NSString * lpDate = nil;
    switch (anType) {
        case GE_LAST_FIVE_MINUTES:
            lpDate = [NSString stringWithFormat:@"前五分钟"];
            break;
        case GE_LAST_HALF_HOUR:
            lpDate = [NSString stringWithFormat:@"前半小时"];
            break;
        case GE_LAST_ONE_HOUR:
            lpDate = [NSString stringWithFormat:@"前一小时"];
            break;
        case GE_LAST_DAY:
            lpDate = [NSString stringWithFormat:@"前一天"];
            break;
        case GE_LAST_WEEK:
            lpDate = [NSString stringWithFormat:@"前一周"];
            break;
        case GE_LAST_HALF_MONTH:
            lpDate = [NSString stringWithFormat:@"前半个月"];
            break;
        case GE_LAST_MONTH:
           lpDate = [NSString stringWithFormat:@"前1个月"];
            break;
        case GE_LAST_3_MONTH:
            lpDate = [NSString stringWithFormat:@"前3个月"];
            break;
        case GE_LAST_HALF_YEAR:
            lpDate = [NSString stringWithFormat:@"前半年"];
            break;
        case GE_LAST_YEAR:
            lpDate = [NSString stringWithFormat:@"前1年"];
            break;
        case GE_LAST_3_YEAR:
            lpDate = [NSString stringWithFormat:@"前3年"];
            break;
        default:
            lpDate = [NSString stringWithFormat:@"前一周"];
  
            break;
    }
    return lpDate;
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
        case GE_LAST_DAY:
            lpDateRet = [NSDate dateWithTimeInterval:-1*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_WEEK:
            lpDateRet = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_HALF_MONTH:
            lpDateRet = [NSDate dateWithTimeInterval:-15*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_MONTH:
            lpDateRet = [NSDate dateWithTimeInterval:-30*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_3_MONTH:
            lpDateRet = [NSDate dateWithTimeInterval:-123*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_HALF_YEAR:
            lpDateRet = [NSDate dateWithTimeInterval:-183*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_YEAR:
            lpDateRet = [NSDate dateWithTimeInterval:-365*24*60*60 sinceDate:lpDate];
            break;
        case GE_LAST_3_YEAR:
            lpDateRet = [NSDate dateWithTimeInterval:-3*365*24*60*60 sinceDate:lpDate];
            break;
        default:
            lpDateRet = lpDate;
            break;
    }
    
    NSString *lpRet = [LYUtility GetRequestDate:lpDateRet];
    return lpRet;
}
@end
