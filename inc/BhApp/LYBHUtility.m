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
+(int)GetChannType:(int)anType
{
    switch(anType)
	{
        case GE_ALLPROC:
        case GE_PRESSCHANN:
        case GE_TEMPCHANN:
        case GE_FLUXCHANN:
        case GE_OTHERCHANN:
        case GE_IMPACTCHANN:
            return E_TBL_CHANNTYPE_PROC;
        case GE_VIBCHANN:
        case GE_AXIALCHANN:
        case GE_AXISLOCATIONCHANN:
            return E_TBL_CHANNTYPE_VIB;
        case GE_DYNPRESSCHANN:
        case GE_RODSINKCHANN:
        case GE_DYNSTRESSCHANN:
            return E_TBL_CHANNTYPE_DYN;
        default:
            return E_TBL_CHANNTYPE_VIB;
	};
}
+(NSString *)GetChannTypeName:(int)anType
{
    int lnChannType = [LYBHUtility GetChannType:anType];
    NSString * lpRet = @"";
    switch (lnChannType)
    {
        case E_TBL_CHANNTYPE_PROC:
            lpRet = CHANN_TYPE_PROC;
            break;
        case E_TBL_CHANNTYPE_VIB:
            lpRet = CHANN_TYPE_VIB;
            break;
        case E_TBL_CHANNTYPE_DYN:
            lpRet = CHANN_TYPE_DYN;
            break;

        default:
            break;
    }
    
    return  [lpRet autorelease];
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
