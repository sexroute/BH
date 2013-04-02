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

//报警判断方式：低通、高通、带通、带阻
enum E_ALARMCHECK_TYPE
{
    E_ALARMCHECK_LOWPASS=0,
    E_ALARMCHECK_HIGHPASS,
    E_ALARMCHECK_BANDPASS,
    E_ALARMCHECK_BANDSTOP
};
@end
