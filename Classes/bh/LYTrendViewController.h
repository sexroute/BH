//
//  LYTrendViewController.h
//  bh
//
//  Created by zhaodali on 13-3-15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Chart.h"
#import "MBProgressHUD.h"
#import "NVUIGradientButton.h"
#import "MGTileMenuController.h"
#import "ASIFormDataRequest.h"

@interface LYTrendViewController : UIViewController<MBProgressHUDDelegate,UIPickerViewDelegate ,UIPickerViewDataSource,MGTileMenuDelegate, UIGestureRecognizerDelegate>
{
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property ( nonatomic) int m_nChannType;
@property (strong,nonatomic) Chart * m_oChart;
@property (nonatomic) int chartMode;
@property  (retain, nonatomic) NSMutableData      *m_oResponseData;
@property  (retain, nonatomic) NSMutableArray *listOfItems;
@property (retain, nonatomic) NSString * m_pStrChannUnit;
@property (nonatomic) int m_nPlantType;

@property ( nonatomic) float m_fHH;
@property ( nonatomic) float m_fHL;
@property ( nonatomic) float m_fLL;
@property ( nonatomic) float m_fLH;
@property ( nonatomic) int m_nAlarmJudgetType;
@property (nonatomic)  int m_nTimespanType;
@property (retain, nonatomic) UIPickerView * m_oPickerView;
@property (retain, nonatomic) NVUIGradientButton * m_oDataConfirmButton;
@property (retain, nonatomic) NVUIGradientButton * m_oTitleButton;
@property (retain, nonatomic) NSMutableDictionary * m_pChannInfo;
@property (retain, nonatomic) MGTileMenuController *tileController;
@property (retain,nonatomic) ASIFormDataRequest * m_oRequest;
@end
