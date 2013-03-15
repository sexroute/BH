//
//  ChannInfo.h
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#ifndef bh_ChannInfo_h
#define bh_ChannInfo_h

enum CHANNTYPE
{
	GE_ALLPROC          = 0,        /*!所有过程量测点*/
	GE_VIBCHANN         = 1,        /*!径向振动测点.*/
	GE_AXIALCHANN       = 2,        /*!轴向振动测点.axial displacement*/
	GE_PRESSCHANN       = 3,        /*!压力测点.*/
	GE_TEMPCHANN        = 4,        /*!温度测点.*/
	GE_FLUXCHANN        = 5,        /*!流量测点.*/
	GE_OTHERCHANN       = 6,        /*!其它.*/
	GE_IMPACTCHANN      = 7,        ///撞击通道
	GE_CURRENTCHANN     = 8,        ///电流测点
	GE_DYNPRESSCHANN    = 11,       ///动态压力信号
	GE_RODSINKCHANN     = 12,       ///活塞杆下沉量信号
	GE_DYNSTRESSCHANN   = 13,       /* !动态应力测点*/
	GE_AXISLOCATIONCHANN= 100       /*!轴心位置*/
};

///测点通道的大类。是振动，过程量，动态测点
enum E_TBL_CHANNTYPE
{
	E_TBL_CHANNTYPE_VIB=0,         ///振动通道。“VIB”
	E_TBL_CHANNTYPE_PROC,          ///过程量通道。“PROC”
	E_TBL_CHANNTYPE_DYN            ///动态测点通道。“DYN”
};

#define CHANN_TYPE_VIB @"振动测点"
#define CHANN_TYPE_DYN @"动态测点"
#define CHANN_TYPE_PROC @"过程量测点"


enum MACHINETYPE
{
	GE_MACHINETYPE_COMPR=0,    ///离心压缩机compressor
	GE_MACHINETYPE_FAN,        ///风机fan
	GE_MACHINETYPE_TURB,       ///汽轮机turbine
	GE_MACHINETYPE_PUMP,       ///离心泵pump
	GE_MACHINETYPE_COMPR1,     ///轴流式压缩机或轴流+离心压缩机
	GE_MACHINETYPE_OTHERS,     ///其他
	GE_MACHINETYPE_RC,         ///往复式压缩机 reciprocating compressor
	GE_MACHINETYPE_KEYPUMP,    ///关键机泵
	GE_MACHINETYPE_WINDPEQ,    ///风电设备
	GE_MACHINETYPE_SMOKESTEAM  ///烟汽轮机
};

enum MACHINETYPE_GENERIC
{
    MACHINE_TYPE_ROTATION_GENERIC = 0,
    MACHINE_TYPE_RC_GENERIC,
    MACHINE_TYPE_PUMP_GENERIC,
    MACHINE_TYPE_WIND_GENERIC
};

#define MACHINE_TYPE_ROTATION @"旋转"
#define MACHINE_TYPE_RC @"往复"
#define MACHINE_TYPE_PUMP @"机泵"
#define MACHINE_TYPE_WIND @"风电"

#endif
