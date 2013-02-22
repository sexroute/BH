//
//  LyPlantViewController.m
//  LuckyNumbers
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LyPlantViewController.h"
#import "LYDetailViewController.h"
#include "LYCellviewCell.h"
#import "JSON/JSON.h"
#import "LYGlobalSettings.h"

@interface LyPlantViewController ()

@end

@implementation LyPlantViewController


@synthesize m_oActiveIndicator;
@synthesize m_oTableView;

@synthesize m_pButtonAlarm;
@synthesize m_pButtonAll;
@synthesize m_pButtonDanger;
@synthesize m_pButtonStop;
@synthesize m_pButtonNormal;

@synthesize m_oAlarmPlants;
@synthesize m_oDangerPlants;
@synthesize m_oStopPlants;
@synthesize m_oNormalPlants;

@synthesize responseData;

- (void)loadView {
    [super loadView];
     self.m_oTableView.delegate = self;
     self.m_oTableView.dataSource = self;
    if (nil == self.m_oAlarmPlants) {
        self.m_oDangerPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
        self.m_oAlarmPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
        self.m_oStopPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
        self.m_oNormalPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.m_oActiveIndicator stopAnimating];
    if (_refreshHeaderView == nil)
    {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    self.navigationItem.title = @"全部设备列表";
    [self.navigationController setToolbarHidden:FALSE animated:FALSE];
    
    self.m_pButtonAll = [[ UIBarButtonItem alloc ] initWithTitle:   @"全部"
                                                                     style: UIBarButtonItemStyleDone
                                                                    target: self
                                                                    action: @selector(onButtonAllDeviceSelected:) ];
    
    self->m_nFilterStatus = ALL;
    
    self.m_pButtonAlarm  = [[ UIBarButtonItem alloc ] initWithTitle: @"报警"
                                                                      style: UIBarButtonItemStylePlain
                                                                     target: self
                                                                     action: @selector(onButtonAlarmDeviceSelected:) ];
    self.m_pButtonDanger = [[ UIBarButtonItem alloc ] initWithTitle: @"危险"
                                                                     style: UIBarButtonItemStylePlain
                                                                    target: self
                                                                    action: @selector(onButtonDangerDeviceSelected:) ];
    
    self.m_pButtonStop = [[ UIBarButtonItem alloc ] initWithTitle: @"停车"
                                                                      style: UIBarButtonItemStylePlain
                                                                     target: self
                                                                     action: @selector(onButtonStopDeviceSelected:) ];
    
    self.m_pButtonNormal = [[ UIBarButtonItem alloc ] initWithTitle: @"正常"
                                                            style: UIBarButtonItemStylePlain
                                                           target: self
                                                           action: @selector(onButtonNormalDeviceSelected:) ];

     UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]autorelease];
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem, self.m_pButtonAll, flexItem, self.m_pButtonDanger , flexItem, self.m_pButtonAlarm, flexItem,self.m_pButtonNormal,flexItem, self.m_pButtonStop, flexItem, nil]];
   }
- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];
}
- (void)viewDidUnload
{

    
    [self setM_oTableView:nil];
    [self setM_oActiveIndicator:nil];
    [super viewDidUnload];
    _refreshHeaderView=nil;
    self.m_oAlarmPlants = nil;
    self.m_oDangerPlants = nil;
    self.m_oStopPlants = nil;
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
    NSMutableArray * lpPlants =  [self GetCurrentDataSource];   
    int lnCount = [lpPlants count];
    return lnCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    return 100;
}

-(NSString *) GetStringFromID:(id)apData
{
    
    NSString * lpRet = [NSString stringWithFormat:@""];
    
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
    NSMutableArray * lpPlants =  [self GetCurrentDataSource];
    if (nil == lpPlants || [lpPlants count] ==0) {
        return nil;
    }
    int i= indexPath.row;
    id logroupid = [[lpPlants objectAtIndex:i] objectForKey:@"groupid"];
    id locompanyid = [[lpPlants objectAtIndex:i] objectForKey:@"companyid"]; 
    id lofactoryid = [[lpPlants objectAtIndex:i] objectForKey:@"factoryid"];
    id losetid = [[lpPlants objectAtIndex:i] objectForKey:@"setid"];
    id loplantid = [[lpPlants objectAtIndex:i] objectForKey:@"plantid"]; 
    id loRpm =[[lpPlants objectAtIndex:i] objectForKey:@"rev"]; 
    id loAlarmStatus = [[lpPlants objectAtIndex:i] objectForKey:@"alarm_status"];
    id loStopStatus = [[lpPlants objectAtIndex:i] objectForKey:@"stop_status"];
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
                        lpStreRpm = [[[NSString alloc] initWithUTF8String:"0"]autorelease];
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
//                    NSLog(@"%@:%@",lpAlarmStatus,lpStopStatus);
                    #endif
                    if (nil != lpAlarmStatus) {
                        if (2 == lnAlarmStatus) {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1]autorelease];
                        }else if (1 == lnAlarmStatus) {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:1]autorelease];
                        } if (1 == lnStopStatus) 
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1]autorelease];
                        }
                            
                    }else {
                        if (1 == lnStopStatus ) 
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:1]autorelease];
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

