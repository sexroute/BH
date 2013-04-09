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
#import "LYWaveViewController.h"
#import "LYDiagViewController.h"

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
@synthesize tileController;

#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 5;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
    NSArray *images = nil;

    images = [NSArray arrayWithObjects:
                  @"wave",
                  @"freq",
                  @"diag",
                  @"drawDot",
                  @"reset",
                  @"actions",
                  @"Text",
                  @"heart",
                  @"gear",
                  nil];


	if (tileNumber >= 0 && tileNumber < images.count)
    {
		return [UIImage imageNamed:[images objectAtIndex:tileNumber]];
	}
	
	return [UIImage imageNamed:@"Text"];
}


- (NSString *)labelForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *labels = [NSArray arrayWithObjects:
					   @"wave",
					   @"freq",
					   @"diag",
					   @"Dot",
					   @"reset",
					   @"Actions",
					   @"Text",
					   @"Heart",
					   @"Settings",
					   nil];
	if (tileNumber >= 0 && tileNumber < labels.count) {
		return [labels objectAtIndex:tileNumber];
	}
	
	return @"Tile";
}


- (NSString *)descriptionForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *hints = [NSArray arrayWithObjects:
                      @"Wave",
                      @"Frequence",
                      @"Diag",
                      @"Dot",
                      @"reset",
                      @"Shows export options",
                      @"Adds some text",
                      @"Marks something as a favourite",
                      @"Shows some settings",
                      nil];
	if (tileNumber >= 0 && tileNumber < hints.count) {
		return [hints objectAtIndex:tileNumber];
	}
	
	return @"It's a tile button!";
}


- (UIImage *)backgroundImageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 0) {
		return [UIImage imageNamed:@"blue_gradient"];
	} else if (tileNumber == 1) {
		return [UIImage imageNamed:@"purple_gradient"];
	} else if (tileNumber == 2) {
		return [UIImage imageNamed:@"green_gradient"];
	} else if (tileNumber == 3) {
		return [UIImage imageNamed:@"yellow_gradient"];
	} else if (tileNumber == 4) {
		return [UIImage imageNamed:@"orange_gradient"];
	} else if (tileNumber == -1) {
		return [UIImage imageNamed:@"grey_gradient"];
	}
	
	return [UIImage imageNamed:@"blue_gradient"];
}


- (BOOL)isTileEnabled:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{

    if ([LYBHUtility GetChannType:self.m_nChannType ] == E_TBL_CHANNTYPE_PROC)
    {
        if (tileNumber <=1)
        {
            return NO;
        }
        
    }
	
	return YES;
}

-(void) NavigateToHisWaveView:(int) anDataSelectedIndex anDataMode:(int)anDataMode
{
    LYWaveViewController * lpChannView = nil;
    UIStoryboard *mainStoryboard = nil;    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                               bundle: nil];
    lpChannView =(LYWaveViewController *)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"LYWaveViewController"];;
    lpChannView.m_pStrGroup = self.m_pStrGroup;
    lpChannView.m_pStrCompany = self.m_pStrCompany;
    lpChannView.m_pStrFactory = self.m_pStrFactory;
    lpChannView.m_pStrChann = self.m_pStrChann;
    lpChannView.m_pStrPlant = self.m_pStrPlant;
    lpChannView.m_nChannType = self.m_nChannType;
    lpChannView.m_pStrChannUnit = self.m_pStrChannUnit;
    lpChannView.m_fHH = self.m_fHH;
    lpChannView.m_fHL = self.m_fHL;
    lpChannView.m_fLL = self.m_fLL;
    lpChannView.m_fLH = self.m_fLH;
    lpChannView.m_pChannInfo = self.m_pChannInfo;
    lpChannView.m_nRequestType = 1;
    lpChannView.m_nDrawMode = anDataMode;
    
    NSString * lpDateTime = [(NSDictionary *)[self.listOfItems objectAtIndex:anDataSelectedIndex] objectForKey:@"datetime"];
    lpChannView.m_strHistoryDateTime = lpDateTime;
    self.title  =@"返回";
    [self.navigationController pushViewController:lpChannView animated:YES];
}

