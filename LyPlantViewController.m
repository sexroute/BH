//
//  LyPlantViewController.m
//  LuckyNumbers
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LyPlantViewController.h"
#import "DetailViewController.h"
#include "LYCellviewCell.h"
#import "JSON/JSON.h"

@interface LyPlantViewController ()

@end

@implementation LyPlantViewController
@synthesize m_oTableView;

- (void)loadView {
    [super loadView];
     self.m_oTableView.delegate = self;
     self.m_oTableView.dataSource = self;
 
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) doLoadData
{
    responseData = [[NSMutableData data] retain];		
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bhxz808.3322.org:8090/xapi/alarm/gethierarchy/?MIDDLE_WARE_IP=222.199.224.145&MIDDLE_WARE_PORT=7005&SERVER_TYPE=1&companyid=%E5%A4%A7%E5%BA%86%E7%9F%B3%E5%8C%96&factoryid=%E5%8C%96%E5%B7%A5%E4%B8%80%E5%8E%82&setid=&plantid=EC1301&pointname=2H&confirmtype=1&password="]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];			
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self doneLoadingTableViewData];  
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
    
    NSMutableArray * lpListOfItems = [json objectWithString:responseString error:&error];
    
    if (nil!=lpListOfItems) 
    {
        if (nil!=self->listOfItems) 
        {
            [self->listOfItems release];
        }
        
        
        self->listOfItems = lpListOfItems;
        
        [self->listOfItems retain];
        
        [responseString release];	
 #ifdef DEBUG       
        for (int i=0;i<[listOfItems count];i++) 
        {
            id logroupid = [[listOfItems objectAtIndex:i] objectForKey:@"groupid"];
            id locompanyid = [[listOfItems objectAtIndex:i] objectForKey:@"companyid"]; 
            id lofactoryid = [[listOfItems objectAtIndex:i] objectForKey:@"factoryid"];
            id loplantid = [[listOfItems objectAtIndex:i] objectForKey:@"plantid"]; 
            NSMutableString *lpStrGroupNo = [NSMutableString stringWithString:@" "];;
            [lpStrGroupNo appendFormat:@"%@-%@-%@",logroupid,locompanyid,lofactoryid];
            NSString * lpResult = [lpStrGroupNo substringFromIndex:0];  
            lpResult  = [[lpResult
                          stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",lpResult);
        }
#endif
        
        [self.m_oTableView reloadData];
    }
    
    [self doneLoadingTableViewData];  
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    self.navigationItem.title = @"全部设备列表";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _refreshHeaderView=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self->listOfItems count];;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

       
    return 100;
        

}

