//
//  LYChannViewController.h
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "ChannInfo.h"
#import "MBProgressHUD.h"

@interface LYChannViewController : UITableViewController<MBProgressHUDDelegate>
{
    NSString * m_pStrGroup;
    NSString * m_pStrCompany;
    NSString * m_pStrFactory;
    NSString * m_pStrSet;
    NSString * m_pStrPlant;
    NSMutableData * m_pResponseData;
    NSMutableArray *m_pAllChannInfos;
    NSMutableArray *VibChanns;
    NSMutableArray *DynChanns;
    NSMutableArray *ProcChanns;
    MBProgressHUD *HUD;
    
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_pProgressBar;
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrSet;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property (retain, nonatomic) NSMutableArray * VibChanns;
@property (retain, nonatomic) NSMutableArray * DynChanns;
@property (retain, nonatomic) NSMutableArray * ProcChanns;
@property (retain,nonatomic)  NSMutableData * m_pResponseData;
@property  (retain,nonatomic) NSMutableArray * m_pAllChannInfos;
@property (nonatomic) int m_nPlantType;
@property (retain, nonatomic) NSString * m_pStrTimeStart;
@property (retain, nonatomic) NSString * m_strChannDiaged;

@end