-(void) NavigateToDiagView:(int) anDataSelectedIndex anDataMode:(int)anDataMode
{
    LYDiagViewController * lpChannView = nil;
    
    
    UIStoryboard *mainStoryboard = nil;
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                               bundle: nil];
    lpChannView =(LYDiagViewController *)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"LYDiagViewController"];
    lpChannView.m_pStrChann = self.m_pStrChann;
    lpChannView.m_pStrCompany = self.m_pStrCompany;
    lpChannView.m_pStrFactory = self.m_pStrFactory;
    lpChannView.m_pStrGroup = self.m_pStrGroup;
    lpChannView.m_pStrPlant = self.m_pStrPlant;
    lpChannView.m_nPlantType = self.m_nPlantType;



     NSString * lpDateTime = [(NSDictionary *)[self.listOfItems objectAtIndex:anDataSelectedIndex] objectForKey:@"datetime"];
    lpChannView.m_pStrTimeStart = lpDateTime;

    self.title  =@"返回";
        
    [self.navigationController pushViewController:lpChannView animated:YES];
}

- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	//NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:tileController]);
    int lnSelectedIndex = self.m_oChart.selectedIndex;
    
    if (tileNumber<=1&& tileNumber>=0)
    {
        [self NavigateToHisWaveView:lnSelectedIndex anDataMode:tileNumber];
    }else if(tileNumber == 2)
    {
        [self NavigateToDiagView:lnSelectedIndex anDataMode:tileNumber];
    }else if(tileNumber == 3)
    {
        [self.m_oChart enableDrawDot:!self.m_oChart.m_bDrawDot];
        
        
    }else if(tileNumber == 4)
    {
        [self.m_oChart resetZoom];
    }

    
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	tileController = nil;
}

