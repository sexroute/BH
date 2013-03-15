//
//  LYWaveViewController.h
//  bh
//
//  Created by zhao on 12-8-5.
//
//
#import "LYChartView.h"
#import <UIKit/UIKit.h>

@interface LYWaveViewController : UIViewController<MBProgressHUDDelegate>
{
    NSString * m_pStrGroup;
    NSString * m_pStrCompany;
    NSString * m_pStrFactory;
    NSString * m_pStrChann;
    NSString * m_pStrPlant;
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
@property (retain, nonatomic) IBOutlet UIToolbar *m_oToolbar;
@property (retain, nonatomic) NSString * m_pStrPlant;
@end
