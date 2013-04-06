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
-(void)OnRotatePressed:(UIBarButtonItem  *)apButton
{
    self.m_oImageView.image = rotateUIImage(self.m_oImageView.image, 90.0);
}
- (void) InitUI
{
    UIBarButtonItem *flipButton = [[[UIBarButtonItem alloc]
                                    initWithTitle:@"旋转"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(OnRotatePressed:)]autorelease];

    self.navigationItem.rightBarButtonItem = flipButton;
   
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
    [self InitUI];
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
    self->HUD.labelText = @"加载中";
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

UIImage* rotateUIImage(const UIImage* src, float angleDegrees)  {
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, src.size.width, src.size.height)];
    float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
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
    
    self.m_oImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_oImageView.image = image ;
    

    self.m_pResponseData = nil;
    
    [self HiddeIndicator];
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

    self.m_pResponseData = nil;
    [self HiddeIndicator];
}

@end