-(NSMutableArray *)GetCurrentDataSource
{
    NSMutableArray * lpPlants =  nil;
    switch (self->m_nFilterStatus)
    {
        case ALL:
            lpPlants = self->listOfItems;
            break;
        case ALARM:
            lpPlants = self.m_oAlarmPlants;
            break;
        case DANGER:
            lpPlants = self.m_oDangerPlants;
            break;
        case STOPPED:
            lpPlants = self.m_oStopPlants;
            break;
        case NORMAL:
            lpPlants = self.m_oNormalPlants;
            break;
        default:
            lpPlants = self->listOfItems;
            break;
    }
    
    return lpPlants;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1.load from storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    LYDetailViewController *detailViewController = (LYDetailViewController*)[mainStoryboard
                                                                         instantiateViewControllerWithIdentifier: @"DetailView"];
    int i= indexPath.row;
    
    detailViewController.m_pData = [[self GetCurrentDataSource] objectAtIndex:i];
    [self.navigationController setToolbarHidden:YES animated:TRUE] ;
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


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    LYDetailViewController *detailViewController = (LYDetailViewController*)[mainStoryboard
                                                                         instantiateViewControllerWithIdentifier: @"DetailView"];
    int i= indexPath.row;
    
    [self.navigationController setToolbarHidden:YES animated:TRUE] ;
    detailViewController.m_pData = [[self GetCurrentDataSource] objectAtIndex:i];
    [self.navigationController pushViewController:detailViewController animated:YES];
    return;

}


#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
////1.load from storyboard
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
//                                                             bundle: nil];
//    
//    DetailViewController *detailViewController = (DetailViewController*)[mainStoryboard
//                                                       instantiateViewControllerWithIdentifier: @"DetailView"];
//    int i= indexPath.row;
//    
//    detailViewController.m_pData = [listOfItems objectAtIndex:i];
//    [self.navigationController setToolbarHidden:YES animated:TRUE] ;
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    return;
////2.load from xib
////    DetailViewController *detailViewController
////    = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
////    int i= indexPath.row;    
////    detailViewController.m_pData = [listOfItems objectAtIndex:i];
////    [self.navigationController pushViewController:detailViewController animated:YES];
////    
////    [detailViewController release];
////    return;
////3.load by manual
////    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
////     
////    int i= indexPath.row;
////    
////     detailViewController.m_pData = [listOfItems objectAtIndex:i];
////     // ...
////     // Pass the selected object to the new view controller.
////     [self.navigationController pushViewController:detailViewController animated:YES];
////     [detailViewController release];
//     
//}



- (void)dealloc {
    _refreshHeaderView = nil;
    [m_oTableView release];

    [m_oActiveIndicator release];
    [super dealloc];
    
}

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo

        [self doLoadData];
        _reloading = YES;
   

    
}

- (void)doneLoadingTableViewData
{
    
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
#pragma mark -
#pragma mark TableViewFilter Methods

-(void) PreparePlantsData
{
    self.m_oDangerPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
    self.m_oAlarmPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
    self.m_oStopPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
    self.m_oNormalPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
    if (nil != self->listOfItems)
    {
        int lnSize = [self->listOfItems count];
        for (int i=0; i<lnSize; i++)
        {
            id loObj = [listOfItems objectAtIndex:i];
            if (nil == loObj) {
                continue;
            }
            id loAlarmStatus = [loObj objectForKey:@"alarm_status"];
           id loStopStatus = [loObj objectForKey:@"stop_status"];
            if (nil!= loAlarmStatus && nil!= loStopStatus)
            {
                NSNumber *val = loAlarmStatus;
                int lnAlarmStatus = [val intValue];
                int lnStopStatus = [(NSNumber *)loStopStatus intValue];
//                NSLog((@"Alarmstatus:%d | %d"),lnAlarmStatus,lnStopStatus);
                if (lnAlarmStatus>0|| (lnAlarmStatus==0 && lnStopStatus<=0))
                {
                    switch (lnAlarmStatus)
                    {

                        case 1:
                            [self.m_oAlarmPlants addObject:loObj];
                            break;
                        case 2:
                            [self.m_oDangerPlants addObject:loObj];
                            break;
                            
                        default:
                            [self.m_oNormalPlants addObject:loObj];
                            break;
                    }
                }else if(lnStopStatus>0)
                {
                    [self.m_oStopPlants addObject:loObj];
                    
                }

            }
        }
    }
    
//NSLog(@"%d %d %d %d",[self.m_oAlarmPlants count],[self.m_oDangerPlants count],[self.m_oStopPlants count],[self.m_oNormalPlants count]);
}



#pragma mark 
#pragma mark NSURLRequest Methods
- (void) doLoadData
{
    self.responseData = [[[NSMutableData alloc]initWithCapacity:10]autorelease];
    NSString * lpPostData = [LYGlobalSettings GetPostDataPrefix];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/api/alarm/gethierarchy/",[LYGlobalSettings GetSetting:SETTING_KEY_SERVER_ADDRESS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lpServerAddress] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.responseData setLength:0];
    expectedLength = [response expectedContentLength];
	currentLength = 0;
    if (nil != HUD && expectedLength >0)
    {
       HUD.mode = MBProgressHUDModeDeterminate;
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];
    if (nil!= HUD)
    {
        HUD.progress = currentLength / (float)expectedLength;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self doneLoadingTableViewData];
    self.responseData = nil;
    if (nil!=HUD)
    {
         [HUD hide:YES];
    }
   
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
    self.responseData = nil;
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
    
    NSMutableArray * lpListOfItems = [json objectWithString:responseString error:&error];
    
    if (nil!=lpListOfItems && [lpListOfItems count] != 0)
    {
        if (nil!=self->listOfItems)
        {
            [self->listOfItems release];
        }
        
        self->listOfItems = lpListOfItems;        
        [self->listOfItems retain];
        [self PreparePlantsData];
        [self.m_oTableView reloadData];
    }
    [responseString release];
    
    [self doneLoadingTableViewData];
    [self.m_oActiveIndicator stopAnimating];
    
    if (nil != HUD)
    {
       // HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"";
        [HUD hide:YES afterDelay:0];
    }

}
#pragma mark -
#pragma mark ButtonPressed Methods
- (void)startTimer
{
   [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(OnRefresh)
                                                userInfo: nil repeats:NO];
}
- (void)OnRefresh
{

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    
	[self.navigationController.view addSubview:HUD];
    
	HUD.dimBackground = YES;
    HUD.labelText = @"刷新中";
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(OnHudCallBack) onTarget:self withObject:nil animated:YES];
    [self doLoadData];

}
- (IBAction)OnRefreshButtonPressed:(id)sender
{
    [self startTimer];
    //[self.m_oActiveIndicator startAnimating];
    
}

