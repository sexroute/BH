//
//  LYDiagViewController.m
//  bh
//
//  Created by zhaodali on 13-3-27.
//
//

#import "LYDiagViewController.h"
#import "LYUtility.h"

@interface LYDiagViewController ()

@end



@implementation LYDiagViewController

@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrSet;
@synthesize m_pStrPlant;

@synthesize m_pStrTimeStart;
@synthesize m_pStrChann;

@synthesize m_oResponseData;
@synthesize listOfItems;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.m_oResponseData = [[[NSMutableData alloc]initWithCapacity:0]autorelease];
    self.listOfItems = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

    [self LoadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (self.listOfItems == nil || self.listOfItems.count == 0)
    {
        return  0;
    }
    NSMutableArray * lpFaults = [self.listOfItems objectForKey:@"faults"];
    if (nil == lpFaults)
    {
        return  0;
    }
    return [lpFaults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    }
    
    id lpText = self.listOfItems;
  
    if (nil!= lpText)
    {
        NSMutableArray * lpFaults = [self.listOfItems objectForKey:@"faults"];
       
        if (nil == lpFaults)
        {
            return  0;
        }
        int lnIndex = indexPath.row;
        cell.textLabel.text = [lpFaults objectAtIndex:lnIndex];
           
    }
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark 读取网络数据
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
    NSLog(@"Trend Log: %@\r\n",responseString);
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
    
	self.listOfItems = [json objectWithString:responseString error:&error];
	
	if (listOfItems == nil || [listOfItems count] == 0)
	{
        //弹出网络错误对话框
    }
	else
    {
       
	}
    [responseString release];
    
    self.m_oResponseData = nil;
    
    [connection release];
    
    [self.tableView reloadData];
    
}

#pragma mark HUD指示器
-(void)PopUpIndicator
{
    self->HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self->HUD.mode = MBProgressHUDModeIndeterminate;
	[self.navigationController.view addSubview:self->HUD];
    self->HUD.dimBackground = YES;
    self->HUD.labelText = @"诊断中";
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

-(void)LoadData
{
    [self PopUpIndicator];
    self.m_oResponseData = [[[NSMutableData alloc]initWithCapacity:0]autorelease];
    self.listOfItems = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    NSString * lstrTimeEnd = [LYUtility GetDateFormat:nil];
    NSString * lstrTimeStart = [LYUtility GetRequestDate:GE_LAST_WEEK apDate:nil];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/diag/diag.php",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    

    NSString * lpPostData = [NSString stringWithFormat:@"%@&companyid=%@&factoryid=%@&plantid=%@&channid=%@&machinetype=%d&timestart=%@&timeend=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrCompany,self.m_pStrFactory,self.m_pStrPlant,self.m_pStrChann,self.m_nPlantType,lstrTimeStart,lstrTimeEnd];
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:NETWORK_TIMEOUT];
    NSLog(@"%@\r\n",lpUrl);
    NSLog(@"%@\r\n",lpPostData);
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

}

@end
