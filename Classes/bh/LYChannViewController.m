//
//  LYChannViewController.m
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#import "LYChannViewController.h"
#import "LYChannInfoViewController.h"
#import "ChannInfo.h"
#import "LYGlobalSettings.h"
#import "LYDiagViewController.h"
#import "LYUtility.h"
#import "LYAlarmedChannCell.h"
#import "NVUIGradientButton.h"
#import "ASIFormDataRequest.h"
@interface LYChannViewController ()


@end

@implementation LYChannViewController


@synthesize m_pProgressBar;
@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrSet;
@synthesize m_pStrPlant;
@synthesize VibChanns;
@synthesize DynChanns;
@synthesize ProcChanns;
@synthesize m_pStrTimeStart;
@synthesize m_strChannDiaged;
@synthesize m_pResponseData;

#pragma mark init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
  
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.m_pProgressBar stopAnimating];
    [self LoadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"测点列表";
}

- (void)viewDidUnload
{
    
    self.m_pProgressBar = nil;
    [self setM_pProgressBar:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)LoadData
{
    [self LoadDataASIHTTPRequest];
}
#pragma mark ASIHTTPRequest Methods
- (void)LoadDataASIHTTPRequest
{
    [self PopUpIndicator];
    self.ProcChanns = [[[NSMutableArray alloc]initWithCapacity:10] autorelease];
    self.VibChanns = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    self.DynChanns = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    
    self.m_pResponseData = [NSMutableData data];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/pointalarm/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    NSString * lpPostData = [NSString stringWithFormat:@"%@&groupid=%@&companyid=%@&factoryid=%@&setid=%@&plantid=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrGroup,self.m_pStrCompany,self.m_pStrFactory,self.m_pStrSet,self.m_pStrPlant];
#ifdef DEBUG
    NSLog(@"%@",lpUrl);
    NSLog(@"%@",[self.m_pStrPlant class]);
#endif
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
    
    self.m_pResponseData =[NSMutableData dataWithData:[request responseData]] ;
    //	[self.m_pProgressBar stopAnimating];
	[self HiddeIndicator];
	NSString *responseString = [[NSString alloc] initWithData:self.m_pResponseData encoding:NSUTF8StringEncoding];
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
    if (nil!= self->listOfItems)
    {
        [self->listOfItems release];
        self->listOfItems = nil;
    }
	self->listOfItems = [json objectWithString:responseString error:&error];
	
	if (listOfItems == nil  || [listOfItems count] == 0)
	{
        [responseString release];

        self.m_pResponseData = nil;
  
        [self alertLoadFailed:nil];
    }
	else
    {
        NSMutableArray * loDatas = [[listOfItems objectAtIndex:0] objectForKey:@"data"];
        for (int i=0;i<[loDatas count];i++)
        {
            
            // id loChannName = [[loDatas objectAtIndex:i] objectForKey:@"name"];
            id loChannType = [[loDatas objectAtIndex:i] objectForKey:@"chann_type"];
            // NSLog(@"%@|%@",loChannName,[loDatas objectAtIndex:i]);
            
            NSNumber *val = loChannType;
            int lnChannType = [val intValue];
            id loObj = [loDatas objectAtIndex:i];
            switch (lnChannType) {
                case GE_ALLPROC:
                case GE_PRESSCHANN:
                case GE_TEMPCHANN:
                case GE_FLUXCHANN:
                case GE_OTHERCHANN:
                case GE_IMPACTCHANN:
                    [self.ProcChanns addObject:loObj];
                    continue;
                    break;
                case GE_VIBCHANN:
                case GE_AXIALCHANN:
                case GE_AXISLOCATIONCHANN:
                    [self.VibChanns addObject:loObj];
                    continue;
                    break;
                case GE_DYNPRESSCHANN:
                case GE_RODSINKCHANN:
                case GE_DYNSTRESSCHANN:
                    [self.DynChanns addObject:loObj];
                    continue;
                    break;
                default:
                    break;
            }
            
        }
        
        [responseString release];

         self.m_pResponseData = nil;

        [self.tableView reloadData];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self HiddeIndicator];
	//弹出网络错误对话框
    [self alertLoadFailed:nil];
    
    
}


#pragma mark NSURLConnection affairs

-(void)loadDataNSURLConnection
{
    //[self.m_pProgressBar startAnimating];
    [self PopUpIndicator];
    self.ProcChanns = [[[NSMutableArray alloc]initWithCapacity:10] autorelease];
    self.VibChanns = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    self.DynChanns = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    
    self.m_pResponseData = nil;
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/pointalarm/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    NSString * lpPostData = [NSString stringWithFormat:@"%@&groupid=%@&companyid=%@&factoryid=%@&setid=%@&plantid=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrGroup,self.m_pStrCompany,self.m_pStrFactory,self.m_pStrSet,self.m_pStrPlant];
#ifdef DEBUG
    NSLog(@"%@",lpUrl);
    NSLog(@"%@",[self.m_pStrPlant class]);
#endif
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:NETWORK_TIMEOUT];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.m_pResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.m_pResponseData appendData:data];
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

	//弹出网络错误对话框
    [self HiddeIndicator];
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
        [self LoadData];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[self HiddeIndicator];
	NSString *responseString = [[NSString alloc] initWithData:self.m_pResponseData encoding:NSUTF8StringEncoding];
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
    if (nil!= self->listOfItems)
    {
        [self->listOfItems release];
        self->listOfItems = nil;
    }
	self->listOfItems = [json objectWithString:responseString error:&error];
	
	if (listOfItems == nil  || [listOfItems count] == 0)
	{
        [responseString release];
        
        self.m_pResponseData = nil;
        [connection release];
        [self alertLoadFailed:nil];
    }
	else
    {
        NSMutableArray * loDatas = [[listOfItems objectAtIndex:0] objectForKey:@"data"];
        for (int i=0;i<[loDatas count];i++)
        {

           // id loChannName = [[loDatas objectAtIndex:i] objectForKey:@"name"];
            id loChannType = [[loDatas objectAtIndex:i] objectForKey:@"chann_type"];
           // NSLog(@"%@|%@",loChannName,[loDatas objectAtIndex:i]);
           
            NSNumber *val = loChannType;
            int lnChannType = [val intValue];
            id loObj = [loDatas objectAtIndex:i];
            switch (lnChannType) {
                case GE_ALLPROC:
                case GE_PRESSCHANN:
                case GE_TEMPCHANN:
                case GE_FLUXCHANN:
                case GE_OTHERCHANN:
                case GE_IMPACTCHANN:
                    [self.ProcChanns addObject:loObj];                    
                    continue;
                    break;
                case GE_VIBCHANN:
                case GE_AXIALCHANN:
                case GE_AXISLOCATIONCHANN:
                    [self.VibChanns addObject:loObj];
                    continue;
                    break;
                case GE_DYNPRESSCHANN:
                case GE_RODSINKCHANN:
                case GE_DYNSTRESSCHANN:
                    [self.DynChanns addObject:loObj];
                    continue;
                    break;
                default:
                    break;
            }
           
        }
        
        [responseString release];
        
        self.m_pResponseData = nil;
        [connection release];
        [self.tableView reloadData];
	}

    
}




#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"振动测点", @"Vib Chann");
            break;
        case 1:
            title = NSLocalizedString(@"动态测点", @"Dyn Chann");
            break;
        case 2:
            title = NSLocalizedString(@"过程量测点", @"Proc Chann");
            break;
        default:
            break;
    }
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [self.VibChanns count];
            break;
        case 1:
            return [self.DynChanns count];
            break;
        case 2:
            return [self.ProcChanns count];
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id lpText = nil;
    switch (indexPath.section) {
        case 0:
            lpText = [ self.VibChanns objectAtIndex:indexPath.row];
            break;
        case 1:
            lpText = [ self.DynChanns objectAtIndex:indexPath.row];
            break;
        case 2:
            lpText = [ self.ProcChanns objectAtIndex:indexPath.row];
            break;
        default:
            
            break;
    }
    
    if (nil!= lpText)
    {
        NSString * lpObj = [lpText objectForKey:@"alarm_status"];
        int lnAlarmStatus = [(NSNumber *)lpObj intValue];
        if (lnAlarmStatus >0)
        {
            return  100;
        }else
        {
            return  50;
        }
    }
    
    return  50;
}

