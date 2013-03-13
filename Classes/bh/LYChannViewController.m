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



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
  
    return self;
}

-(void)loadData
{
    [self.m_pProgressBar startAnimating];
  
    self.ProcChanns = [[[NSMutableArray alloc]initWithCapacity:10] autorelease];
    self.VibChanns = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    self.DynChanns = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    
    responseData = [[NSMutableData data] retain];
    NSString * lpUrl = [NSString stringWithFormat:@"%@/alarm/pointalarm/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    NSString * lpPostData = [NSString stringWithFormat:@"%@&groupid=%@&companyid=%@&factoryid=%@&setid=%@&plantid=%@",[LYGlobalSettings GetPostDataPrefix],self.m_pStrGroup,self.m_pStrCompany,self.m_pStrFactory,self.m_pStrSet,self.m_pStrPlant];

    NSLog(@"%@",lpUrl);
    NSLog(@"%@",[self.m_pStrPlant class]);
    NSURL *aUrl = [NSURL URLWithString:lpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self loadData];

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void) alertLoadFailed:(NSString * )apstrError
{
    NSString * lpStr = [NSString stringWithFormat:@"无法获取数据:%@\r\n重试?",apstrError];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:lpStr
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [self.m_pProgressBar stopAnimating];
    [alert show];
    [alert release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
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
        [self loadData];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[self.m_pProgressBar stopAnimating];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
    if (nil!= self->listOfItems) {
        [self->listOfItems release];
        self->listOfItems = nil;
    }
	self->listOfItems = [json objectWithString:responseString error:&error];
	
	if (listOfItems == nil || [listOfItems count] == 0)
	{
        //弹出网络错误对话框
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
	}
    [responseString release];
    [self->responseData release];
     self->responseData = nil;
    [connection release];
    [self.tableView reloadData];
    
}


- (void)viewDidUnload
{
    [m_pProgressBar release];
    m_pProgressBar = nil;
    [self setM_pProgressBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %6.2f%@",lpName,lfValue ,lpUnit];

    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
    
    [self.navigationController pushViewController:ChanninfoDetailViewController animated:YES];
}

- (void)dealloc {
    if (nil!=self->responseData) {
        [self->responseData release];
        self->responseData = nil;
    }

    self.m_pStrCompany = nil;
    self.m_pStrFactory = nil;
    self.m_pStrGroup = nil;
    self.m_pStrPlant = nil;
    self.m_pStrSet = nil;
    self.VibChanns = nil;
    self.DynChanns = nil;
    self.ProcChanns = nil;
    [m_pProgressBar release];
    [super dealloc];
}
@end
