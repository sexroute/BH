//
//  LYChartView.h
//  bh
//
//  Created by zhao on 12-8-5.
//
//
#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"

@interface LYChartView : UIView<CPTPlotDataSource>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    NSTimer                     *timer1;            //定时器
    int                         j;
    int                         r;
    UIView                      * m_pParent;
}

@property (retain, nonatomic) NSMutableArray *dataForPlot1;
@property (retain, nonatomic) UIView *m_pParent;
-(void) initGraph;



@end
