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

       
    return 110;
        

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
    id loRpm =[[listOfItems objectAtIndex:i] objectForKey:@"rev1"]; 
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
                    cell.m_plblRpm.text = [self GetStringFromID:loRpm];
                    cell.m_plblRpm.textAlignment = UITextAlignmentRight;
                    NSString * lpAlarmStatus = [self GetStringFromID:loAlarmStatus];
                    NSInteger lnAlarmStatus = [lpAlarmStatus integerValue];
                    NSString  * lpStopStatus = [self GetStringFromID:loStopStatus];
                    NSInteger lnStopStatus = [lpStopStatus integerValue];
                    NSLog(@"%@:%@",lpAlarmStatus,lpStopStatus);
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

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{ 
    NSInteger row = indexPath.row;
	
    DetailViewController * detailViewController = [[DetailViewController alloc] initWithNibName:nil  bundle:nil]; 
    
    int i= indexPath.row;
    
    detailViewController.m_pData = [listOfItems objectAtIndex:i];

		[self.navigationController pushViewController:detailViewController animated:YES]; 	
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
    
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    
     int i= indexPath.row;
    
     detailViewController.m_pData = [listOfItems objectAtIndex:i];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}



- (void)dealloc {
    _refreshHeaderView = nil;
    [m_oTableView release];
    [super dealloc];
    
}

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
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
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
@end
