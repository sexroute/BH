//
//  LYChannInfoViewController.m
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#import "LYChannInfoViewController.h"
#import "LYWaveViewController.h"
#import "LYBHUtility.h"


@implementation LYChannInfoViewController
@synthesize m_pData;
@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrChann;
@synthesize m_pStrPlant;
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
    if (nil != self.m_pData)
    {
         self.navigationItem.title = [self.m_pData objectForKey:@"name"];
    }
    int lnChanntype  = [self GetChanntype];
    lnChanntype = [LYBHUtility GetChannType:lnChanntype];
    switch (lnChanntype)
    {
        case E_TBL_CHANNTYPE_VIB:
        case E_TBL_CHANNTYPE_DYN:
            self.m_oNavigateButton.title = @"波形/频谱";
            break;
        case E_TBL_CHANNTYPE_PROC:
            self.m_oNavigateButton.title = @"历史趋势";
            break;
        default:
            break;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(int)GetChanntype
{
    id lpObj = [self.m_pData objectForKey:@"chann_type"];
    NSNumber * lpVal = lpObj;
    int lnChanType = [lpVal intValue];
    return  lnChanType;
}

- (void)viewDidUnload
{
    [self setM_oNavigateButton:nil];
    [super viewDidUnload];
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
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"基本信息", @"Basic Chann Info");
            break;
        case 1:
            title = NSLocalizedString(@"报警信息", @"Alarm Chann Info");
            break;

        default:
            break;
    }
    return title;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    int lnReturnValue = 0;
    switch (section) {
        case 0:
            lnReturnValue = 8;
            break;
        case 1:
            lnReturnValue = 6;
            break;
        default:
            break;
    }
    return lnReturnValue;
}