#pragma mark - Gesture handling


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	// Ensure that only touches on our own view are sent to the gesture recognisers.
	if (touch.view == self.m_oChart)
    {
        if (([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]]))
        {
            return YES;
            
        }else if([gestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]])
        {
            if(((UISwipeGestureRecognizer *)gestureRecognizer).direction == UISwipeGestureRecognizerDirectionRight)
            {
              return  YES;  
            }

        }
		
	}
	
	return NO;
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
	// Find out where the gesture took place.
	CGPoint loc = [gestureRecognizer locationInView:self.view];
	if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]] && ((UITapGestureRecognizer *)gestureRecognizer).numberOfTapsRequired == 2) {
		// This was a double-tap.
		// If there isn't already a visible TileMenu, we should create one if necessary, and show it.
		if (!tileController || tileController.isVisible == NO) {
			if (!tileController) {
				// Create a tileController.
				tileController = [[MGTileMenuController alloc] initWithDelegate:self];
				tileController.dismissAfterTileActivated = NO; // to make it easier to play with in the demo app.
			}
			// Display the TileMenu.
			[tileController displayMenuCenteredOnPoint:loc inView:self.view];
		}
		
	} else if([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]])
	{
		if (!tileController || tileController.isVisible == NO) {
			if (!tileController) {
				// Create a tileController.
				tileController = [[MGTileMenuController alloc] initWithDelegate:self];
				tileController.dismissAfterTileActivated = NO; // to make it easier to play with in the demo app.
			}
			// Display the TileMenu.
			[tileController displayMenuCenteredOnPoint:loc inView:self.view];
		}
	}else if([gestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
	{
		// This wasn't a double-tap, so we should hide the TileMenu if it exists and is visible.
		if (tileController && tileController.isVisible == YES) {
			// Only dismiss if the tap wasn't inside the tile menu itself.
			if (!CGRectContainsPoint(tileController.view.frame, loc)) {
				[tileController dismissMenu];
			}
		}
	}
}

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
    
    self.m_oChart = [[[Chart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    
    [self.view addSubview:self.m_oChart];    
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
	[self.m_oChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
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
	
	NSMutableDictionary *serie = [self.m_oChart getSerie:@"price"];
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
	[self.m_oChart appendToCategory:category forName:@"price"];
	[self.m_oChart appendToCategory:category forName:@"line"];
}

-(void)InitUI
{
    //1.button
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
    
    //2.init pup emnu guesture
    
    //2.1 双击
    UITapGestureRecognizer *doubleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease];
	doubleTapRecognizer.numberOfTapsRequired = 2;
	doubleTapRecognizer.delegate = self;
	[self.view addGestureRecognizer:doubleTapRecognizer];
	
    //2.2 单击
	UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease];
	tapRecognizer.delegate = self;
	[self.view addGestureRecognizer:tapRecognizer];
    
    //2.3 长摁
    UILongPressGestureRecognizer * longRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease];
	tapRecognizer.delegate = self;
	[self.view addGestureRecognizer:longRecognizer];
    
    //2.4 右滑动
    UISwipeGestureRecognizer * _swipeGestureRecognizer=[[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)]autorelease];
    [_swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
}

-(void)initChart
{
	NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"20",@"20",@"20",@"20",nil];
	[self.m_oChart setPadding:padding];
    self.m_oChart.m_bDrawDot = YES;
	NSMutableArray *secs = [[[NSMutableArray alloc] init]autorelease];
    //分区，数值大小代表分区的高低
	[secs addObject:@"4"]; //占位4/7
	[secs addObject:@"2"]; //占位2/7
	[secs addObject:@"1"]; //占位1/7
	[self.m_oChart addSections:3 withRatios:secs]; //初始化分区，按照给定的比例关系
    [self.m_oChart getSection:1].hidden = YES;
	[self.m_oChart getSection:2].hidden = YES; //隐藏第3个分区
	[[[self.m_oChart sections] objectAtIndex:0] addYAxis:0]; //从分区的Y方向0点开始绘制Y轴
	[[[self.m_oChart sections] objectAtIndex:1] addYAxis:0];
	[[[self.m_oChart sections] objectAtIndex:2] addYAxis:0];
	
	[self.m_oChart getYAxis:2 withIndex:0].baseValueSticky = NO; //第3个分区的属性设置，每个分区可以有多个Y轴
	[self.m_oChart getYAxis:2 withIndex:0].symmetrical = NO;
	[self.m_oChart getYAxis:0 withIndex:0].ext = 0.05;
	
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
    [self.m_oChart setSeries:series];
	[series release];
	
	[[[self.m_oChart sections] objectAtIndex:0] setSeries:secOne];
	[secOne release];
	[[[self.m_oChart sections] objectAtIndex:1] setSeries:secTwo];
	[secTwo release];
	[[[self.m_oChart sections] objectAtIndex:2] setSeries:secThree];
	[[[self.m_oChart sections] objectAtIndex:2] setPaging:YES];
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
			    [self.m_oChart addSerie:arr];
				[arr release];
			}else{
				NSDictionary *indic = (NSDictionary *)indicator;
				NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
				[self setOptions:indic ForSerie:serie];
				[self.m_oChart addSerie:serie];
				[serie release];
			}
		}
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.m_oChart addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
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
    
    [self.m_oChart appendToData:lpArray forName:@"price"];
    [self.m_oChart setRange:lnDataSize];
   

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
     self.m_nTimespanType = [self.m_oPickerView selectedRowInComponent:0];
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
      
        [self.m_oChart clearData];
        [self.m_oChart setNeedsDisplay];
    }
	else
    {
        [self.m_oChart removeFromSuperview];
        
        self.m_oChart = [[[Chart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
        if (nil != self.m_oPickerView)
        {
          [self.view insertSubview:self.m_oChart belowSubview:self.m_oPickerView];
        }else
        {
           [self.view addSubview:self.m_oChart ];
        }

        [self initChart];
        [self InitData];
        
        [self.m_oChart setNeedsDisplay];
        
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
        [self LoadDataASIHTTPRequest];
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
        [self.m_oChart removeFromSuperview];

        self.m_oChart = [[[Chart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
        
        [self.view addSubview:self.m_oChart];
        [self initChart];
        [self InitData];
       
        [self.m_oChart setNeedsDisplay];
        
        [self.view setNeedsDisplay];
    
	}
    [responseString release];
 
    self.m_oResponseData = nil;
    
    [connection release];

    
}

@end
