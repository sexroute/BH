//
//  LyPlantViewController.m
//  LuckyNumbers
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LYPlantViewController.h"
#import "LYDetailViewController.h"
#include "LYCellviewCell.h"
#import "JSON.h"
#import "LYGlobalSettings.h"
#import "LYSegmentMsgMap.h"
#import "LYFilterViewController.h"
#import "LYUtility.h"
#import "ChannInfo.h"
#import "LYBHUtility.h"


@interface LYPlantViewController ()

@end

@implementation LYPlantViewController


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
@synthesize m_pSegmentMap;
@synthesize responseData;
@synthesize m_oPlantItems;
@synthesize m_oNetOffPlants;
@synthesize m_oNavigationTitleView;
@synthesize m_oSegmentedControl;
@synthesize m_oRequest;

#pragma mark 初始化

- (id)init
{
    self = [super init];
    self.m_pSegmentMap = nil;
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.m_oActiveIndicator stopAnimating];
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    
    //1.segment view
    if (nil ==self.m_pSegmentMap)
    {
        self.m_pSegmentMap = [[[NSMutableArray alloc] init]autorelease];
        
        LYSegmentMsgMap * lpVal =[[[LYSegmentMsgMap alloc]init]autorelease];
        lpVal.m_pSegmentMsgIndex = [NSNumber numberWithInt:0];
        lpVal.m_pSegmentMsgHandle = @selector(onButtonAllDeviceSelected:);
        
        lpVal.m_pSegmentTitle = @"全部";
        [self.m_pSegmentMap addObject:lpVal];
        
        
        LYSegmentMsgMap * lpValDangrous =[[[LYSegmentMsgMap alloc]init]autorelease];
        lpValDangrous.m_pSegmentMsgIndex = [NSNumber numberWithInt:1];
        lpValDangrous.m_pSegmentMsgHandle = @selector(onButtonDangerDeviceSelected:);
        lpValDangrous.m_pSegmentTitle = @"危险";
        [self.m_pSegmentMap addObject:lpValDangrous];
        
        
        LYSegmentMsgMap * lpValAlarm =[[[LYSegmentMsgMap alloc]init]autorelease];
        lpValAlarm.m_pSegmentMsgIndex = [NSNumber numberWithInt:2];
        lpValAlarm.m_pSegmentMsgHandle = @selector(onButtonAlarmDeviceSelected:);
        lpValAlarm.m_pSegmentTitle = @"报警";
        [self.m_pSegmentMap addObject:lpValAlarm];
        
        
        LYSegmentMsgMap * lpValNormal =[[[LYSegmentMsgMap alloc]init]autorelease];
        lpValNormal.m_pSegmentMsgIndex = [NSNumber numberWithInt:3];
        lpValNormal.m_pSegmentMsgHandle = @selector(onButtonNormalDeviceSelected:);
        lpValNormal.m_pSegmentTitle = @"正常";
        [self.m_pSegmentMap addObject:lpValNormal];
        
        
        
        LYSegmentMsgMap * lpValStopped =[[[LYSegmentMsgMap alloc]init]autorelease];
        lpValStopped.m_pSegmentMsgIndex = [NSNumber numberWithInt:4];
        lpValStopped.m_pSegmentMsgHandle = @selector(onButtonStopDeviceSelected:);
        lpValStopped.m_pSegmentTitle = @"停车";
        [self.m_pSegmentMap addObject:lpValStopped];
        
        
        
        LYSegmentMsgMap * lpValNoval =[[[LYSegmentMsgMap alloc]init]autorelease];
        lpValNoval.m_pSegmentMsgIndex = [NSNumber numberWithInt:5];
        lpValNoval.m_pSegmentMsgHandle = @selector(onButtonNetOffDeviceSelected:);
        lpValNoval.m_pSegmentTitle = @"断网";
        [self.m_pSegmentMap addObject:lpValNoval];        
    }
    
    
    NSMutableArray * segmentItems  = [[[NSMutableArray alloc]init]autorelease];
    for (int i =0; i<self.m_pSegmentMap.count; i++)
    {
        LYSegmentMsgMap * lpFired = [self.m_pSegmentMap objectAtIndex:i];
        [segmentItems addObject:lpFired.m_pSegmentTitle];
    }
    
    self.m_oSegmentedControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    self.m_oSegmentedControl.frame = CGRectMake(0,0,self.view.frame.size.width,40);
    self.m_oSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.m_oSegmentedControl.selectedSegmentIndex = 0;

    [self.m_oSegmentedControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    
    self.m_oSegmentedControl.tintColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.m_oSegmentedControl];
    
    
    //2.table view
    CGRect loFrame = self.view.frame;
    loFrame.origin.y = self.m_oSegmentedControl.frame.size.height;

    int lnTabBarHeight = self.tabBarController.tabBar.frame.size.height;
    loFrame.size.height = loFrame.size.height -lnTabBarHeight+10;
     self.m_oTableView = [[[UITableView alloc] initWithFrame:loFrame]autorelease];
    
    
    self.m_oTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.m_oTableView.contentMode = UIViewContentModeRedraw;
   
    [self.m_oTableView setDataSource:self];
    [self.m_oTableView setDelegate:self];
    
    self.navigationController.navigationBar.barStyle = [LYGlobalSettings GetSettingInt:SETTING_KEY_STYLE];
    
    //3.拖拽刷新
    if (_refreshHeaderView == nil)
    {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.m_oTableView.bounds.size.height, self.view.frame.size.width, self.m_oTableView.bounds.size.height)];
        view.delegate = self;
        [self.m_oTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
        
    }
    
    
    //4.navigation item
    
    [_refreshHeaderView refreshLastUpdatedDate];
    loFrame = CGRectMake(0, 0, 400, 44);
      
    self.m_oNavigationTitleView = [[[UILabel alloc] initWithFrame:loFrame] autorelease];
    self.m_oNavigationTitleView.backgroundColor = [UIColor clearColor];
    self.m_oNavigationTitleView.font = [UIFont boldSystemFontOfSize:17.0];
    self.m_oNavigationTitleView.textAlignment = UITextAlignmentCenter;
    self.m_oNavigationTitleView.textColor = [UIColor whiteColor];
    self.m_oNavigationTitleView.text = @"全部设备";


    
    self.navigationItem.titleView = self.m_oNavigationTitleView;
    self.navigationItem.title = @"设备列表";
    
    [self.navigationController setToolbarHidden:FALSE animated:FALSE];
    
    [self.view addSubview:self.m_oTableView];
    
    //5.bottom button
    self.navigationController.toolbar.barStyle = [LYGlobalSettings GetSettingInt:SETTING_KEY_STYLE];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
}

