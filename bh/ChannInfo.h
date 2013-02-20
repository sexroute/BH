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

#endif
