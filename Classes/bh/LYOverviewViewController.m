//
//  LYOverviewViewController.m
//  bh
//
//  Created by zhao on 13-4-6.
//
//

#import "LYOverviewViewController.h"
#import "LYGlobalSettings.h"
#import "JSON.h"
@interface LYOverviewViewController ()

@end

@implementation LYOverviewViewController
@synthesize m_oImageView;
@synthesize m_strRemoteUrl;
@synthesize m_pResponseData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect loFrame = self.view.frame;
    CGRect loFrame2 = loFrame;
    loFrame2.origin.x = loFrame.origin.x +5;
    loFrame2.origin.y = loFrame.origin.y-15;
    loFrame2.size.width = loFrame.size.width - 10;
    loFrame2.size.height = loFrame.size.height - 55 ;
    self.m_oImageView = [[[UIImageView alloc] initWithFrame:loFrame2]autorelease];
    self.m_oImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.m_oImageView];
    [self doLoadDataUseASIHTTP];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.m_strRemoteUrl = nil;
    self.m_oImageView = nil;
    self.m_pResponseData = nil;
    [super dealloc];
}

#pragma mark HUD指示器
-(void)PopUpIndicator
{
    self->HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self->HUD.mode = MBProgressHUDModeIndeterminate;
	[self.navigationController.view addSubview:self->HUD];
    self->HUD.dimBackground = YES;
    self->HUD.labelText = @"读取中";
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

#pragma mark ASIHTTPRequest Methods
- (void) doLoadDataUseASIHTTP
{
    [self PopUpIndicator];
    self.m_pResponseData = [[[NSMutableData alloc]initWithCapacity:10]autorelease];
    NSString * lpServerAddress = self.m_strRemoteUrl;
    NSURL* url = [NSURL URLWithString:lpServerAddress];
	ASIFormDataRequest * request = [ASIFormDataRequest  requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
   	[request startAsynchronous];
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    self.m_pResponseData =[NSMutableData dataWithData:[request responseData]] ;
    UIImage * image = [UIImage imageWithData:self.m_pResponseData];
    [self imageWithImage:image scaledToWidth:self.m_oImageView.frame.size.width] ;
    
    self.m_oImageView.image = image;
	
    self.m_pResponseData = nil;
    
    [self HiddeIndicator];
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

    self.m_pResponseData = nil;
    [self HiddeIndicator];
}

@end
