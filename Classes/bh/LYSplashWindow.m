//
//  LuckyNumbersViewController.m
//  LuckyNumbers
//
//  Created by Dan Grigsby on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LYSplashWindow.h"
#import "JSON.h"
#import "LYGlobalSettings.h"




@implementation LYSplashWindow
@synthesize m_oActivityProgressbar;

@synthesize m_pNavViewController;
@synthesize m_oImageView;

UITextField * g_pTextUserName = nil;
UITextField * g_pTextPassword = nil;

#pragma mark 登陆框UI处理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (BOOL) textFieldShouldReturn:(UITextField *)tf
{
    switch (tf.tag) {
        case 0:
            [LYGlobalSettings SetSetting:SETTING_KEY_USER apVal:tf.text];
            [g_pTextPassword becomeFirstResponder];
            break;
        case 1:
            [LYGlobalSettings SetSetting:SETTING_KEY_PASSWORD apVal:tf.text];
            [self.m_oLoginTableView setHidden:YES];
            [self LoadData];
            break;
        default:
            [tf resignFirstResponder];
            break;
    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"Cell";
    UITableViewCell *cell = [self.m_oLoginTableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 185, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0)
            {
                playerTextField.placeholder = @"用户名";
                playerTextField.returnKeyType = UIReturnKeyNext;
                playerTextField.tag = 0;
                g_pTextUserName = playerTextField;
                NSString * lpVal = [LYGlobalSettings GetSetting:SETTING_KEY_USER];
                if ([lpVal length]>0)
                {
                    playerTextField.text = lpVal;
                }
            }
            else
            {
                playerTextField.placeholder = @"密码";
                playerTextField.keyboardType = UIKeyboardTypeDefault;
                playerTextField.returnKeyType = UIReturnKeyGo;
                playerTextField.secureTextEntry = YES;
                playerTextField.tag = 1;
                g_pTextPassword = playerTextField;
                NSString * lpVal = [LYGlobalSettings GetSetting:SETTING_KEY_PASSWORD];
                if ([lpVal length]>0)
                {
                    playerTextField.text = lpVal;
                }
                
            }
            playerTextField.backgroundColor = [UIColor whiteColor];
            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            playerTextField.textAlignment = UITextAlignmentLeft;
            
            playerTextField.delegate = self;
            
            playerTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [playerTextField setEnabled: YES];
            
            [cell.contentView addSubview:playerTextField];
            
            [playerTextField release];
        }
    }
    if ([indexPath section] == 0)
    {
    }
    else
    {
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

#pragma mark 视图初始化
- (void)viewDidLoad
{
    
    int lnHeight = [[UIScreen mainScreen] bounds].size.height ;
    int lnWeight = [[UIScreen mainScreen] bounds].size.width;
    self.m_oImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,lnWeight,lnHeight)]autorelease];
    
    if (lnHeight == 568)
    {
        self.m_oImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else
    {
        self.m_oImageView.image = [UIImage imageNamed:@"Default@2x.png"];
    }
    
    [self.view insertSubview:self.m_oImageView atIndex:0];
    [super viewDidLoad];
    
    //2.判断是否已经登陆
    if ([self IsLogin])
    {
        [self.m_oLoginTableView setHidden:YES];
        [self LoadData];
        
    }else
    {
        [self.m_oLoginTableView setHidden:NO];
        self.m_oLoginTableView.delegate = self;
        self.m_oLoginTableView.dataSource = self;
        self.m_oLoginTableView.bounds  =CGRectMake(164, 220, 240, 70);
    }
    
}

-(BOOL)IsLogin
{
    NSString * lpLogin = [LYGlobalSettings GetSetting:SETTING_KEY_LOGIN];
    BOOL lbLogin = NO;
    if (nil == lpLogin)
    {
        lpLogin = [lpLogin stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([lpLogin caseInsensitiveCompare:@"1"] == NSOrderedSame)
        {
            lbLogin = YES;
        }
    }
    

    return lbLogin;
}

#pragma mark 数据加载

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

- (void) alertLoadFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法获取数据, 重试?"
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    [alert release];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	self->listOfItems = [json objectWithString:responseString error:&error];
    
	if (listOfItems == nil || [listOfItems count]==0)
	{        
        label.text = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
        
        if ([self IsLogin])
        {
            [self.m_oLoginTableView setHidden:YES];
            [self alertLoadFailed];
            
        }else
        {
            [self.m_oLoginTableView setHidden:NO];
            self.m_oLoginTableView.delegate = self;
            self.m_oLoginTableView.dataSource = self;
            self.m_oLoginTableView.bounds  =CGRectMake(164, 220, 240, 70);
        }
        
    }
	else
    {
        [LYGlobalSettings SetSetting:SETTING_KEY_LOGIN apVal:@"1"];
        [self.m_oLoginTableView setHidden:YES];
        [self navigateToPlantView];
	}
    [responseString release];
    [responseData release];
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

#pragma mark 导航到设备

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
        
        LYPlantViewController *detailViewController = (LYPlantViewController*)[mainStoryboard
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




#pragma mark 析构

- (void)dealloc {
    
    [m_oActivityProgressbar release];
    self.m_oImageView = nil;
    
    
    
    [_m_oLoginTableView release];
    [super dealloc];
}



- (void)viewDidUnload {
    
    [self setM_oActivityProgressbar:nil];
    self.m_oImageView = nil;
    [self setM_oImageView:nil];
    [self setM_oImageView:nil];
    
    
    [self setM_oLoginTableView:nil];
    [super viewDidUnload];
}
@end
