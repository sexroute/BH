//
//  LYChartView.m
//  bh
//
//  Created by zhao on 12-8-5.
//
//

#import "LYChartView.h"
#import "JSON/JSON.h"
@implementation LYChartView
@synthesize m_pParent;
@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrChann;
@synthesize m_pStrPlant;

@synthesize dataForPlot1;



// I added the NSLog to see if these get called, but they don't seem to get called!
- (void)initGraph
{

    
    graph = [[CPTXYGraph alloc] initWithFrame:self.m_pParent.bounds];
    
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.m_pParent.bounds];
    hostingView.hostedGraph = graph;
    
	[self.m_pParent addSubview:hostingView];
    [hostingView release];
    
    //设置留白
    graph.paddingLeft = 0;
	graph.paddingTop = 0;
	graph.paddingRight = 0;
	graph.paddingBottom = 0;
    
    graph.plotAreaFrame.paddingLeft = 45.0 ;
    graph.plotAreaFrame.paddingTop = 40.0 ;
    graph.plotAreaFrame.paddingRight = 5.0 ;
    graph.plotAreaFrame.paddingBottom = 80.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(2048)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0) length:CPTDecimalFromFloat(20.0)];
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;
    CPTXYAxis *x = axisSet.xAxis ;
    x. minorTickLineStyle = nil ;
    // 大刻度线间距： 50 单位
    x. majorIntervalLength = CPTDecimalFromString (@"200");
    // 坐标原点： 0
    x. orthogonalCoordinateDecimal = CPTDecimalFromString ( @"0" );
    
    CPTXYAxis *y = axisSet.yAxis ;
    //y 轴：不显示小刻度线
    y. minorTickLineStyle = nil ;
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPTDecimalFromString ( @"50" );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0");
    
    //创建绿色区域
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Green Plot";
    
    //设置绿色区域边框的样式
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    dataSourceLinePlot. areaFill = areaGradientFill;
    dataSourceLinePlot. areaBaseValue = CPTDecimalFromString ( @"0.0" );
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear ;
    
    
    dataForPlot1 = [[NSMutableArray alloc] init];
    j = 200;
    r = 0;
    //timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dataOpt) userInfo:nil repeats:YES];
    //[timer1 fire];
    [self initData];
    [self LoadDataFromMiddleWare];
    [graph reloadData];
}
- (void) initData
{
    return;
    double ldblPI = 3.1415926535;
    for (int i=0; i<1024; i++)
    {
        double ldblValue = sin(i*ldblPI/1024*2)*50;
        NSString *xp = [NSString stringWithFormat:@"%d",i];
        NSString *yp = [NSString stringWithFormat:@"%f",(ldblValue)];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        [dataForPlot1 insertObject:point1 atIndex:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//弹出网络错误对话框
    NSLog(@"%@",error.description);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	//[self.m_pProgressBar stopAnimating];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	self->listOfItems = [json objectWithString:responseString error:&error];
    
  
        id wave = [listOfItems objectForKey:@"wave"];
        id freq = [listOfItems objectForKey:@"freq"];
        id wave_len = [listOfItems objectForKey:@"wave_len"];
    int lnWave_Len = [(NSNumber *)wave_len intValue];
    short binChars [lnWave_Len/2];
       // NSLog(@"%@ | %@",wave,freq);
        
     char *hexChars = [wave UTF8String];
     NSUInteger hexLen = strlen(hexChars);
     char *nextHex = hexChars;
    char *nextChar = binChars;
    char byte_chars[3] = {'\0','\0','\0'};
    for (NSUInteger i = 0; i < lnWave_Len/2 - 1; i++)
    {
       
        byte_chars[0] = *(nextHex+i*4+3);
        byte_chars[1] = *(nextHex+i*4+2);
       *(nextChar+i*2+1) = strtol(byte_chars, NULL, 16);
        
        byte_chars[0] = *(nextHex+i*4+1);
        byte_chars[1] = *(nextHex+i*4+0);
        *(nextChar+i*2)= strtol(byte_chars, NULL, 16);
        
        //NSLog(@"%d",binChars[i]);
               
    }
    
    int lnMaxPoint = 1024;
    
    if (lnMaxPoint > lnWave_Len/2)
    {
        lnMaxPoint = lnWave_Len/2;
    }
    
    int lnInterval = (lnWave_Len/2/lnMaxPoint);
    
    int lnRealData[lnMaxPoint];
    
//    for (int i=0;i< lnMaxPoint; i++)
//    {
//        
//        for (int j=i; j<i+lnInterval; j++)
//        {
//            
//        }
//    }
//    
    
    
    for (int i=0; i<2048; i++)
    {
        double ldblValue = binChars[i]*1.0f/10.0f;
        //NSLog(@"%f",ldblValue);
        NSString *xp = [NSString stringWithFormat:@"%d",i];
        NSString *yp = [NSString stringWithFormat:@"%f",(ldblValue)];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        [dataForPlot1 insertObject:point1 atIndex:0];
    }
	
	if (listOfItems == nil)
	{
        //弹出网络错误对话框
    }
	else
    {
 	}
    [responseString release];
    [connection release];
    [graph reloadData];
    
}

- (void) dataOpt
{
    //[graph reloadData];
    //return;
    //添加随机数
    if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
    {
        NSString *xp = [NSString stringWithFormat:@"%d",j];
        double lfdata = sin((double)j/1024.0*2*3.1415926)*50;
        NSString *yp = [NSString stringWithFormat:@"%f",(lfdata)];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        [dataForPlot1 insertObject:point1 atIndex:0];
    }
    //刷新画板
    [graph reloadData];
    j = j + 20;
    r = r + 20;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - dataSourceOpt

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [dataForPlot1 count];
}

- (void) LoadDataFromMiddleWare
{
    if(nil != responseData)
    {
        [responseData release];
        responseData = nil;
    }
    responseData = [[NSMutableData data] retain];
//    NSString * lpUrl = [NSString stringWithFormat:@"http://bhxz808.3322.org:8090/xapi/alarm/wave/?MIDDLE_WARE_IP=222.199.224.145&MIDDLE_WARE_PORT=7005&SERVER_TYPE=1&companyid=%@&factoryid=%@&plantid=%@&channid=%@",self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann];
    NSString * lpUrl = [NSString stringWithFormat:@"http://bhxz808.3322.org:8090/xapi/alarm/wave/?MIDDLE_WARE_IP=222.199.224.145&MIDDLE_WARE_PORT=7005&SERVER_TYPE=1&companyid=%%E5%%A4%%A7%%E5%%BA%%86%%E7%%9F%%B3%%E5%%8C%%96&factoryid=%%E5%%8C%%96%%E5%%B7%%A5%%E4%%B8%%80%%E5%%8E%%82&plantid=EC1301&channid=1H%@",@""];
    NSLog(@"%@",lpUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lpUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num;
    //让视图偏移
	if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
        num = [[dataForPlot1 objectAtIndex:index] valueForKey:key];
        if ( fieldEnum == CPTScatterPlotFieldX ) {
			num = [NSNumber numberWithDouble:[num doubleValue] - r];
		}
	}
    //添加动画效果
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:2.0];
	[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    //NSLog(@"%f",[num floatValue]);
    return num;
}

@end