-(void)addDiagButtonToCell:(LYAlarmedChannCell *)cell buttonColor:(UIColor *) buttonColor textcolor:(UIColor *) textcolor buttonTitle:(NSString *) buttonTitle
{
    if (nil!= cell)
    {
         CGRect frame =CGRectMake(22,45,200,35);
        
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
             int lnOffset = 30;
            frame =CGRectMake(22+lnOffset,45,200,35);

         }
        

        NVUIGradientButton *button=[[[NVUIGradientButton alloc]initWithFrame:frame ]autorelease];
        button.frame=frame;
        button.text = buttonTitle;
        button.backgroundColor=[UIColor clearColor];
        button.tag=2000;
        button.textColor =textcolor;
        button.textShadowColor = [UIColor darkGrayColor];
        button.tintColor = buttonColor;
        button.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:(CGFloat)190/255 blue:(CGFloat)190/255 alpha:1];
        button.rightAccessoryImage = [UIImage imageNamed:@"arrow"];

        [button addTarget:self action:@selector(DiagButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];

        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChannCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"lyAlarmedChannCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[LYAlarmedChannCell class]])
            {
                cell = (LYAlarmedChannCell *)currentObject;
                
                break;
            }
        }
    }
    
    id lpText = nil;
    switch (indexPath.section) {
        case 0:
            lpText = [ self.VibChanns objectAtIndex:indexPath.row];
            break;
        case 1:
            lpText = [ self.DynChanns objectAtIndex:indexPath.row];
            break;
        case 2:
            lpText = [ self.ProcChanns objectAtIndex:indexPath.row];
            break;
        default:
            
            break;
    }
    if (nil!= lpText)
    {
        NSString * lpName = [lpText objectForKey:@"name"];
        NSNumber *lpValue = [lpText objectForKey:@"val"];
        float lfValue = [lpValue floatValue];
        NSString * lpUnit = [lpText objectForKey:@"unit"];
        
        NSString * lpObj = [lpText objectForKey:@"alarm_status"];
        UIColor * buttonColor = nil;
        
        NSString * lpTitle = nil;
        int lnAlarmStatus = [(NSNumber *)lpObj intValue];
        
        switch (lnAlarmStatus) {
            case 0:
                
                break;
            case 1:
                
              
                
                self.m_strChannDiaged = lpName;
                self.m_pStrTimeStart = [lpText objectForKey:@"updatedatetime"];
                 buttonColor = [[[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:1.0]autorelease];
                lpTitle = [NSString stringWithFormat:@"自动诊断%@测点",@"报警"];
                [self addDiagButtonToCell:(LYAlarmedChannCell *)cell  buttonColor:buttonColor textcolor:[UIColor blackColor] buttonTitle:lpTitle];
//                ((LYAlarmedChannCell *)cell).m_oStatus.textColor = buttonColor;
//                ((LYAlarmedChannCell *)cell).m_oStatus.text = [NSString stringWithFormat:@"状态: 报警"];
              break;
            case 2:
               
              
                
                self.m_strChannDiaged = lpName;
                self.m_pStrTimeStart = [lpText objectForKey:@"updatedatetime"];
                 buttonColor =[ [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]autorelease];
                lpTitle = [NSString stringWithFormat:@"自动诊断%@测点",@"危险"];
                [self addDiagButtonToCell:(LYAlarmedChannCell *)cell  buttonColor:buttonColor textcolor:[UIColor whiteColor] buttonTitle:lpTitle];
//                ((LYAlarmedChannCell *)cell).m_oStatus.textColor = buttonColor;
//                ((LYAlarmedChannCell *)cell).m_oStatus.text = [NSString stringWithFormat:@"状态: 危险"];
                
                break;
            default:
                break;
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            ((LYAlarmedChannCell *)cell).m_oLabel.text = [NSString stringWithFormat:@"       %@    %6.2f%@",lpName,lfValue ,lpUnit];
        }else
        {
             ((LYAlarmedChannCell *)cell).m_oLabel.text = [NSString stringWithFormat:@"%@    %6.2f%@",lpName,lfValue ,lpUnit];
        }
       
        
                                   

    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;

}

- (IBAction)DiagButtonClicked:(UIBarButtonItem *)sender
{
    LYDiagViewController * lpChannView = nil;

    
    UIStoryboard *mainStoryboard = nil;
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                               bundle: nil];
    lpChannView =(LYDiagViewController *)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"LYDiagViewController"];
    lpChannView.m_pStrChann = self.m_strChannDiaged;
    lpChannView.m_pStrCompany = self.m_pStrCompany;
    lpChannView.m_pStrFactory = self.m_pStrFactory;
    lpChannView.m_pStrGroup = self.m_pStrGroup;
    lpChannView.m_pStrPlant = self.m_pStrPlant;
    lpChannView.m_pStrSet = self.m_pStrSet;
    lpChannView.m_pStrTimeStart = self.m_pStrTimeStart;
    lpChannView.m_nPlantType = self.m_nPlantType;
    self.title = @"返回";
    [self.navigationController pushViewController:lpChannView animated:YES];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = self.storyboard;
    
    LYChannInfoViewController *ChanninfoDetailViewController = (LYChannInfoViewController*)[mainStoryboard
                                                                                            instantiateViewControllerWithIdentifier: @"ChannInfo"];
    int i= indexPath.row;
    int lnSection = indexPath.section;
    id loObj = nil;
    switch (lnSection) {
        case 0:
            loObj = [self.VibChanns objectAtIndex:i];
            break;
        case 1:
            loObj = [self.DynChanns objectAtIndex:i];
            break;
        case 2:
            loObj = [self.ProcChanns objectAtIndex:i];
            break;
        default:
            break;
    }
    ChanninfoDetailViewController.m_pStrCompany = self.m_pStrCompany;
    ChanninfoDetailViewController.m_pStrFactory = self.m_pStrFactory;
    ChanninfoDetailViewController.m_pStrPlant = self.m_pStrPlant;
    ChanninfoDetailViewController.m_pData = loObj;
    
    [self.navigationController pushViewController:ChanninfoDetailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
//                                                             bundle: nil];
    
    UIStoryboard *mainStoryboard = self.storyboard;

    LYChannInfoViewController *ChanninfoDetailViewController = (LYChannInfoViewController*)[mainStoryboard
                                                                         instantiateViewControllerWithIdentifier: @"ChannInfo"];
    int i= indexPath.row;
    int lnSection = indexPath.section;
    id loObj = nil;
    switch (lnSection) {
        case 0:
            loObj = [self.VibChanns objectAtIndex:i];
            break;
        case 1:
            loObj = [self.DynChanns objectAtIndex:i];
            break;
        case 2:
            loObj = [self.ProcChanns objectAtIndex:i];
            break;
        default:
            break;
    }
    ChanninfoDetailViewController.m_pStrCompany = self.m_pStrCompany;
    ChanninfoDetailViewController.m_pStrFactory = self.m_pStrFactory;
    ChanninfoDetailViewController.m_pStrPlant = self.m_pStrPlant;
    ChanninfoDetailViewController.m_pData = loObj;
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:ChanninfoDetailViewController animated:YES];
}

- (void)dealloc
{


    self.m_pResponseData = nil;
    self.m_pStrCompany = nil;
    self.m_pStrFactory = nil;
    self.m_pStrGroup = nil;
    self.m_pStrPlant = nil;
    self.m_pStrSet = nil;
    self.VibChanns = nil;
    self.DynChanns = nil;
    self.ProcChanns = nil;
    self.m_pStrTimeStart = nil;
    self.m_strChannDiaged = nil;
    
    [super dealloc];
}
@end