- (IBAction)OnSearchButtonPressed:(id)sender {
   
}



-(void)onButtonAllDeviceSelected:(UIBarButtonItem *)sender
{
    self.m_pButtonAlarm.style = UIBarButtonItemStylePlain;
    self.m_pButtonDanger.style = UIBarButtonItemStylePlain;
    self.m_pButtonStop.style = UIBarButtonItemStylePlain;
    self.m_pButtonAll.style = UIBarButtonItemStyleDone;
    self.m_pButtonNormal.style = UIBarButtonItemStylePlain;
    self->m_nFilterStatus = ALL;
   
    [self.m_oTableView reloadData];
}

-(void)onButtonAlarmDeviceSelected:(UIBarButtonItem *)sender
{
    self.m_pButtonAlarm.style =UIBarButtonItemStyleDone ;
    self.m_pButtonDanger.style = UIBarButtonItemStylePlain;
    self.m_pButtonStop.style = UIBarButtonItemStylePlain;
    self.m_pButtonAll.style = UIBarButtonItemStylePlain;
    self.m_pButtonNormal.style = UIBarButtonItemStylePlain;
    self->m_nFilterStatus = ALARM;
    
    [self.m_oTableView reloadData];
}

-(void)onButtonDangerDeviceSelected:(UIBarButtonItem *)sender
{
    self.m_pButtonAlarm.style = UIBarButtonItemStylePlain;
    self.m_pButtonDanger.style = UIBarButtonItemStyleDone;
    self.m_pButtonStop.style = UIBarButtonItemStylePlain;
    self.m_pButtonAll.style =UIBarButtonItemStylePlain ;
    self.m_pButtonNormal.style = UIBarButtonItemStylePlain;
    self->m_nFilterStatus = DANGER;
    [self.m_oTableView reloadData];
}

-(void)onButtonStopDeviceSelected:(UIBarButtonItem *)sender
{
    self.m_pButtonAlarm.style = UIBarButtonItemStylePlain;
    self.m_pButtonDanger.style = UIBarButtonItemStylePlain;
    self.m_pButtonStop.style =UIBarButtonItemStyleDone ;
    self.m_pButtonAll.style = UIBarButtonItemStylePlain;
    self.m_pButtonNormal.style = UIBarButtonItemStylePlain;
    self->m_nFilterStatus = STOPPED;
    [self.m_oTableView reloadData];
}


-(void)onButtonNormalDeviceSelected:(UIBarButtonItem *)sender
{
    self.m_pButtonAlarm.style = UIBarButtonItemStylePlain;
    self.m_pButtonDanger.style = UIBarButtonItemStylePlain;
    self.m_pButtonStop.style =UIBarButtonItemStylePlain ;
    self.m_pButtonAll.style = UIBarButtonItemStylePlain;
    self.m_pButtonNormal.style = UIBarButtonItemStyleDone;
    self->m_nFilterStatus = NORMAL;
    
    [self.m_oTableView reloadData];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
     HUD = nil;
}

- (void)OnHudCallBack
{
	// Do something usefull in here instead of sleeping ...
	sleep(1);
}
@end
