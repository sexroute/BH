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
#import "LYTabBarViewController.h"



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
            [LYGlobalSettings SetSetting:SETTING_KEY_PASSWORD apVal:g_pTextPassword.text];
            [g_pTextPassword becomeFirstResponder];
            break;
        case 1:
            [self.m_oActivityProgressbar setHidden:NO];
            [LYGlobalSettings SetSetting:SETTING_KEY_USER apVal:g_pTextUserName.text];
            [LYGlobalSettings SetSetting:SETTING_KEY_PASSWORD apVal:tf.text];
            [self.m_oLoginTableView setHidden:YES];
            [self.m_oLogginButton setHidden:TRUE];
            [self LoadData];
            [g_pTextPassword resignFirstResponder];
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
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 185, 40)];
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
                    //playerTextField.text = lpVal;
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
                    //playerTextField.text = lpVal;
                }
                
            }
            playerTextField.backgroundColor = [UIColor whiteColor];
            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            playerTextField.textAlignment = UITextAlignmentLeft;
            
            playerTextField.delegate = self;
            
            playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
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
    return 40;
}


#pragma mark 视图初始化
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    [self InitUI];

}
-(void)viewDidAppear:(BOOL)animated
{
    if ([self IsLogin])
    {
        [self.m_oLoginTableView setHidden:YES];
        [self.m_oLabelLogin setHidden:YES];
        [self.m_oLogginButton setHidden:YES];
    }else
    {
        [self.m_oLoginTableView setHidden:NO];
        [self.m_oLabelLogin setHidden:NO];
        [self.m_oLogginButton setHidden:NO];
    }

}

