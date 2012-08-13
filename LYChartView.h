//
//  LYChartView.h
//  bh
//
//  Created by zhao on 12-8-5.
//
//
#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"
typedef enum {
    WAVE,
    FREQUENCE,
    TREND
} DrawMode;

@interface LYChartView : UIView<CPTPlotDataSource>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线

    NSMutableArray              *dataForPlot1;      //坐标数组
    NSTimer                     *timer1;            //定时器
    int                         j;
    int                         r;
    UIView                      * m_pParent;
    NSMutableData               *responseData;
    NSString * m_pStrGroup;
    NSString * m_pStrCompany;
    NSString * m_pStrFactory;
    NSString * m_pStrChann;
    NSString * m_pStrPlant;
    NSMutableArray *listOfItems;
    DrawMode                         m_nDrawDataMode;
}

@property (retain, nonatomic) NSMutableArray *dataForPlot1;
@property (retain, nonatomic) UIView   * m_pParent;
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (retain, nonatomic) NSString * m_pStrPlant;
-(void) initGraph;
-(void) LoadDataFromMiddleWare;


- (DrawMode)getDrawDataMode;

- (void)setDrawDataMode:(DrawMode)newValue;

@end
