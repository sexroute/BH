//
//  LYWaveViewController.h
//  bh
//
//  Created by zhao on 12-8-5.
//
//
#import "LYChartView.h"
#import "LYTrendViewController.h"
#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@interface LYWaveViewController : UIViewController<MBProgressHUDDelegate>
{
    NSString * m_pStrGroup;
    NSString * m_pStrCompany;
    NSString * m_pStrFactory;
    NSString * m_pStrChann;
    NSString * m_pStrPlant;
    NSString * m_pStrChannUnit;
    MBProgressHUD *HUD;
    
}


@property (retain, nonatomic) IBOutlet UIView *m_plotView;


@property (retain, nonatomic)
  LYChartView  *hostView;
@property (retain, nonatomic) IBOutlet UIView *m_pChartViewParent;
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (retain, nonatomic) NSString * m_pStrChannUnit;
- (IBAction)onTrendButtonPressed:(UIBarButtonItem *)sender;
@property (retain, nonatomic) IBOutlet UIToolbar *m_oToolbar;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_oButtonFreq;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_oButtonWave;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_oButtonFresh;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_oButtonTrend;
@property (retain, nonatomic) NSMutableDictionary * m_pChannInfo;
@property ( nonatomic) int m_nChannType;
@property ( nonatomic) float m_fHH;
@property ( nonatomic) float m_fHL;
@property ( nonatomic) float m_fLL;
@property ( nonatomic) float m_fLH;
@property ( nonatomic) int m_nAlarmJudgetType;
@property (nonatomic) int m_nRequestType;
@property (nonatomic) DrawMode m_nDrawMode;
@property (nonatomic) int m_nPlantType;
@property (nonatomic,retain) NSString * m_strHistoryDateTime;
@property (retain,nonatomic) ASIFormDataRequest * m_oRequest;
@end