-(void) InitUI
{
    //1.根据分辨率和设备类型处理背景图片
    int lnHeight = [[UIScreen mainScreen] bounds].size.height ;
    int lnWeight = [[UIScreen mainScreen] bounds].size.width;
    self.m_oImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,lnWeight,lnHeight)]autorelease];
    CGRect frame =self.m_oLoginTableView.frame;
    
    switch (lnHeight)
    {
        case 480:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.m_oImageView.image = [UIImage imageNamed:@"Default@2x.png"];
            }
            else
            {
                self.m_oImageView.image = [UIImage imageNamed:@"Default.png"];
            }
            
            frame.origin.x = self.m_oLoginTableView.frame.origin.x;
            
            
            self.m_oLoginTableView.frame = frame;
            break;
            
        case 568:
            self.m_oImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
            frame =self.m_oLoginTableView.frame;
            frame.origin.x = self.m_oLoginTableView.frame.origin.x;
            frame.origin.y = 140;
            self.m_oLoginTableView.frame = frame;
            break;
            
        case 1024:
            
            frame =self.m_oLoginTableView.frame;
            frame.origin.x = self.m_oLoginTableView.frame.origin.x;
            if(IS_RETINA)
            {
                frame.origin.y = 60;
                self.m_oImageView.image = [UIImage imageNamed:@"Default-Portrait@2x~ipad.png"];
            }else
            {
                self.m_oImageView.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
                frame.origin.y = 30;
            }
            self.m_oLoginTableView.frame = frame;
            break;
        default:
            self.m_oImageView.image = [UIImage imageNamed:@"Default.png"];
            break;
    }
    
    
    [self.view insertSubview:self.m_oImageView atIndex:0];
     
    frame = self.m_oActivityProgressbar.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height /2 - frame.size.height / 2;
    self.m_oActivityProgressbar.frame = frame;
    //2.判断是否已经登陆
   self.m_oLoginTableView.bounds  =CGRectMake(164, 220, 240, 80);
    if ([self IsLogin])
    {
        [self.m_oActivityProgressbar setHidden:NO];
        [self.m_oLoginTableView setHidden:YES];
        self.m_oLoginTableView.delegate = self;
        self.m_oLoginTableView.dataSource = self;
        [self LoadData];
        
    }else
    {
        [self.m_oActivityProgressbar setHidden:YES];
        [self.m_oActivityProgressbar stopAnimating];
        [self.m_oLoginTableView setHidden:NO];
        self.m_oLoginTableView.delegate = self;
        self.m_oLoginTableView.dataSource = self;
        

        [self.m_oLogginButton setHidden:NO];
    }
    
    
    //3.登录按钮处理
    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    
    
    [self.m_oLabelLogin addGestureRecognizer:tapGestureTel];
    [self.m_oLogginButton addGestureRecognizer:tapGestureTel];
    
    frame = self.m_oLogginButton.frame;
    frame.origin.x = self.m_oLoginTableView.frame.origin.x;
    frame.origin.y = self.m_oLoginTableView.frame.origin.y+self.m_oLoginTableView.frame.size.height+5;
    self.m_oLogginButton.frame = frame;
}
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    [LYGlobalSettings SetSetting:SETTING_KEY_USER apVal:g_pTextUserName.text];
    [LYGlobalSettings SetSetting:SETTING_KEY_PASSWORD apVal:g_pTextPassword.text];
    [self.m_oLoginTableView setHidden:YES];
    [self.m_oActivityProgressbar setHidden:NO];
    [self.m_oActivityProgressbar startAnimating];
    [self LoadData];
    [g_pTextPassword resignFirstResponder];
    [self.m_oLogginButton setHidden:TRUE];
}
-(BOOL)IsLogin
{
    NSString * lpLogin = [LYGlobalSettings GetSetting:SETTING_KEY_LOGIN];
    BOOL lbLogin = NO;
    if (nil != lpLogin)
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
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/alarm/gethierarchy/",[LYGlobalSettings GetSetting:SETTING_KEY_SERVER_ADDRESS]];
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

-(BOOL)IsReturnDataValid:(NSMutableArray *) apData
{
    BOOL lbRet = NO;
    if ([apData isKindOfClass:[NSMutableArray class]])
    {
        id obj = [apData objectAtIndex:0];
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            id loRet = [obj objectForKey:@"retvalue"];
            int lnRet = 1;
            if ([loRet isKindOfClass:[NSNumber class]])
            {
                lnRet = [(NSNumber*)loRet intValue];
            }
            if (nil == loRet || lnRet!=0)
            {
                lbRet = YES;
            }
        }
    }
    
    return  lbRet;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
	self->listOfItems = [json objectWithString:responseString error:&error];
    
	if (![self IsReturnDataValid:self->listOfItems])
	{
        BOOL isNetworkError = NO;
        //1.网络等错误
        if ([error isKindOfClass:[NSError class]])
        {
            label.text = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
            isNetworkError=YES;
        }
        
        if (isNetworkError)
        {
            [self alertLoadFailed];
            
        }else
        {
            [self alertWrongLogin];
            [self.m_oLoginTableView setHidden:NO];
            [LYGlobalSettings SetSetting:SETTING_KEY_LOGIN apVal:@"0"];
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
    self->responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    
    [self alertLoadFailed];
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

#pragma mark 错误提醒
- (void) alertWrongLogin
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆错误" message:nil
												   delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    [alert release];
}

- (void) alertLoadFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法获取数据, 重试?"
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 1;
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    if (nil!=actionSheet && actionSheet.tag== 1)
    {
        if (buttonIndex == 0)
        {
            if ([self IsLogin])
            {
                [self navigateToPlantView];
                
            }else
            {
                [self.m_oActivityProgressbar setHidden:TRUE];
                [self.m_oLoginTableView setHidden:NO];
                [self.m_oLogginButton setHidden:NO];
            }
            
        }
        else
        {
            [self.m_oActivityProgressbar startAnimating];
            [self LoadData];
        }
    }else
    {
        
        [self.m_oActivityProgressbar setHidden:TRUE];
        [self.m_oLoginTableView setHidden:NO];
        [self.m_oLogginButton setHidden:NO];
    }
    
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
        
        
        LYTabBarViewController  *lpviewController = (LYTabBarViewController *)[mainStoryboard
                                                                               instantiateViewControllerWithIdentifier: @"tabbar"];
        
        lpviewController.m_oListView = self->listOfItems;

        [self presentViewController:lpviewController animated:NO completion:nil];

        [UIView commitAnimations];
        return;
        
        
    }
}




#pragma mark 析构

- (void)dealloc {
    
    [m_oActivityProgressbar release];
    self.m_oImageView = nil;
    
    
    
    [_m_oLoginTableView release];
    [_m_oLogginButton release];
    [_m_oLabelLogin release];
    [super dealloc];
}



- (void)viewDidUnload {
    
    [self setM_oActivityProgressbar:nil];
    self.m_oImageView = nil;
    [self setM_oImageView:nil];
    [self setM_oImageView:nil];
    
    
    [self setM_oLoginTableView:nil];
    [self setM_oLogginButton:nil];
    [self setM_oLabelLogin:nil];
    [super viewDidUnload];
}
@end
