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
int g_ResolutionXMax = 210;
int g_ResolutionYMax = 960;

-(void) dealloc
{
    NSLog(@"dealloc graph.retainCount %d",self->graph.retainCount);
    //[self.m_pParent.subviews release];
    [self->graph release];
    self.m_pParent = nil;
    self.m_pStrChann = nil;
    self.m_pStrCompany =  nil;
    self.m_pStrFactory = nil;
    self.m_pStrGroup = nil;
    self.m_pStrPlant = nil;
    //[self->graph dealloc];
    NSLog(@"dealloc graph.retainCount %d",self->graph.retainCount);
    [super dealloc]; // 不要忘记调用父类代码
    
}

// I added the NSLog to see if these get called, but they don't seem to get called!
- (void)initGraph
{
   
    NSLog(@"graph :%d",self->graph.retainCount);
    self->graph = [[CPTXYGraph alloc] initWithFrame:self.m_pParent.bounds];
    NSLog(@"graph :%d",self->graph.retainCount);
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];

    [graph applyTheme:theme];
    NSLog(@"graph :%d",self->graph.retainCount);
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.m_pParent.bounds];
    hostingView.hostedGraph = graph;
    NSLog(@"graph :%d",self->graph.retainCount);

	[self.m_pParent addSubview:hostingView];
    NSLog(@"hostingView :%d",hostingView.retainCount);
    [hostingView.hostedGraph release];
    [hostingView release];
    NSLog(@"graph :%d",self->graph.retainCount);
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
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(g_ResolutionXMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-20.0) length:CPTDecimalFromFloat(20.0)];
    
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
     NSLog(@"graph :%d",self->graph.retainCount);
}
- (void) initData
{
    return;

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
- (void)DrawData:(id )wave_data wave_lenx:(int)wave_len maxPoint:(int)anMaxPoint axis_x_max:(double)adblAxisXMax axis_x_delta:(double)adblAxisXDelta
{
    [dataForPlot1 removeAllObjects];
    if (0!= wave_len )
    {
        int lnWave_Len = wave_len;
        
        id wave = wave_data;
        
        if (nil != wave && [wave isKindOfClass:[NSString class]])
        {
            short binChars [lnWave_Len];
            char *hexChars = (char *)[((NSString *)wave) UTF8String];
            char *nextHex = hexChars;
            char byte_chars[5] = {'\0','\0','\0','\0','\0'};

            for (NSUInteger i = 0; i < lnWave_Len; i++)
            {
                
                byte_chars[2] = *(nextHex+i*4+0);
                byte_chars[3] = *(nextHex+i*4+1);
                byte_chars[0] = *(nextHex+i*4+2);
                byte_chars[1] = *(nextHex+i*4+3);
                short lTest = strtol(byte_chars, NULL, 16);
                binChars[i] = lTest;
            }
                        
            int lnMaxPoint = anMaxPoint;
            int lnPointNumber = lnWave_Len;
            double ldblAxisMax = 0;
            double ldblAxisMin = 0;
            if (lnMaxPoint > lnPointNumber)
            {
                lnMaxPoint = lnPointNumber;
            }
            
            
            
                        
            double ldblXAxisMax = adblAxisXMax;
            double ldblAxisXDelta = adblAxisXDelta;

            
            //            if (0!=lnSmpSum)
            //            {
            //                ldblTime = lnSmpSum*1.0/lnSmpFreq*1.0;
            //                ldblDeltaTime = ldblTime/lnWave_Len;
            //            }
            //            Boolean lbOuterCheck = true;
            //            for (int i=0; i<lnWave_Len; i++)
            //            {
            //                double ldbData = binChars[i]*1.0/10.0;
            //
            //                NSString *xp = [NSString stringWithFormat:@"%f",(i)*ldblDeltaTime];
            //                NSString *yp = [NSString stringWithFormat:@"%f",(ldbData)];
            //                              if (ldblAxisMax<ldbData || lbOuterCheck) {
            //                                  ldblAxisMax = ldbData;
            //                               }
            //
            //                               if (ldblAxisMin>ldbData || lbOuterCheck) {
            //                                   ldblAxisMin = ldbData;
            //
            //                               }
            //                NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            //                [dataForPlot1 insertObject:point1 atIndex:i];
            //                lbOuterCheck = false;
            //
            //            }
            //
            //            NSLog(@"%f",ldblAxisMax);
            //             NSLog(@"%f",ldblAxisMin);
            
            Boolean lbOuterCheck = true;
            int lnInterval = lnPointNumber/lnMaxPoint;
            
            for (int i=0; i<lnMaxPoint; i++)
            {
                double ldblMax = 0;
                double ldblMin = 0;
                Boolean lbFirstCheck = true;
                int lnMaxValIndex = 0;
                int lnMinValIndex = 0;
                int lnIndex = i*lnInterval;
                int lnIndexMax = lnIndex+lnInterval;
                for (int k=lnIndex;k< lnIndexMax;k++)
                {
                    if (k>=lnWave_Len)
                    {
                        continue;
                        
                    }
                    double ldblValue = binChars[k]*1.0f/10.0f;
                    if (ldblMax<ldblValue || lbFirstCheck)
                    {
                        ldblMax = ldblValue;
                        lnMaxValIndex = k;
                    }
                    
                    if (ldblMin>ldblValue || lbFirstCheck)
                    {
                        ldblMin = ldblValue;
                        lnMinValIndex = k;
                    }
                    lbFirstCheck = false;
                    
                }
                
                if (ldblAxisMax<ldblMax || lbOuterCheck) {
                    ldblAxisMax = ldblMax;
                }
                
                if (ldblAxisMin>ldblMin || lbOuterCheck) {
                    ldblAxisMin = ldblMin;
                    
                }
                lbOuterCheck = false;
                
                
                //NSLog(@"%f",ldblValue);
                if (lnMaxValIndex<lnMinValIndex)
                {
                    NSString *xp = [NSString stringWithFormat:@"%f",(i)*ldblAxisXDelta];
                    NSString *yp = [NSString stringWithFormat:@"%f",(ldblMax)];
                    
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:i];
                    
                    NSString *xp2 = [NSString stringWithFormat:@"%f",(i)*ldblAxisXDelta];
                    NSString *yp2 = [NSString stringWithFormat:@"%f",(ldblMin)];
                    //                    NSLog(@"%d %@ %@",i,xp,yp);
                    //                    NSLog(@"%d %@ %@",i,xp2,yp2);
                    NSMutableDictionary *point2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp2, @"x", yp2, @"y", nil];
                    [dataForPlot1 insertObject:point2 atIndex:i];
                    
                }else
                {
                    NSString *xp = [NSString stringWithFormat:@"%f",(i)*ldblAxisXDelta];
                    NSString *yp = [NSString stringWithFormat:@"%f",(ldblMin)];
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:i];
                    
                    NSString *xp2 = [NSString stringWithFormat:@"%f",(i)*ldblAxisXDelta];
                    NSString *yp2 = [NSString stringWithFormat:@"%f",(ldblMax)];
                    //                    NSLog(@"%d %@ %@",i,xp,yp);
                    //                    NSLog(@"%d %@ %@",i,xp2,yp2);
                    NSMutableDictionary *point2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp2, @"x", yp2, @"y", nil];
                    [dataForPlot1 insertObject:point2 atIndex:i];
                }
                
            }
            
            int lnPointLeft = lnPointNumber%lnInterval;
            
            
            if (lnPointLeft>0)
            {
                lbOuterCheck = true;
                double ldblMax = 0;
                double ldblMin = 0;
                int lnMaxValIndex = 0;
                int lnMinValIndex = 0;
                
                for (int i=lnPointNumber-1; i>=lnPointNumber-lnPointLeft; i--)
                {
                    double ldblValue = binChars[i]*1.0f/10.0f;
                    if (ldblMax<ldblValue || lbOuterCheck) {
                        ldblMax = ldblValue;
                        lnMaxValIndex = i;
                    }
                    
                    if (ldblMin>ldblValue || lbOuterCheck) {
                        ldblMin = ldblValue;
                        lnMinValIndex = i;
                        
                    }
                    
                }
                
                if (lnMaxValIndex<lnMinValIndex)
                {
                    NSString *xp = [NSString stringWithFormat:@"%f",(lnMaxPoint-1)*ldblAxisXDelta];
                    NSString *yp = [NSString stringWithFormat:@"%f",(ldblMax)];
                    
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:lnMaxPoint-1];
                    
                    NSString *xp2 = [NSString stringWithFormat:@"%f",(lnMaxPoint-1)*ldblAxisXDelta];
                    NSString *yp2 = [NSString stringWithFormat:@"%f",(ldblMin)];
                    //                    NSLog(@"%d %@ %@",lnMaxPoint-1,xp,yp);
                    //                    NSLog(@"%d %@ %@",lnMaxPoint-1,xp2,yp2);
                    NSMutableDictionary *point2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp2, @"x", yp2, @"y", nil];
                    [dataForPlot1 insertObject:point2 atIndex:lnMaxPoint-1];
                    
                }else
                {
                    NSString *xp = [NSString stringWithFormat:@"%f",(lnMaxPoint-1)*ldblAxisXDelta];
                    NSString *yp = [NSString stringWithFormat:@"%f",(ldblMin)];
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:lnMaxPoint-1];
                    
                    NSString *xp2 = [NSString stringWithFormat:@"%f",(lnMaxPoint-1)*ldblAxisXDelta];
                    NSString *yp2 = [NSString stringWithFormat:@"%f",(ldblMax)];
                    //                    NSLog(@"%d %@ %@",lnMaxPoint-1,xp,yp);
                    //                    NSLog(@"%d %@ %@",lnMaxPoint-1,xp2,yp2);
                    NSMutableDictionary *point2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp2, @"x", yp2, @"y", nil];
                    [dataForPlot1 insertObject:point2 atIndex:lnMaxPoint-1];
                }
            }
            
            
            
            
            CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
            plotSpace.allowsUserInteraction = YES;
            
            //plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(g_ResolutionXMax*1.1)];
            
            plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(ldblXAxisMax)];
            plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(ldblAxisMin*1.2) length:CPTDecimalFromFloat((ldblAxisMax-ldblAxisMin)*1.2)];
            
            
            CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;
            CPTXYAxis *x = axisSet.xAxis ;
            
            x. minorTickLineStyle = nil ;
            // 大刻度线间距： 50 单位
            x. majorIntervalLength = CPTDecimalFromFloat(ldblXAxisMax/5);
            // 坐标原点： 0
            x. orthogonalCoordinateDecimal = CPTDecimalFromString ( @"0" );
            
            CPTXYAxis *y = axisSet.yAxis ;
            //y 轴：不显示小刻度线
            y. minorTickLineStyle = nil ;
            // 大刻度线间距： 50 单位
            y. majorIntervalLength = CPTDecimalFromDouble((ldblAxisMax-ldblAxisMin)*1.2/10) ;
            // 坐标原点： 0
            y. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0");
            
        }
        
    }

}
- (int) DrawFreq
{
    id wave_len = [((NSDictionary *)self->listOfItems) objectForKey:@"freq_len"];
    id wave = [((NSDictionary *)self->listOfItems) objectForKey:@"freq"];
    if (nil != wave && [wave isKindOfClass:[NSString class]])
    {
        int lnWave_Len = [(NSNumber *)wave_len intValue];
        if (lnWave_Len<=0)
        {
            return 0;
        }
        
        id loDf = [((NSDictionary *)self->listOfItems) objectForKey:@"df"];
        
        double ldblDf = [(NSNumber *)loDf doubleValue];
        
        id eigenvalue = [((NSDictionary *)self->listOfItems) objectForKey:@"eigenvalue"];
        NSDictionary * lpEigenvalue = nil;
        
        if (nil!= eigenvalue && [eigenvalue isKindOfClass:[NSDictionary class]])
        {
            lpEigenvalue =(NSDictionary *)eigenvalue;
        }
        
        id lIdSmpFreq = [lpEigenvalue objectForKey:@"SmpFreq"];
        id lIdSmpNum  = [lpEigenvalue objectForKey:@"SmpNum"];
        int lnSmpFreq = 0;
        int lnSmpSum = 0;
        
        if (nil != lIdSmpFreq && [lIdSmpFreq isKindOfClass:[NSNumber class]])
        {
            lnSmpFreq = [(NSNumber*)lIdSmpFreq intValue];
        }
        
        if (nil != lIdSmpNum && [lIdSmpNum isKindOfClass:[NSNumber class]])
        {
            lnSmpSum = [(NSNumber*)lIdSmpNum intValue];
        }
        double ldblXAxisMax = 0;
        double  ldblAxisXDelta = 0;
        if (0!=lnSmpSum)
        {
            ldblXAxisMax = lnWave_Len*ldblDf;
            ldblAxisXDelta = ldblXAxisMax/g_ResolutionXMax;
        }
        
        [self DrawData:wave wave_lenx:lnWave_Len maxPoint:g_ResolutionXMax axis_x_max:ldblXAxisMax axis_x_delta:ldblAxisXDelta];
        
        return 1;
    }
    
    return 0;
   
}
- (int) DrawWave
{
    id wave_len = [((NSDictionary *)self->listOfItems) objectForKey:@"wave_len"];
    id wave = [((NSDictionary *)self->listOfItems) objectForKey:@"wave"];
    if (nil != wave && [wave isKindOfClass:[NSString class]])
    {
        int lnWave_Len = [(NSNumber *)wave_len intValue];
        if (lnWave_Len<=0)
        {
            return 0;
        }
        
        id eigenvalue = [((NSDictionary *)self->listOfItems) objectForKey:@"eigenvalue"];
        NSDictionary * lpEigenvalue = nil;
        
        if (nil!= eigenvalue && [eigenvalue isKindOfClass:[NSDictionary class]])
        {
            lpEigenvalue =(NSDictionary *)eigenvalue;
        }
        
        id lIdSmpFreq = [lpEigenvalue objectForKey:@"SmpFreq"];
        id lIdSmpNum  = [lpEigenvalue objectForKey:@"SmpNum"];
        int lnSmpFreq = 0;
        int lnSmpSum = 0;
        
        if (nil != lIdSmpFreq && [lIdSmpFreq isKindOfClass:[NSNumber class]])
        {
            lnSmpFreq = [(NSNumber*)lIdSmpFreq intValue];
        }
        
        if (nil != lIdSmpNum && [lIdSmpNum isKindOfClass:[NSNumber class]])
        {
            lnSmpSum = [(NSNumber*)lIdSmpNum intValue];
        }
        double ldblXAxisMax = 0;
        double  ldblAxisXDelta = 0;
        if (0!=lnSmpSum)
        {
            ldblXAxisMax = lnSmpSum*1.0/lnSmpFreq*1.0;
            ldblAxisXDelta = ldblXAxisMax/g_ResolutionXMax;
        }
        
        [self DrawData:wave wave_lenx:lnWave_Len maxPoint:g_ResolutionXMax axis_x_max:ldblXAxisMax axis_x_delta:ldblAxisXDelta];
        
        return 1;
    }
    
    return 0;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading graph :%d",self->graph.retainCount);

	//[self.m_pProgressBar stopAnimating];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	    
	NSLog(@"%d",responseData.retainCount );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	self->listOfItems = [json objectWithString:responseString error:&error];
    //[responseData release];
    [responseData dealloc];
    self->responseData = nil;

    if (nil== self->listOfItems || ![self->listOfItems isKindOfClass:[NSDictionary class]]  )
    {
        [responseString release];
        [connection release];
        return;
    }else
    {
        NSLog(@"%@",[self->listOfItems class]);
    }
    int lnDrawResult = 0;
    switch ([self getDrawDataMode])
    {
        case WAVE:
            lnDrawResult = [self DrawWave];
            break;
        case FREQUENCE:
            lnDrawResult = [self DrawFreq];
            break;
        default:
            break;
    }
    
    [responseString release];  
    [connection release];
    if (lnDrawResult)
    {
        [graph reloadData];
    }
    
}

