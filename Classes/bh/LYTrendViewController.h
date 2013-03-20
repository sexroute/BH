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

@interface LYTrendViewController : UIViewController
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property ( nonatomic) int m_nChannType;
@property (strong,nonatomic) Chart * candleChart;
@property (nonatomic) int chartMode;

@end