//GE_ALLPROC          = 0,        /*!所有过程量测点*/
//GE_VIBCHANN         = 1,        /*!径向振动测点.*/
//GE_AXIALCHANN       = 2,        /*!轴向振动测点.axial displacement*/
//GE_PRESSCHANN       = 3,        /*!压力测点.*/
//GE_TEMPCHANN        = 4,        /*!温度测点.*/
//GE_FLUXCHANN        = 5,        /*!流量测点.*/
//GE_OTHERCHANN       = 6,        /*!其它.*/
//GE_IMPACTCHANN      = 7,        ///撞击通道
//GE_CURRENTCHANN     = 8,        ///电流测点
//GE_DYNPRESSCHANN    = 11,       ///动态压力信号
//GE_RODSINKCHANN     = 12,       ///活塞杆下沉量信号
//GE_DYNSTRESSCHANN   = 13,       /* !动态应力测点*/
//GE_AXISLOCATIONCHANN= 100       /*!轴心位置*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
    id lpObj = nil;
    NSString * lpTitle = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                    lpObj = [self.m_pData objectForKey:@"name"];
                    lpTitle = @"测 点 名";
                    self.m_pStrChann = lpObj;
                    break;
                case 1:
                    lpObj = [self.m_pData objectForKey:@"alias_name"];
                    lpTitle = @"测点别名";
                    break;
                case 2:
                    
                    lpObj = [self.m_pData objectForKey:@"chann_type"];
                    NSNumber * lpVal = lpObj;
                    int lnChanType = [lpVal intValue];
                    self.m_nChannType = lnChanType;
                    switch (lnChanType) {
                        case GE_ALLPROC:
                            lpObj = @"过程量测点";
                            break;
                        case GE_VIBCHANN:
                            lpObj = @"径向振动测点";
                            break;
                        case GE_AXIALCHANN:
                            lpObj = @"轴向振动测点";
                            break;
                        case GE_PRESSCHANN:
                            lpObj = @"压力测点";
                            break;
                        case GE_TEMPCHANN:
                            lpObj = @"温度测点";
                            break;
                        case GE_OTHERCHANN:
                            lpObj = @"其它类型测点";
                            break;
                        case GE_FLUXCHANN:
                            lpObj = @"流量测点";
                            break;
                        case GE_IMPACTCHANN:
                            lpObj = @"撞击测点";
                            break;
                        case GE_CURRENTCHANN:
                            lpObj = @"电流测点";
                            break;
                        case GE_DYNPRESSCHANN:
                            lpObj = @"动态压力信号";
                            break;
                        case GE_RODSINKCHANN:
                            lpObj = @"活塞杆下沉量信号";
                            break;
                        case GE_DYNSTRESSCHANN:
                            lpObj = @"动态应力测点";
                            break;
                        case GE_AXISLOCATIONCHANN:
                            lpObj = @"轴心位置";                           
                            break;
                        default:
                            break;
                    }
                    lpTitle = @"测点别名";
                    break;
                case 3:
                    lpTitle = @"更新时间";
                    lpObj = [self.m_pData objectForKey:@"datetime"];
                    break;
                case 4:
                    lpTitle = @"转   速";
                    lpObj = [self.m_pData objectForKey:@"rev"];
                    break;
                case 5:
                    lpTitle = @"当前值 ";
                    lpObj = [self.m_pData objectForKey:@"val"];
                    break;
                case 6:
                    lpTitle = @"单   位";
                    lpObj = [self.m_pData objectForKey:@"unit"];
                    break;
                case 7:
                    lpTitle = @"报警状态";
                    lpObj = [self.m_pData objectForKey:@"alarm_status"];
                    int lnAlarmStatus = [(NSNumber *)lpObj intValue];
                    switch (lnAlarmStatus) {
                        case 0:
                            lpObj = @"正常";
                            break;
                        case 1:
                            lpObj = @"报警";
                            break;
                        case 2:
                            lpObj = @"危险";
                            break;
                        default:
                            break;
                    }
                    
                    break;
                default:
                    break; 
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 2:
                    lpTitle = @"高高报线";
                    lpObj = [self.m_pData objectForKey:@"HH"];
                    break;
                case 3:
                    lpTitle = @"高低报线";
                    lpObj = [self.m_pData objectForKey:@"HL"];
                    break;
                case 4:
                    lpTitle = @"低低报线";
                    lpObj = [self.m_pData objectForKey:@"LL"];
                    break;
                case 5:
                    lpTitle = @"低高报线";
                    lpObj = [self.m_pData objectForKey:@"LH"];
                    break;
                case 0:
                    lpTitle = @"当 前 值";
                    lpObj = [self.m_pData objectForKey:@"val"];
                    break;
                case 1:
                    lpTitle = @"报警状态";
                    lpObj = [self.m_pData objectForKey:@"alarm_status"];
                    int lnAlarmStatus = [(NSNumber *)lpObj intValue];
                    switch (lnAlarmStatus) {
                        case 0:
                            lpObj = @"正常";
                            break;
                        case 1:
                            lpObj = @"报警";
                            break;
                        case 2:
                            lpObj = @"危险";
                            break;
                        default:
                            break;
                    }
                default:
                    break;
            }
        default:
            break;
    }
    
    if (nil!= lpObj)
    {
       cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",lpTitle,lpObj ];
        
    }

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

    return;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //    NSString *Title;
    NSLog(@"%@",[segue identifier]);
    if ([[segue identifier] isEqualToString:@"PushToWave"])
    {
        LYWaveViewController * lpChannView = [segue destinationViewController];
        lpChannView.m_pStrGroup = self.m_pStrGroup;
        lpChannView.m_pStrCompany = self.m_pStrCompany;
        lpChannView.m_pStrFactory = self.m_pStrFactory;
        lpChannView.m_pStrChann = self.m_pStrChann;
        lpChannView.m_pStrPlant = self.m_pStrPlant;
        lpChannView.m_nChannType = self.m_nChannType;
        NSLog(@"%@",lpChannView.m_pStrGroup);
    }
    
}

- (void)dealloc {
    [_m_oNavigateButton release];
    [super dealloc];
}
@end
