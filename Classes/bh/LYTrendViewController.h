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

@interface LYTrendViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property ( nonatomic) int m_nChannType;
@property (strong,nonatomic) Chart * candleChart;
@property (nonatomic) int chartMode;
@property  (retain, nonatomic) NSMutableData      *m_oResponseData;
@property  (retain, nonatomic) NSMutableArray *listOfItems;
@property (retain, nonatomic) NSString * m_pStrChannUnit;
@property ( nonatomic) float m_fHH;
@property ( nonatomic) float m_fHL;
@property ( nonatomic) float m_fLL;
@property ( nonatomic) float m_fLH;
@end
