//
//  LYDiagViewController.h
//  bh
//
//  Created by zhaodali on 13-3-27.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LYGlobalSettings.h"
#import "JSON.h"


@interface LYDiagViewController : UITableViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrSet;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (nonatomic) int m_nPlantType;
@property (retain, nonatomic) NSString * m_pStrTimeStart;
@property  (retain, nonatomic) NSMutableData      *m_oResponseData;
@property  (retain, nonatomic) NSMutableDictionary *listOfItems;


@end
