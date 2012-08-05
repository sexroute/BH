//
//  LYWaveViewController.h
//  bh
//
//  Created by zhao on 12-8-5.
//
//
#import "LYChartView.h"
#import <UIKit/UIKit.h>

@interface LYWaveViewController : UIViewController
{
    
}

@property (retain, nonatomic)
  LYChartView  *hostView;
@property (retain, nonatomic) IBOutlet UIView *m_pChartViewParent;
@end