-(NSString *) GetStringFromID:(id)apData
{
    
    NSString * lpRet = [[NSString alloc]initWithString:(@"")];
    
    if(nil!= apData)
    {
        NSMutableString *lpstrData = [NSMutableString stringWithString:@" "];
        [lpstrData appendFormat:@"%@",apData];
        lpRet = [lpstrData substringFromIndex:0];  
        lpRet  = [[lpRet
                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return lpRet;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LyPlantViewControllerCell";
    LYCellviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    int i= indexPath.row;
    id logroupid = [[listOfItems objectAtIndex:i] objectForKey:@"groupid"];
    id locompanyid = [[listOfItems objectAtIndex:i] objectForKey:@"companyid"]; 
    id lofactoryid = [[listOfItems objectAtIndex:i] objectForKey:@"factoryid"];
    id losetid = [[listOfItems objectAtIndex:i] objectForKey:@"setid"];
    id loplantid = [[listOfItems objectAtIndex:i] objectForKey:@"plantid"]; 
    id loRpm =[[listOfItems objectAtIndex:i] objectForKey:@"rev"]; 
    id loAlarmStatus = [[listOfItems objectAtIndex:i] objectForKey:@"alarm_status"];
    id loStopStatus = [[listOfItems objectAtIndex:i] objectForKey:@"stop_status"];
    NSMutableString *lpStrGroupNo = [NSMutableString stringWithString:@""];
    [lpStrGroupNo appendFormat:@"%@-%@-%@-%@",logroupid,locompanyid,lofactoryid,losetid];
    NSString * lpResult = [lpStrGroupNo substringFromIndex:0];  
    lpResult  = [[lpResult
                  stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"%@",lpResult);
    if (cell == nil) 
    {

        if(!cell)
        {
            //加载自定义表格
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"cell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[LYCellviewCell class]])
                {
                    cell = (LYCellviewCell *)currentObject;
                    cell.m_lblPlantid.text = [self GetStringFromID:loplantid];
                    cell.m_plblOrg.text = lpResult;
                    [cell.m_plblOrg setNumberOfLines:0];
                    [cell.m_plblOrg sizeToFit];
                    NSString * lpStreRpm = [self GetStringFromID:loRpm];
                    int lnValueRpm = [lpStreRpm integerValue];
                    if (lnValueRpm<0) {
                        lpStreRpm = [[NSString alloc] initWithUTF8String:"0"];
                        cell.m_plblRpm.text = lpStreRpm;
                    }else {
                        cell.m_plblRpm.text = [self GetStringFromID:loRpm];
                    }
                    
                    cell.m_plblRpm.textAlignment = UITextAlignmentRight;
                    NSString * lpAlarmStatus = [self GetStringFromID:loAlarmStatus];
                    NSInteger lnAlarmStatus = [lpAlarmStatus integerValue];
                    NSString  * lpStopStatus = [self GetStringFromID:loStopStatus];
                    NSInteger lnStopStatus = [lpStopStatus integerValue];
                    #ifdef DEBUG 
                    NSLog(@"%@:%@",lpAlarmStatus,lpStopStatus);
                    #endif
                    if (nil != lpAlarmStatus) {
                        if (2 == lnAlarmStatus) {
                            cell.m_pImgStatus.backgroundColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1];
                        }else if (1 == lnAlarmStatus) {
                            cell.m_pImgStatus.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:1];
                        } if (1 == lnStopStatus) 
                        {
                            cell.m_pImgStatus.backgroundColor = [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1];
                        }
                            
                    }else {
                        if (1 == lnStopStatus ) 
                        {
                            cell.m_pImgStatus.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:1];
                        } 
                    }
                    break;
                }
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    //cell.text = lpResult; 
 
    return cell;
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

//    NSInteger row = indexPath.row;
//    DetailViewController * detailViewController = [[DetailViewController alloc] initWithNibName:nil  bundle:nil];
//    
//    int i= indexPath.row;
//    
//    detailViewController.m_pData = [listOfItems objectAtIndex:i];
//
//	[self.navigationController pushViewController:detailViewController animated:YES]; 	
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
//    [self performSegueWithIdentifier: @"1" sender: self];
//    return;
//1.load from storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    DetailViewController *detailViewController = (DetailViewController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"DetailView"];
    int i= indexPath.row;
    detailViewController.m_pData = [listOfItems objectAtIndex:i];
    [self.navigationController pushViewController:detailViewController animated:YES];
    return;
//2.load from xib
//    DetailViewController *detailViewController
//    = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
//    int i= indexPath.row;    
//    detailViewController.m_pData = [listOfItems objectAtIndex:i];
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    
//    [detailViewController release];
//    return;
//3.load by manual
//    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
//     
//    int i= indexPath.row;
//    
//     detailViewController.m_pData = [listOfItems objectAtIndex:i];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
     
}



- (void)dealloc {
    _refreshHeaderView = nil;
    [m_oTableView release];
    [super dealloc];
    
}

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    [self doLoadData];
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //    NSString *Title;
    NSLog(@"%@",[segue identifier]);
    if ([[segue identifier] isEqualToString:@"ShowDetail"])
    {        
        NSLog(@"%@",[segue identifier]);
    }
}
@end
