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
    if ((nil!=apStr) || ([[apStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0))
    {
        return YES;
    }
    
    return NO;
    
}
@end