- (void)TuneRect
{
    //1.segment control
    self.m_oSegmentedControl.frame = CGRectMake(0,0,self.view.frame.size.width,40);
    
    //2.tableview
    CGRect loFrame = self.view.frame;
    loFrame.origin.y = self.m_oSegmentedControl.frame.size.height;
    
    int lnTabBarHeight = self.tabBarController.tabBar.frame.size.height;
    loFrame.size.height = loFrame.size.height -lnTabBarHeight+10;
    self.m_oTableView.frame = loFrame;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    [self TuneRect];
}

- (void) onSegmentedControlChanged:(UISegmentedControl *) sender
{
    if (nil== sender)
    {
        return;
    }
    // lazy load data for a segment choice (write this based on your data)
    int lnSelectedIndex = [(UISegmentedControl *) sender selectedSegmentIndex];
    
    if (lnSelectedIndex<self.m_pSegmentMap.count)
    {
        LYSegmentMsgMap * lpFired = [self.m_pSegmentMap objectAtIndex:lnSelectedIndex];
        SEL lpFun = lpFired.m_pSegmentMsgHandle;
        [self performSelector:lpFun];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.m_oTableView reloadData];
    [self TuneRect];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.m_oRequest setDelegate:nil];
    [self.m_oRequest cancel];
    self.m_oRequest = nil;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll; // etc
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL lbRet = (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return  lbRet;
}

- (BOOL)shouldAutorotate {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation==UIInterfaceOrientationPortrait)
    {
       return YES;        
    }
    
    return NO;
}

#pragma mark 析构
- (void)viewDidUnload
{
    
    
    [self setM_oTableView:nil];
    [self setM_oActiveIndicator:nil];
    [super viewDidUnload];
    _refreshHeaderView=nil;
    self.m_oAlarmPlants = nil;
    self.m_oDangerPlants = nil;
    self.m_oStopPlants = nil;
    self.m_pSegmentMap = nil;
    self.m_oPlantItems = nil;
    self.m_oNavigationTitleView = nil;
    self.m_oSegmentedControl = nil;
}

- (void)dealloc {
    _refreshHeaderView = nil;
    
    [m_oTableView release];
    [m_oActiveIndicator release];
    [super dealloc];
    
}



