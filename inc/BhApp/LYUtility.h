//
//  LYUtility.h
//  bh
//
//  Created by zhaodali on 13-3-13.
//
//

#import <Foundation/Foundation.h>

@interface LYUtility : NSObject
+ (BOOL)IsStringEmpty:(NSString *) apStr;
+ (NSString *)StringTrim:(NSString *)apStr;
#define IS_RETINA       ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))

@end
