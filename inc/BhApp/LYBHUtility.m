//
//  LYBHUtility.m
//  bh
//
//  Created by zhaodali on 13-3-15.
//
//

#import "LYBHUtility.h"

@implementation LYBHUtility
+ (int) GetPlantType:(int)anType
{
    int lnMachine_Type = MACHINE_TYPE_ROTATION_GENERIC;
    switch (anType)
    {
        case GE_MACHINETYPE_COMPR:
        case GE_MACHINETYPE_FAN:
        case GE_MACHINETYPE_TURB:
        case GE_MACHINETYPE_COMPR1:
        case GE_MACHINETYPE_OTHERS:
        case GE_MACHINETYPE_SMOKESTEAM:
            lnMachine_Type = MACHINE_TYPE_ROTATION_GENERIC;
            break;
        case GE_MACHINETYPE_RC:
            lnMachine_Type = MACHINE_TYPE_RC_GENERIC;
            break;
        case GE_MACHINETYPE_KEYPUMP:
        case GE_MACHINETYPE_PUMP:
            lnMachine_Type = MACHINE_TYPE_PUMP_GENERIC;
            break;
        case GE_MACHINETYPE_WINDPEQ:
            lnMachine_Type = MACHINE_TYPE_WIND_GENERIC;
            break;
        default:
            break;
    }
    
    return lnMachine_Type;
}

+ (NSString *) GetPlantTypeName:(int)anType
{
    NSString * lpPlantType = nil;
    int lnPlantType = [LYBHUtility GetPlantType:anType];
    switch (lnPlantType)
    {
        case MACHINE_TYPE_ROTATION_GENERIC:
            lpPlantType = MACHINE_TYPE_ROTATION;
            break;
        case MACHINE_TYPE_RC_GENERIC:
            lpPlantType = MACHINE_TYPE_RC;
            break;
        case MACHINE_TYPE_PUMP_GENERIC:
            lpPlantType = MACHINE_TYPE_PUMP;
            break;
        case MACHINE_TYPE_WIND_GENERIC:
            lpPlantType = MACHINE_TYPE_WIND;
            break;
        default:
            break;
    }
    
    return [lpPlantType autorelease];
}
@end
