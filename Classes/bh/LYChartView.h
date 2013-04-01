//
//  LYChartView.h
//  bh
//
//  Created by zhao on 12-8-5.
//
//
#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
typedef enum {
    WAVE,
    FREQUENCE,
    TREND
} DrawMode;

@interface LYChartView : UIView<CPTPlotDataSource>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线

    
    @protected
	long long expectedLength;
	long long currentLength;

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
@property (retain, nonatomic) NSString * m_pStrChannUnit;
-(void) initGraph;


-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response ;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoadingASIHTTPRequest:(ASIHTTPRequest *)request;

-(DrawMode)getDrawDataMode;

- (void)setDrawDataMode:(DrawMode)newValue;

- (id)init;

- (void) initData;

@end
