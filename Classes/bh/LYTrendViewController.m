//
//  LYTrendViewController.m
//  bh
//
//  Created by zhaodali on 13-3-15.
//
//

#import "LYTrendViewController.h"
#import "LYGlobalSettings.h"
#import "ChannInfo.h"
#import "LYBHUtility.h"
#import "LYUtility.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "NVUIGradientButton.h"

@interface LYTrendViewController ()

@end

@implementation LYTrendViewController
@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrChann;
@synthesize m_pStrPlant;
@synthesize m_oResponseData;
@synthesize listOfItems;
@synthesize m_pStrChannUnit;
@synthesize m_oPickerView;
@synthesize m_oDataConfirmButton;
@synthesize m_oTitleButton;
@synthesize m_pChannInfo;

#pragma mark 初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->HUD = nil;
        self.m_pStrChannUnit =nil;
        self.m_oResponseData =nil;
        self.m_pStrChann = nil;
        self.m_pStrCompany = nil;
        self.m_pStrFactory = nil;
        self.m_pStrGroup = nil;
        self.m_pStrPlant = nil;
        self.m_fHH = .0;
        self.m_fHL = .0;
        self.m_fLL = .0;
        self.m_fLH = .0;
        self.m_oPickerView = nil;
        self.m_nAlarmJudgetType = E_ALARMCHECK_LOWPASS;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    [self.navigationController.toolbar setHidden:TRUE];
    
    self.candleChart = [[[Chart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    
    [self.view addSubview:self.candleChart];    
    [self InitUI];
    [self LoadData];
   
    

    
	// Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
     
}
-(void)viewWillAppear:(BOOL)animated
{
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload
{
    self.m_pStrChann = nil;
    self.m_pStrCompany =  nil;
    self.m_pStrFactory = nil;
    self.m_pStrGroup = nil;
    self.m_pStrPlant = nil;
    [super viewDidUnload];
}

#pragma mark HUD指示器
-(void)PopUpIndicator
{
    self->HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self->HUD.mode = MBProgressHUDModeIndeterminate;
	[self.navigationController.view addSubview:self->HUD];
    self->HUD.dimBackground = YES;
    self->HUD.labelText = @"刷新中";
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	self->HUD.delegate = self;
	// Show the HUD while the provided method executes in a new thread
	[self->HUD showWhileExecuting:@selector(OnHudCallBack) onTarget:self withObject:nil animated:YES];
}

-(void) HiddeIndicator
{
    if (nil!=self->HUD)
    {
        [self->HUD hide:YES];
    }
}

- (void)OnHudCallBack
{
    sleep(NETWORK_TIMEOUT*2);
}

- (void)hudWasHidden:(MBProgressHUD *)aphud
{
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}


#pragma mark 绘图

-(void)setData:(NSDictionary *)dic
{
	[self.candleChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
    //	[self.candleChart appendToData:[dic objectForKey:@"vol"] forName:@"vol"];
    //
    //	[self.candleChart appendToData:[dic objectForKey:@"ma10"] forName:@"ma10"];
    //	[self.candleChart appendToData:[dic objectForKey:@"ma30"] forName:@"ma30"];
    //	[self.candleChart appendToData:[dic objectForKey:@"ma60"] forName:@"ma60"];
    //
    //	[self.candleChart appendToData:[dic objectForKey:@"rsi6"] forName:@"rsi6"];
    //	[self.candleChart appendToData:[dic objectForKey:@"rsi12"] forName:@"rsi12"];
    //
    //	[self.candleChart appendToData:[dic objectForKey:@"wr"] forName:@"wr"];
    //	[self.candleChart appendToData:[dic objectForKey:@"vr"] forName:@"vr"];
    //
    //	[self.candleChart appendToData:[dic objectForKey:@"kdj_k"] forName:@"kdj_k"];
    //	[self.candleChart appendToData:[dic objectForKey:@"kdj_d"] forName:@"kdj_d"];
    //	[self.candleChart appendToData:[dic objectForKey:@"kdj_j"] forName:@"kdj_j"];
	
	NSMutableDictionary *serie = [self.candleChart getSerie:@"price"];
	if(serie == nil)
	{
        return;
    }
	if(self.chartMode == 1)
    {
		[serie setObject:@"candle" forKey:@"type"];
	}else{
		[serie setObject:@"line" forKey:@"type"];
	}
}

-(void)setCategory:(NSArray *)category
{
	[self.candleChart appendToCategory:category forName:@"price"];
	[self.candleChart appendToCategory:category forName:@"line"];
}

-(void)InitUI
{
    self.m_nTimespanType =GE_LAST_WEEK;
    CGRect loFrame = CGRectMake(0,0,self.view.frame.size.width,40);
    
    NVUIGradientButton *button=[[[NVUIGradientButton alloc]initWithFrame:loFrame ]autorelease];
    button.frame=loFrame;
    button.text = [NSString stringWithFormat: @"选择时间段:%@",[LYUtility GetRequestStr:self.m_nTimespanType]];
    button.backgroundColor=[UIColor clearColor];
    button.tag=2000;
    button.textColor =[UIColor whiteColor];
    button.textShadowColor = [UIColor blackColor];
    button.tintColor = [UIColor darkGrayColor];
    button.highlightedTintColor = [UIColor darkGrayColor];
    
    self.m_oTitleButton = button;
    
    [button addTarget:self action:@selector(onButtonDatePickUp:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
}

-(void)initChart
{
	NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"20",@"20",@"20",@"20",nil];
	[self.candleChart setPadding:padding];
	NSMutableArray *secs = [[[NSMutableArray alloc] init]autorelease];
    //分区，数值大小代表分区的高低
	[secs addObject:@"4"]; //占位4/7
	[secs addObject:@"2"]; //占位2/7
	[secs addObject:@"1"]; //占位1/7
	[self.candleChart addSections:3 withRatios:secs]; //初始化分区，按照给定的比例关系
    [self.candleChart getSection:1].hidden = YES;
	[self.candleChart getSection:2].hidden = YES; //隐藏第3个分区
	[[[self.candleChart sections] objectAtIndex:0] addYAxis:0]; //从分区的Y方向0点开始绘制Y轴
	[[[self.candleChart sections] objectAtIndex:1] addYAxis:0];
	[[[self.candleChart sections] objectAtIndex:2] addYAxis:0];
	
	[self.candleChart getYAxis:2 withIndex:0].baseValueSticky = NO; //第3个分区的属性设置，每个分区可以有多个Y轴
	[self.candleChart getYAxis:2 withIndex:0].symmetrical = NO;
	[self.candleChart getYAxis:0 withIndex:0].ext = 0.05;
	
    NSMutableArray *series = [[NSMutableArray alloc] init];
	NSMutableArray *secOne = [[NSMutableArray alloc] init];
	NSMutableArray *secTwo = [[NSMutableArray alloc] init];
	NSMutableArray *secThree = [[NSMutableArray alloc] init];
	
	//向1分区中增加序列属性，序列数据根据[self.candleChart appendToData:lpArray forName:@"price"]可以随时修改
	NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
	NSMutableArray *data = [[NSMutableArray alloc] init];
    int lnAlarm_enabled = [[self.m_pChannInfo objectForKey:@"alarm_enabled"]intValue];
    [serie setObject:[NSString stringWithFormat:@"%d",lnAlarm_enabled] forKey:@"alarm_enabled"];
	[serie setObject:@"price" forKey:@"name"];
	[serie setObject:@"Price" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"candle" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"0" forKey:@"section"];
	[serie setObject:@"52,176,52" forKey:@"color"];
	[serie setObject:@"255,0,0" forKey:@"negativeColor"];
	[serie setObject:@"0,255,0" forKey:@"selectedColor"];
	[serie setObject:@"0,255,0" forKey:@"negativeSelectedColor"];
    [serie setObject:@"255,255,0" forKey:KEY_LABEL_ALARM_COLOR];
    [serie setObject:@"176,52,52" forKey:KEY_LABEL_DANGER_COLOR];
	[serie setObject:@"52,176,52" forKey:KEY_LABEL_COLOR];
    [serie setObject:@"255,255,255" forKey:KEY_LABEL_DETAIL_INFO_COLOR];
	[serie setObject:@"0,255,0" forKey:@"labelNegativeColor"];
    [serie setObject:self.m_pStrChannUnit forKey:KEY_UNIT];
	[series addObject:serie];
	[secOne addObject:serie];
	[data release];
	[serie release];
	
    //	//MA10
    //	serie = [[NSMutableDictionary alloc] init];
    //	data = [[NSMutableArray alloc] init];
    //	[serie setObject:@"ma10" forKey:@"name"];
    //	[serie setObject:@"MA10" forKey:@"label"];
    //	[serie setObject:data forKey:@"data"];
    //	[serie setObject:@"line" forKey:@"type"];
    //	[serie setObject:@"0" forKey:@"yAxis"];
    //	[serie setObject:@"0" forKey:@"section"];
    //	[serie setObject:@"255,255,255" forKey:@"color"];
    //	[serie setObject:@"255,255,255" forKey:@"negativeColor"];
    //	[serie setObject:@"255,255,255" forKey:@"selectedColor"];
    //	[serie setObject:@"255,255,255" forKey:@"negativeSelectedColor"];
    //	[series addObject:serie];
    //	[secOne addObject:serie];
    //	[data release];
    //	[serie release];
    //
    //	//MA30
    //	serie = [[NSMutableDictionary alloc] init];
    //	data = [[NSMutableArray alloc] init];
    //	[serie setObject:@"ma30" forKey:@"name"];
    //	[serie setObject:@"MA30" forKey:@"label"];
    //	[serie setObject:data forKey:@"data"];
    //	[serie setObject:@"line" forKey:@"type"];
    //	[serie setObject:@"0" forKey:@"yAxis"];
    //	[serie setObject:@"0" forKey:@"section"];
    //	[serie setObject:@"250,232,115" forKey:@"color"];
    //	[serie setObject:@"250,232,115" forKey:@"negativeColor"];
    //	[serie setObject:@"250,232,115" forKey:@"selectedColor"];
    //	[serie setObject:@"250,232,115" forKey:@"negativeSelectedColor"];
    //	[series addObject:serie];
    //	[secOne addObject:serie];
    //	[data release];
    //	[serie release];
    //
    //	//MA60
    //	serie = [[NSMutableDictionary alloc] init];
    //	data = [[NSMutableArray alloc] init];
    //	[serie setObject:@"ma60" forKey:@"name"];
    //	[serie setObject:@"MA60" forKey:@"label"];
    //	[serie setObject:data forKey:@"data"];
    //	[serie setObject:@"line" forKey:@"type"];
    //	[serie setObject:@"0" forKey:@"yAxis"];
    //	[serie setObject:@"0" forKey:@"section"];
    //	[serie setObject:@"232,115,250" forKey:@"color"];
    //	[serie setObject:@"232,115,250" forKey:@"negativeColor"];
    //	[serie setObject:@"232,115,250" forKey:@"selectedColor"];
    //	[serie setObject:@"232,115,250" forKey:@"negativeSelectedColor"];
    //	[series addObject:serie];
    //	[secOne addObject:serie];
    //	[data release];
    //	[serie release];
    //
    //
    //	//VOL
    //	serie = [[NSMutableDictionary alloc] init];
    //	data = [[NSMutableArray alloc] init];
    //	[serie setObject:@"vol" forKey:@"name"];
    //	[serie setObject:@"VOL" forKey:@"label"];
    //	[serie setObject:data forKey:@"data"];
    //	[serie setObject:@"column" forKey:@"type"];
    //	[serie setObject:@"0" forKey:@"yAxis"];
    //	[serie setObject:@"1" forKey:@"section"];
    //	[serie setObject:@"0" forKey:@"decimal"];
    //	[serie setObject:@"176,52,52" forKey:@"color"];
    //	[serie setObject:@"77,143,42" forKey:@"negativeColor"];
    //	[serie setObject:@"176,52,52" forKey:@"selectedColor"];
    //	[serie setObject:@"77,143,42" forKey:@"negativeSelectedColor"];
    //	[series addObject:serie];
    //	[secTwo addObject:serie];
    //	[data release];
    //	[serie release];
	
	//candleChart init
    [self.candleChart setSeries:series];
	[series release];
	
	[[[self.candleChart sections] objectAtIndex:0] setSeries:secOne];
	[secOne release];
	[[[self.candleChart sections] objectAtIndex:1] setSeries:secTwo];
	[secTwo release];
	[[[self.candleChart sections] objectAtIndex:2] setSeries:secThree];
	[[[self.candleChart sections] objectAtIndex:2] setPaging:YES];
	[secThree release];
	
	
	NSString *indicatorsString =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"indicators" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
	if(indicatorsString != nil){
		NSArray *indicators = [indicatorsString JSONValue];
		for(NSObject *indicator in indicators){
			if([indicator isKindOfClass:[NSArray class]]){
				NSMutableArray *arr = [[NSMutableArray alloc] init];
				for(NSDictionary *indic in indicator){
					NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
					[self setOptions:indic ForSerie:serie];
					[arr addObject:serie];
					[serie release];
				}
			    [self.candleChart addSerie:arr];
				[arr release];
			}else{
				NSDictionary *indic = (NSDictionary *)indicator;
				NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
				[self setOptions:indic ForSerie:serie];
				[self.candleChart addSerie:serie];
				[serie release];
			}
		}
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.candleChart addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}

-(int)judgetAlarmType:(float) fValue
{
    int iRtn = 0;
    switch (self.m_nAlarmJudgetType)
    {
        case E_ALARMCHECK_LOWPASS:
            if (fValue>self.m_fHL)
            {
                if(fValue>self.m_fHH)
                {
                    iRtn=2;
                }
                else
                    iRtn=1;
            }
            break;
        case E_ALARMCHECK_HIGHPASS:
            if (fValue<self.m_fLH)
            {
                if (fValue<self.m_fLL)
                {
                    iRtn=2;
                }
                else
                {
                    iRtn=1;
                }
            }
            break;
        case E_ALARMCHECK_BANDPASS:
            if ((fValue>self.m_fHL)||(fValue<self.m_fLH))
            {
                if((fValue>self.m_fHH)||(fValue<self.m_fLL))
                {
                    iRtn=2;
                }
                else
                {	 iRtn=1;
                }
            }
            break;
        case E_ALARMCHECK_BANDSTOP:
            if((fValue<self.m_fHH)&&(fValue>self.m_fLL))
            {
                if((fValue<self.m_fHL)&&(fValue>self.m_fLH))
                {
                    iRtn=2;
                }
                else
                {
                    iRtn=1;
                }
            }
            break;
        default:
            if (fValue>self.m_fHL)
            {
                if(fValue>self.m_fHH)
                {
                    iRtn=2;
                }
                else
                {   iRtn=1;
                }
            }
    }
    return  iRtn;
}
-(void)InitData
{
    int lnDataSize = self.listOfItems.count;
    NSMutableArray *   lpArray= [NSMutableArray arrayWithCapacity:lnDataSize];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'" options:0 locale:nil];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    for (int i=0; i<self.listOfItems.count; i++)
    {
       NSArray * lpEigenvalues =   [(NSDictionary *)[self.listOfItems objectAtIndex:i] objectForKey:@"eigenvalue"];
        float lfval = [[lpEigenvalues objectForKey:@"featureValue1"] floatValue];
        int ldRev = [[lpEigenvalues objectForKey:@"Rev"] intValue];
        NSMutableArray * lpDataArray = [NSMutableArray arrayWithCapacity:6];
        NSString * lpDateTime = [(NSDictionary *)[self.listOfItems objectAtIndex:i] objectForKey:@"datetime"];
        [lpDataArray addObject:[NSString  stringWithFormat:@"%f",lfval]];
        [lpDataArray addObject:[NSString  stringWithFormat:@"时间 %@",lpDateTime]];
        [lpDataArray addObject:[NSString  stringWithFormat:@"转速 %d RPM",ldRev]];
        int lnAlarmType = [self judgetAlarmType:lfval];
        [lpDataArray addObject:[NSString  stringWithFormat:@"%d",lnAlarmType]];
        

        [lpArray addObject:lpDataArray];
    }
    
    [self.candleChart appendToData:lpArray forName:@"price"];
    [self.candleChart setRange:lnDataSize];
   

}
#pragma mark pickerview
-(void)onButtonDatePickUp:(NVUIGradientButton *)sender
{
    if (nil == self.m_oPickerView) {
        CGRect loFrame = self.view.frame;
        
        UIPickerView * pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0,0,loFrame.size.width,loFrame.size.height)]autorelease];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = [UIColor clearColor];
        [pickerView selectRow:self.m_nTimespanType inComponent:0 animated:YES];
        self.m_oPickerView = pickerView;
        [self.view addSubview: self.m_oPickerView];
        
        
        loFrame = self.m_oPickerView.frame;
        loFrame.origin.y = loFrame.origin.y + loFrame.size.height;
        loFrame.size.height = 40;
        NVUIGradientButton *button=[[[NVUIGradientButton alloc]initWithFrame:loFrame ]autorelease];
        button.frame=loFrame;
        button.text = @"确定";
        button.backgroundColor=[UIColor darkGrayColor];
        button.tag=2000;
        button.textColor =[UIColor whiteColor];
        button.textShadowColor = [UIColor blackColor];
        button.tintColor = [UIColor blackColor];
        button.highlightedTintColor = [UIColor darkGrayColor];
        self.m_oDataConfirmButton = button;
        
        [button addTarget:self action:@selector(onDatePickerConfirm:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
    }else
    {
        [self.m_oPickerView setHidden:NO];
        [self.m_oDataConfirmButton setHidden:NO];
    }
    
}
 -(void)onDatePickerConfirm:(NVUIGradientButton *)sender
{
    [self.m_oPickerView setHidden:YES];
    [self.m_oDataConfirmButton setHidden:YES];
    [self LoadData];
    NSString * lpText = [NSString stringWithFormat: @"选择时间段:%@",[LYUtility GetRequestStr:self.m_nTimespanType]];
    

    [self.m_oTitleButton setText:lpText];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    
    return (GE_LAST_3_YEAR+1);
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.m_nTimespanType = row;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"%d",row);
    return [LYUtility GetRequestStr:row];
    
}

#pragma mark 析构
-(void) dealloc
{
    self.m_oResponseData = nil;
    self.m_pStrChann = nil;
    self.m_pStrCompany = nil;
    self.m_pStrFactory = nil;
    self.m_pStrGroup = nil;
    self.m_pStrPlant = nil;
    self.listOfItems = nil;
    self.m_oPickerView = nil;
    self.m_oTitleButton = nil;
    self.m_oDataConfirmButton = nil;
    [super dealloc];
}

- (void)LoadData
{
    [self LoadDataASIHTTPRequest];
}
#pragma mark ASIHTTPRequest Methods
- (void)LoadDataASIHTTPRequest
{
   [self PopUpIndicator];
    self.m_oResponseData = [[[NSMutableData alloc]initWithCapacity:0]autorelease];
    self.listOfItems = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSString * lstrTimeEnd = [LYUtility GetRequestDate:nil];
    NSString * lstrTimeStart = [LYUtility GetRequestDate:self.m_nTimespanType apDate:nil];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/trend/vib.php",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    int lnChannCat = [LYBHUtility GetChannType:self.m_nChannType];
    if (lnChannCat == E_TBL_CHANNTYPE_PROC)
    {
        lpUrl = [NSString stringWithFormat:@"%@/alarm/trend/proc.php",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    }
    NSString * lpPostData = [NSString stringWithFormat:@"%@&companyid=%@&factoryid=%@&plantid=%@&channid=%@&channtype=%d&timestart=%@&timeend=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann,self.m_nChannType,lstrTimeStart,lstrTimeEnd];
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    
    
    ASIFormDataRequest * request = [ASIFormDataRequest  requestWithURL:aUrl];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [request appendPostData:requestBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
   	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [self HiddeIndicator];
    
    self.m_oResponseData =[NSMutableData dataWithData:[request responseData]] ;
    //	[self.m_pProgressBar stopAnimating];
	NSString *responseString = [[NSString alloc] initWithData:m_oResponseData encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"Trend Log: %@\r\n",responseString);
#endif
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
    
	self.listOfItems = [json objectWithString:responseString error:&error];
	
	if (listOfItems == nil || [listOfItems count] == 0)
	{
      
        [self.candleChart clearData];
        [self.candleChart setNeedsDisplay];
    }
	else
    {
        [self.candleChart removeFromSuperview];
        
        self.candleChart = [[[Chart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
        if (nil != self.m_oPickerView)
        {
          [self.view insertSubview:self.candleChart belowSubview:self.m_oPickerView];
        }else
        {
           [self.view addSubview:self.candleChart ];
        }

        [self initChart];
        [self InitData];
        
        [self.candleChart setNeedsDisplay];
        
        [self.view setNeedsDisplay];
        
	}
    [responseString release];
    
    self.m_oResponseData = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self HiddeIndicator];
	//弹出网络错误对话框
    [self alertLoadFailed:nil];

    
}


#pragma mark NSURLConnection methonds

-(void)LoadDataNSURLConnection
{
    self.m_oResponseData = [[[NSMutableData alloc]initWithCapacity:0]autorelease];
    self.listOfItems = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSString * lstrTimeEnd = [LYUtility GetRequestDate:nil];
    NSString * lstrTimeStart = [LYUtility GetRequestDate:GE_LAST_WEEK apDate:nil];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/trend/vib.php",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    int lnChannCat = [LYBHUtility GetChannType:self.m_nChannType];
    if (lnChannCat == E_TBL_CHANNTYPE_PROC)
    {
        lpUrl = [NSString stringWithFormat:@"%@/alarm/trend/proc.php",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    }
    NSString * lpPostData = [NSString stringWithFormat:@"%@&companyid=%@&factoryid=%@&plantid=%@&channid=%@&channtype=%d&timestart=%@&timeend=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann,self.m_nChannType,lstrTimeStart,lstrTimeEnd];
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:NETWORK_TIMEOUT];
#ifdef DEBUG
    NSLog(@"%@\r\n",lpUrl);
    NSLog(@"%@\r\n",lpPostData);
#endif
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[m_oResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[m_oResponseData appendData:data];
}

- (void) alertLoadFailed:(NSString * )apstrError
{
    NSString * lpStr = [NSString stringWithFormat:@"获取数据失败,重试?"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:lpStr
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    [alert show];
    [alert release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
 
    [self HiddeIndicator];
	//弹出网络错误对话框
    [self alertLoadFailed:[error localizedDescription]];
       [connection release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        
    }
    else
    {

    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
    [self HiddeIndicator];
//	[self.m_pProgressBar stopAnimating];
	NSString *responseString = [[NSString alloc] initWithData:m_oResponseData encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"Trend Log: %@\r\n",responseString);
#endif
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];

	self.listOfItems = [json objectWithString:responseString error:&error];
	
	if (listOfItems == nil || [listOfItems count] == 0)
	{
        //弹出网络错误对话框
    }
	else
    {
        [self.candleChart removeFromSuperview];

        self.candleChart = [[[Chart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
        
        [self.view addSubview:self.candleChart];
        [self initChart];
        [self InitData];
       
        [self.candleChart setNeedsDisplay];
        
        [self.view setNeedsDisplay];
    
	}
    [responseString release];
 
    self.m_oResponseData = nil;
    
    [connection release];

    
}

@end
