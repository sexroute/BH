//
//  LYWaveViewController.m
//  bh
//
//  Created by zhao on 12-8-5.
//
//

#import "LYWaveViewController.h"
#import "LYGlobalSettings.h"
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self->HUD = nil;
        self.hostView = nil;
        self.m_pStrChann = nil;
        self.m_pStrCompany =  nil;
        self.m_pStrFactory = nil;
        self.m_pStrGroup = nil;
        self.m_pStrPlant = nil;
        self.hostView = nil;

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
    [self initPlot:WAVE];
}

- (void)viewDidUnload
{
 //   [self.m_plotView.subviews release];
    [self setHostView:nil];
    
    [self setM_pChartViewParent:nil];
    [self setM_plotView:nil];
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
    [m_pChartViewParent release];
    [m_plotView release];
   
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
    sleep(3600);
}

- (void)hudWasHidden:(MBProgressHUD *)aphud {
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
    [self PopUpIndicator];
    [self initPlot:FREQUENCE];
}


#pragma mark - NSURLConnection
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
  

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self HiddeIndicator];
    [self.hostView connectionDidFinishLoading:connection];
}

- (void) LoadDataFromMiddleWare
{
    [self.hostView initData];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/wave/",[LYGlobalSettings GetSetting:SETTING_KEY_SERVER_ADDRESS]];
    NSString * lpPostData = [NSString stringWithFormat:@"%@&companyid=%@&factoryid=%@&plantid=%@&channid=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann];
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
@end