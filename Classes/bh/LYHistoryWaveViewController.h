//
//  LYHistoryWaveViewController.h
//  bh
//
//  Created by zhao on 13-4-4.
//
//
#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import <UIKit/UIKit.h>

@interface LYHistoryWaveViewController : UIViewController<CPTPlotDataSource>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线

}

@end
