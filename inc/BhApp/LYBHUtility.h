//
//  LYBHUtility.h
//  bh
//
//  Created by zhaodali on 13-3-15.
//
//

#import <Foundation/Foundation.h>
#import "ChannInfo.h"
@interface LYBHUtility : NSObject
{
    
}
+ (int) GetPlantType:(int)anType;
+ (NSString *) GetPlantTypeName:(int)anType;
+(int)GetChannType:(int)anType;
+(NSString *)GetChannTypeName:(int)anType;
@end