#pragma mark - Table view data source
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
    id loNetoffStatus = [[lpPlants objectAtIndex:i] objectForKey:@"netoff_status"];
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
                    
                    NSInteger lnAlarmStatus = [loAlarmStatus intValue];
                    NSInteger lnStopStatus = [loStopStatus intValue];
                    int lnNetoffStatus = [loNetoffStatus intValue];
                    
                    cell = (LYCellviewCell *)currentObject;
                    
                    cell.m_lblPlantid.text = [self GetStringFromID:loplantid];

                    NSString * lpStreRpm = [self GetStringFromID:loRpm];
                    int lnValueRpm = [lpStreRpm integerValue];
                    if (lnValueRpm<0)
                    {
                        lpStreRpm = [[[NSString alloc] initWithUTF8String:"0"]autorelease];
                        cell.m_plblRpm.text = lpStreRpm;
                    
                    }else
                    {
                        cell.m_plblRpm.text = [self GetStringFromID:loRpm];
                    }
                    
                    cell.m_plblRpm.textAlignment = UITextAlignmentRight;
                    
#ifdef DEBUG
                    //                    NSLog(@"%@:%@",lpAlarmStatus,lpStopStatus);
#endif
                    if (nil != loAlarmStatus)
                    {
                        if (2 == lnAlarmStatus)
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1]autorelease];
                            cell.m_plblOrg.text = lpResult;
                            [cell.m_plblOrg setNumberOfLines:0];
                            [cell.m_plblOrg sizeToFit];
                        }else if (1 == lnAlarmStatus)
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:1]autorelease];
                        } else if (1== lnNetoffStatus)
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1]autorelease];
                            cell.m_plblRpm.text =[NSString stringWithFormat:@"0"];
                            cell.m_plblOrg.text = [NSString stringWithFormat:@"%@(断网) ",cell.m_plblOrg.text];
                            [cell.m_plblOrg setNumberOfLines:0];
                            [cell.m_plblOrg sizeToFit];
                        }if (1 == lnStopStatus)
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:0.4 green:0.4 blue:0.4 alpha:1]autorelease];
                            cell.m_plblOrg.text = lpResult;
                            [cell.m_plblOrg setNumberOfLines:0];
                            [cell.m_plblOrg sizeToFit];
                            
                        }else
                        {
                            cell.m_plblOrg.text = lpResult;
                            [cell.m_plblOrg setNumberOfLines:0];
                            [cell.m_plblOrg sizeToFit];
                        }
                        
                    }else
                    {
                        if (1== lnNetoffStatus)
                        {
                            cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1]autorelease];
                        }else
                            if (1 == lnStopStatus  )
                            {
                                cell.m_pImgStatus.backgroundColor = [[[UIColor alloc] initWithRed:0.4 green:0.4 blue:0.4 alpha:1]autorelease];
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
            lpPlants = self.m_oPlantItems;
            self.m_oNavigationTitleView.text =[NSString stringWithFormat: @"全部设备"];
            break;
        case ALARM:
            lpPlants = self.m_oAlarmPlants;
            self.m_oNavigationTitleView.text =[NSString stringWithFormat: @"报警设备"];
            break;
        case DANGER:
            lpPlants = self.m_oDangerPlants;
            self.m_oNavigationTitleView.text =[NSString stringWithFormat: @"危险设备"];
            break;
        case STOPPED:
            lpPlants = self.m_oStopPlants;
            self.m_oNavigationTitleView.text =[NSString stringWithFormat: @"停车设备"];
            break;
        case NORMAL:
            lpPlants = self.m_oNormalPlants;
            self.m_oNavigationTitleView.text =[NSString stringWithFormat: @"正常设备"];
            break;
        case NETOFF:
            lpPlants = self.m_oNetOffPlants;
            self.m_oNavigationTitleView.text =[NSString stringWithFormat: @"断网设备"];
            break;
            
        default:
            lpPlants = self.m_oPlantItems;
            break;
    }
    
    NSString * lpSelectedGroup = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_GROUP];
    NSString * lpSelectedCompany = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_COMPANY];
    NSString * lpSelectedFactory = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_FACTORY];
    NSString * lpSelectedSet = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_SET];
    
    NSString * lpSelectedMachineType = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_PLANT_TYPE];
    
    int lnSelectedMachineType = -1;
    if (![LYUtility IsStringEmpty:lpSelectedMachineType])
    {
        lpSelectedMachineType = [LYUtility StringTrim:lpSelectedMachineType];
        if ([lpSelectedMachineType compare:MACHINE_TYPE_RC] == NSOrderedSame)
        {
            lnSelectedMachineType = MACHINE_TYPE_RC_GENERIC;
        }else if ([lpSelectedMachineType compare:MACHINE_TYPE_ROTATION] == NSOrderedSame)
        {
            lnSelectedMachineType = MACHINE_TYPE_ROTATION_GENERIC;
        }else if ([lpSelectedMachineType compare:MACHINE_TYPE_PUMP] == NSOrderedSame)
        {
            lnSelectedMachineType = MACHINE_TYPE_PUMP_GENERIC;
        }else if ([lpSelectedMachineType compare:MACHINE_TYPE_WIND] == NSOrderedSame)
        {
            lnSelectedMachineType = MACHINE_TYPE_WIND_GENERIC;
        }
        
    }
    
    NSMutableArray * lpPlantsRet = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<lpPlants.count; i++)
    {
        NSString * logroupid = [[lpPlants objectAtIndex:i] objectForKey:@"groupid"];
        NSString * locompanyid = [[lpPlants objectAtIndex:i] objectForKey:@"companyid"];
        NSString * lofactoryid = [[lpPlants objectAtIndex:i] objectForKey:@"factoryid"];
        NSString * losetid = [[lpPlants objectAtIndex:i] objectForKey:@"setid"];
        NSString * lpPlantType = [[lpPlants objectAtIndex:i] objectForKey:@"machine_type"];
        
        logroupid = [((NSString*) logroupid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        locompanyid = [((NSString*) locompanyid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        lofactoryid = [((NSString*) lofactoryid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        losetid = [((NSString*) losetid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //        lpPlantType = [((NSString*) lpPlantType) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        int lnMachine_Type = [lpPlantType intValue];
        
        if (![LYUtility IsStringEmpty:lpSelectedGroup])
        {
            if ([lpSelectedGroup compare:logroupid]!= NSOrderedSame)
            {
                continue;
            }
        }
        
        if (![LYUtility IsStringEmpty:lpSelectedCompany])
        {
            if ([lpSelectedCompany compare:locompanyid]!= NSOrderedSame)
            {
                continue;
            }
        }
        
        if (![LYUtility IsStringEmpty:lpSelectedFactory])
        {
            if ([lpSelectedFactory compare:lofactoryid]!= NSOrderedSame)
            {
                continue;
            }
        }
        
        if (![LYUtility IsStringEmpty:lpSelectedSet])
        {
            if ([lpSelectedSet compare:losetid]!= NSOrderedSame)
            {
                continue;
            }
        }
        
        if (lnSelectedMachineType>=0)
        {
            lnMachine_Type = [LYBHUtility GetPlantType:lnMachine_Type];
            
            if (lnMachine_Type!= lnSelectedMachineType)
            {
                continue;
            }
        }
        
        [lpPlantsRet addObject:[lpPlants objectAtIndex:i]];
        
    }
    
    NSString * lstrTitle =[NSString stringWithFormat:@"%@(%d台)" ,self.m_oNavigationTitleView.text,lpPlantsRet.count];
    self.m_oNavigationTitleView.text = lstrTitle;
    return lpPlantsRet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1.load from storyboard
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    return;
    
    
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    LYDetailViewController *detailViewController = (LYDetailViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier: @"DetailView"];
    int i= indexPath.row;
    
    [self.navigationController setToolbarHidden:YES animated:TRUE] ;
    detailViewController.m_pPlantInfoData = [[self GetCurrentDataSource] objectAtIndex:i];
    [self.navigationController pushViewController:detailViewController animated:YES];
    return;
    
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.m_oTableView];
    
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
    self.m_oNetOffPlants = [[[NSMutableArray alloc] initWithCapacity:10]autorelease];
    if (nil != self.m_oPlantItems)
    {
        int lnSize = [self.m_oPlantItems count];
        for (int i=0; i<lnSize; i++)
        {
            id loObj = [m_oPlantItems objectAtIndex:i];
            if (nil == loObj) {
                continue;
            }
            id loAlarmStatus = [loObj objectForKey:@"alarm_status"];
            id loStopStatus = [loObj objectForKey:@"stop_status"];
            id lnNetOffStatus = [loObj objectForKey:@"netoff_status"];
            if (nil!= loAlarmStatus && nil!= loStopStatus)
            {
                NSNumber *val = loAlarmStatus;
                int lnAlarmStatus = [val intValue];
                int lnStopStatus = [(NSNumber *)loStopStatus intValue];
                int lnnNetoff_status= [(NSNumber *)lnNetOffStatus intValue];
                //                NSLog((@"Alarmstatus:%d | %d"),lnAlarmStatus,lnStopStatus);
                if (lnAlarmStatus>0|| (lnAlarmStatus==0 && lnStopStatus<=0 && lnnNetoff_status<=0))
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
                }
                if (lnnNetoff_status>0)
                {
                    [self.m_oNetOffPlants addObject:loObj];
                }
                else if(lnStopStatus>0)
                {
                    [self.m_oStopPlants addObject:loObj];
                    
                }
                
            }
        }
    }
    
    //NSLog(@"%d %d %d %d",[self.m_oAlarmPlants count],[self.m_oDangerPlants count],[self.m_oStopPlants count],[self.m_oNormalPlants count]);
}

- (void) doLoadData
{
    [self doLoadDataUseASIHTTP];
}

#pragma mark ASIHTTPRequest Methods
- (void) doLoadDataUseASIHTTP
{
    self.responseData = [[[NSMutableData alloc]initWithCapacity:10]autorelease];
    NSString * lpPostData = [LYGlobalSettings GetPostDataPrefix];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/alarm/gethierarchy/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    NSURL* url = [NSURL URLWithString:lpServerAddress];
    

    
    
    self.m_oRequest = [ASIFormDataRequest  requestWithURL:url];
    [self.m_oRequest setRequestMethod:@"POST"];
    [self.m_oRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [self.m_oRequest appendPostData:requestBody];
    [self.m_oRequest setDelegate:self];
    [self.m_oRequest setTimeOutSeconds:NETWORK_TIMEOUT];
   	[self.m_oRequest startAsynchronous];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    self.responseData =[NSMutableData dataWithData:[request responseData]] ;
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
    self.responseData = nil;
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
    
    NSMutableArray * lpListOfItems = [json objectWithString:responseString error:&error];
    
    if (nil!=lpListOfItems && [lpListOfItems count] != 0)
    {
        
        
        self.m_oPlantItems = lpListOfItems;
        [self PreparePlantsData];
        [self.m_oTableView reloadData];
    }
    [responseString release];
    
    [self doneLoadingTableViewData];
    [self.m_oActiveIndicator stopAnimating];
    
    if (nil != HUD)
    {
        [HUD hide:YES afterDelay:0];
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    self.responseData = nil;
    if (nil!=HUD)
    {
        [HUD hide:YES];
    }
}


#pragma mark NSURLRequest Methods
-(void) doLoadDataUseNSConnection
{
    self.responseData = [[[NSMutableData alloc]initWithCapacity:10]autorelease];
    NSString * lpPostData = [LYGlobalSettings GetPostDataPrefix];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/alarm/gethierarchy/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lpServerAddress] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:NETWORK_TIMEOUT];
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
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    [self doneLoadingTableViewData];
    self.responseData = nil;
    if (nil!=HUD)
    {
        [HUD hide:YES];
    }
    [connection release];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
    self.responseData = nil;
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
    
    NSMutableArray * lpListOfItems = [json objectWithString:responseString error:&error];
    
    if (nil!=lpListOfItems && [lpListOfItems count] != 0)
    {
        
        
        self.m_oPlantItems = lpListOfItems;
        [self PreparePlantsData];
        [self.m_oTableView reloadData];
    }
    [responseString release];
    
    [self doneLoadingTableViewData];
    [self.m_oActiveIndicator stopAnimating];
    
    if (nil != HUD)
    {
        [HUD hide:YES afterDelay:0];
    }
    
    [connection release];
    
}
#pragma mark -
#pragma mark ButtonPressed Methods
- (void)startTimer
{
    [self OnRefresh];
}
- (void)OnRefresh
{
    [self PopulateIndicator];
    [self doLoadData];
    
}
- (IBAction)OnRefreshButtonPressed:(id)sender
{
    [self startTimer];
    
    
}

- (IBAction)OnFilterButtonPressed:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    
    LYFilterViewController  *lpviewController = (LYFilterViewController *)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"LYFilterViewController"];
    
    lpviewController.m_oAllItems = self.m_oPlantItems;
    
    
    lpviewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController pushViewController:lpviewController animated:YES];
    
    [UIView commitAnimations];
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

-(void)onButtonNetOffDeviceSelected:(UIBarButtonItem *)sender
{
    self.m_pButtonAlarm.style = UIBarButtonItemStylePlain;
    self.m_pButtonDanger.style = UIBarButtonItemStylePlain;
    self.m_pButtonStop.style =UIBarButtonItemStyleDone ;
    self.m_pButtonAll.style = UIBarButtonItemStylePlain;
    self.m_pButtonNormal.style = UIBarButtonItemStylePlain;
    self->m_nFilterStatus = NETOFF;
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

- (void)hudWasHidden:(MBProgressHUD *)apHud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
    
}

- (void)PopulateIndicator
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
    [self.navigationController.view bringSubviewToFront:HUD];
}

- (void)OnHudCallBack
{
	// Do something usefull in here instead of sleeping ...
    sleep(NETWORK_TIMEOUT*2);
}
@end
