//
//  LyPlantViewController.h
//  LuckyNumbers
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYDetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
typedef enum
{
    ALL,
    ALARM,
    DANGER,
    STOPPED,
    NORMAL
} PLANT_FILTER_STATUS;

@interface LYPlantViewController : UITableViewController<EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
	long long expectedLength;
	long long currentLength;
    @public
    NSMutableArray *m_oPlantItems;
    NSMutableData *responseData;
    NSMutableArray * m_oAlarmPlants;
    NSMutableArray * m_oDangerPlants;
    NSMutableArray * m_oStopPlants;
    NSMutableArray * m_oNormalPlants;
    UIBarButtonItem * m_pButtonAll;
    UIBarButtonItem * m_pButtonDanger;
    UIBarButtonItem * m_pButtonAlarm;
    UIBarButtonItem * m_pButtonStop;
    PLANT_FILTER_STATUS m_nFilterStatus;
    int m_nllCount;
    int m_nAlarmCount;
    int m_nDangerCount;
    int m_nStopCount;
    NSMutableArray * m_pSegmentMap;
    
}
- (void)OnHudCallBack;
- (IBAction)OnRefreshButtonPressed:(id)sender;
- (IBAction)OnSearchButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_oActiveIndicator;
@property (retain, nonatomic) IBOutlet UITableView *m_oTableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void) PreparePlantsData;
@property (retain, nonatomic) NSMutableArray * m_oStopPlants;
@property (retain, nonatomic) NSMutableArray * m_oDangerPlants;
@property (retain, nonatomic) NSMutableArray * m_oAlarmPlants;
@property (retain, nonatomic) NSMutableArray * m_oNormalPlants;
@property (retain, nonatomic) NSMutableData * responseData;
@property (retain, nonatomic) NSMutableArray  * m_pSegmentMap;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_pButtonAll;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_pButtonDanger;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_pButtonAlarm;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_pButtonStop;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_pButtonNormal;
@property (retain, nonatomic) NSMutableArray * m_oPlantItems;
@end