- (void) dataOpt
{
//    //[graph reloadData];
//    //return;
//    //添加随机数
//    if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
//    {
//        NSString *xp = [NSString stringWithFormat:@"%d",j];
//        double lfdata = sin((double)j/1024.0*2*3.1415926)*50;
//        NSString *yp = [NSString stringWithFormat:@"%f",(lfdata)];
//        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
//        [dataForPlot1 insertObject:point1 atIndex:0];
//    }
//    //刷新画板
//    [graph reloadData];
//    j = j + 20;
//    r = r + 20;
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
//        [responseData release];
//        responseData = nil;
    }
    responseData = [[NSMutableData data] retain];
   NSString * lpUrl = [NSString stringWithFormat:@"http://bhxz808.3322.org:8090/xapi/alarm/wave/?MIDDLE_WARE_IP=222.199.224.145&MIDDLE_WARE_PORT=7005&SERVER_TYPE=1&companyid=%@&factoryid=%@&plantid=%@&channid=%@",self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann];
//  lpUrl = [NSString stringWithFormat:@"http://bhxz808.3322.org:8090/xapi/alarm/wave/?MIDDLE_WARE_IP=222.199.224.145&MIDDLE_WARE_PORT=7005&SERVER_TYPE=1&companyid=%%E5%%A4%%A7%%E5%%BA%%86%%E7%%9F%%B3%%E5%%8C%%96&factoryid=%%E5%%8C%%96%%E5%%B7%%A5%%E4%%B8%%80%%E5%%8E%%82&plantid=EC1301&channid=1H%@",@""];
    
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

- (DrawMode)getDrawDataMode {
    return m_nDrawDataMode;
}

- (void)setDrawDataMode:(DrawMode)newValue {
    m_nDrawDataMode = newValue;
}

@end
