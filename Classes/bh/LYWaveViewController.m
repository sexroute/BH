//
//  LYWaveViewController.m
//  bh
//
//  Created by zhao on 12-8-5.
//
//

#import "LYWaveViewController.h"
#import "LYGlobalSettings.h"
#import "ChannInfo.h"
@interface LYWaveViewController ()

@end

@implementation LYWaveViewController
@synthesize m_plotView;
@synthesize hostView;
@synthesize m_pChartViewParent;

@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrChann;
@synthesize m_pStrPlant;
@synthesize m_pStrChannUnit;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self->HUD = nil;
        self.hostView = nil;
        self.m_pStrChann = nil;
        self.m_pStrCompany =  nil;
        self.m_pStrFactory = nil;
        self.m_pStrGroup = nil;
        self.m_pStrPlant = nil;
        self.hostView = nil;
        
        self.m_fHH = .0;
        self.m_fHL = .0;
        self.m_fLL = .0;
        self.m_fLH = .0;

        
    }
    return self;
}

#pragma mark - Chart behavior
-(void)initPlot:(DrawMode) nDrawMode
{
    if (nil == self.hostView)
    {
        self.hostView = [[[LYChartView alloc] init]autorelease];
        NSLog(@"%d",hostView.retainCount);
        
        //self.hostView.bounds = self.m_pChartViewParent.bounds;
        self.hostView.m_pStrCompany = self.m_pStrCompany;
        self.hostView.m_pStrFactory = self.m_pStrFactory;
        self.hostView.m_pStrPlant = self.m_pStrPlant;
        self.hostView.m_pStrChann = [self.m_pStrChann stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.hostView.m_pParent = self.m_plotView;
        self.hostView.m_pStrChannUnit = self.m_pStrChannUnit;
        [self.hostView setDrawDataMode:nDrawMode];
        [self.hostView initGraph];
        [self PopUpIndicator];
        [self LoadDataFromMiddleWare];
        
    }else
    {
        [self.hostView setDrawDataMode:nDrawMode];
        [self LoadDataFromMiddleWare];
        
    }
    
    NSLog(@"%d",hostView.retainCount);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.m_oToolbar.barStyle = [LYGlobalSettings GetSettingInt:SETTING_KEY_STYLE];
    [self initPlot:WAVE];
    self.m_oButtonWave.style = UIBarButtonItemStyleBordered;
    self.m_oButtonFreq.style = UIBarButtonItemStylePlain;
    self.m_oButtonFresh.style = UIBarButtonItemStylePlain;
    self.m_oButtonTrend.title = @"历史趋势";
    
}

- (void)viewDidUnload
{
    //   [self.m_plotView.subviews release];
    [self setHostView:nil];
    
    [self setM_pChartViewParent:nil];
    [self setM_plotView:nil];
    [self setM_oToolbar:nil];
    [self setM_oButtonFreq:nil];
    [self setM_oButtonWave:nil];
    [self setM_oButtonFresh:nil];
    [self setM_oButtonTrend:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)dealloc
{
    
    NSLog(@"dealloc self :%d",self.retainCount);
    NSLog(@"dealloc hostview :%d",self.hostView.retainCount);
    
    self.m_pStrChann = nil;
    self.m_pStrCompany =  nil;
    self.m_pStrFactory = nil;
    self.m_pStrGroup = nil;
    self.m_pStrPlant = nil;
    self.hostView = nil;
    self.m_pStrChannUnit = nil;
    [m_pChartViewParent release];
    [m_plotView release];
    
    [_m_oToolbar release];
    [_m_oButtonFreq release];
    [_m_oButtonWave release];
    [_m_oButtonFresh release];
    [_m_oButtonTrend release];
    [super dealloc];
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
    sleep(NETWORK_TIMEOUT);
}

- (void)hudWasHidden:(MBProgressHUD *)aphud
{
    if (nil!=aphud)
    {
        NSLog(@"hudWasHidden self :%d",aphud.retainCount);
        [aphud removeFromSuperview];
        [aphud release];
    }
}

#pragma mark ButtonPress methods
- (IBAction)OnWavePressed:(UIBarButtonItem *)sender
{
    self.m_oButtonWave.style = UIBarButtonItemStyleBordered;
    self.m_oButtonFreq.style = UIBarButtonItemStylePlain;
    [self PopUpIndicator];
    [self initPlot:WAVE];
}

-(IBAction)OnRefreshPressed:(UIBarButtonItem *)sender
{
    
    [self PopUpIndicator];
    [self initPlot:[self.hostView getDrawDataMode]];
}

- (IBAction)onFreqPressed:(UIBarButtonItem *)sender
{
    self.m_oButtonFreq.style = UIBarButtonItemStyleBordered;
    self.m_oButtonWave.style = UIBarButtonItemStylePlain;
    [self PopUpIndicator];
    [self initPlot:FREQUENCE];
}


#pragma mark - NSURLConnection

- (void) alertLoadFailed:(NSString * )apstrError
{
    NSString * lpStr = [NSString stringWithFormat:@"获取数据失败,重试?"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:lpStr
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    
    [alert show];
    [alert release];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.hostView connection:connection didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.hostView connection:connection didReceiveData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//弹出网络错误对话框
    [self alertLoadFailed:@""];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self HiddeIndicator];
    [self.hostView connectionDidFinishLoading:connection];
}

- (void) LoadDataFromMiddleWare
{
    [self.hostView initData];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/wave/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    if (self.m_nChannType == GE_RODSINKCHANN)
    {
        lpUrl = [NSString stringWithFormat:@"%@/alarm/wave/rodsink.php",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    }
    NSString * lpPostData = [NSString stringWithFormat:@"%@&companyid=%@&factoryid=%@&plantid=%@&channid=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann];
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:NETWORK_TIMEOUT];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
- (IBAction)onTrendButtonPressed:(UIBarButtonItem *)sender
{
    UIStoryboard *mainStoryboard = nil;
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                               bundle: nil];

    LYTrendViewController * lpTrendView =(LYTrendViewController *)[mainStoryboard
                                           instantiateViewControllerWithIdentifier: @"LYTrendViewController"];
    lpTrendView.m_pStrGroup = self.m_pStrGroup;
    lpTrendView.m_pStrCompany = self.m_pStrCompany;
    lpTrendView.m_pStrFactory = self.m_pStrFactory;
    lpTrendView.m_pStrChann = self.m_pStrChann;
    lpTrendView.m_pStrPlant = self.m_pStrPlant;
    lpTrendView.m_nChannType = self.m_nChannType;
    lpTrendView.m_pStrChannUnit = self.m_pStrChannUnit;
    lpTrendView.m_fHH = self.m_fHH;
    lpTrendView.m_fHL = self.m_fHL;
    lpTrendView.m_fLL = self.m_fLL;
    lpTrendView.m_fLH = self.m_fLH;
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:lpTrendView animated:YES];
}
@end
