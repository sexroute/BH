//
//  LuckyNumbersViewController.m
//  LuckyNumbers
//
//  Created by Dan Grigsby on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LuckyNumbersViewController.h"
#import "JSON/JSON.h"
#import "LYGlobalSettings.h"




@implementation LuckyNumbersViewController
@synthesize m_oActivityProgressbar;
@synthesize m_oTableView;
@synthesize m_pNavViewController;

- (void)viewDidLoad {	
	[super viewDidLoad];
    [self LoadData];

}

- (void)LoadData
{
    if(nil !=  responseData)
    {
        [self->responseData release];        
    }
    responseData = [[NSMutableData data] retain];
    
    NSString * lpPostData = [LYGlobalSettings GetPostDataPrefix];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/api/alarm/gethierarchy/",[LYGlobalSettings GetSetting:SETTING_KEY_SERVER_ADDRESS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lpServerAddress] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void) alertLoadFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法获取数据, 重试?"
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    [alert release];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    
    [self alertLoadFailed];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [self navigateToPlantView];        
    }
    else
    {
       [self LoadData];
    }
  }
#define kDuration 0.7   // 动画持续时间(秒)
- (void) startAnimate:(UIView *) apDstView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:apDstView cache:YES];
    
    [UIView setAnimationDelegate:self];

}

- (void) navigateToPlantView
{
    self.m_oActivityProgressbar.hidesWhenStopped = TRUE;
    label.text = @"";
    [self.m_oActivityProgressbar stopAnimating];
    //2. load view
    if (nil == self->m_pPlantViewController)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                 bundle: nil];
        
        LyPlantViewController *detailViewController = (LyPlantViewController*)[mainStoryboard
                                                                               instantiateViewControllerWithIdentifier: @"PlantView"];
        self->m_pPlantViewController = detailViewController;
        self.m_pNavViewController = [[[LYNVController alloc]init] autorelease];
        self->m_pPlantViewController->listOfItems = self->listOfItems;
        [self->m_pPlantViewController->listOfItems retain];
        [self->m_pPlantViewController PreparePlantsData];
        [self presentViewController:self.m_pNavViewController animated:NO completion:nil];        
        [self.m_pNavViewController pushViewController:self->m_pPlantViewController animated:NO];
        [UIView commitAnimations];
        return;
        
        
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	self->listOfItems = [json objectWithString:responseString error:&error];

	if (listOfItems == nil)
	{
        
        label.text = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
        [self alertLoadFailed];
    }
	else
    {		
        [self navigateToPlantView];
	}
    [responseString release];
    [responseData release];
}



- (void)dealloc {
    [m_oTableView release];
    [m_oActivityProgressbar release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setM_oTableView:nil];
    [self setM_oActivityProgressbar:nil];
    [super viewDidUnload];
}
@end
